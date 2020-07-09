//
//  RequestsAPIYandexDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 29.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import Alamofire
import RxSwift
import RxCocoa

enum StatusErrorForGetRequestAPIYandex{
    case ERR_OK
    case ERR_KEY_INVALID
    case ERR_KEY_BLOCKED
    case ERR_DAILY_REQ_LIMIT_EXCEEDED
    case ERR_TEXT_TOO_LONG
    case ERR_LANG_NOT_SUPPORTED
    var error: (num: Int, nameError: String){
        switch self {
        case .ERR_OK :  return (200, "ERR_OK")
        case .ERR_KEY_INVALID : return (401, "ERR_KEY_INVALID")
        case .ERR_KEY_BLOCKED : return (402, "ERR_KEY_BLOCKED")
        case .ERR_DAILY_REQ_LIMIT_EXCEEDED : return (403, "ERR_DAILY_REQ_LIMIT_EXCEEDED")
        case .ERR_TEXT_TOO_LONG : return (413, "ERR_TEXT_TOO_LONG")
        case .ERR_LANG_NOT_SUPPORTED : return (501, "ERR_LANG_NOT_SUPPORTED")
        }
    }
}

enum TranslationDirection: String{
    case EnRu = "en-ru"
    case RuEn = "ru-en"
}

class RequestsAPIYandexDictionary {

    static let Shared = RequestsAPIYandexDictionary()

    var publishSubjectResponseYAPI = PublishSubject<WordCodableJSON?>()

    private init(){
        print("init RequestAPIYandexDictionary")
    }

    deinit {
        print("deinit RequestAPIYandexDictionary")
    }

    func requestTranslate(requestWord: String, translationDirection: TranslationDirection) -> PublishSubject<WordCodableJSON?> {
        let trDir = translationDirection.rawValue
        let urlString = "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=dict.1.1.20200707T204930Z.ad0118aaace6d7cf.8e79f678653ae9589a3d414cfc330579d3d2dceb&lang=\(trDir)&text=\(requestWord)"
        let url = URL.init(string: urlString)!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.dataTaskMy(with: url) { result in
            switch result {
            case .success((let data, let response)):
                guard response.statusCode == 200 else {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("error = ",jsonString)
                    }
                    return
                }
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("data = ",jsonString)
//                }
                let decoder = JSONDecoder()
                do{
                    let word = try decoder.decode(WordCodableJSON.self, from: data)
                    self.publishSubjectResponseYAPI.onNext(word)
                    print("Status code = ", response.statusCode)
                    //                dump(word)
                } catch (let error) {
                    print(error)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }.resume()
        return self.publishSubjectResponseYAPI
    }

}
