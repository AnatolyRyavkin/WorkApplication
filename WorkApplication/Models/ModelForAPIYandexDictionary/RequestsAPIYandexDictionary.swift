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
import RxSwift
import RxCocoa
import Alamofire




class RequestsAPIYandexDictionary {

    static let Shared = RequestsAPIYandexDictionary()

    var disposeBag = DisposeBag()
    
    private init(){
        print("init RequestAPIYandexDictionary")
    }
    deinit {
        print("deinit RequestAPIYandexDictionary")
    }


    //MARK- POST

    func POSTRequestWordFull(requestWord: String, translationDirection: TranslationDirection) -> Observable<MyResponse> {

        let trDir = translationDirection.rawValue

        let urlString = "https://dictionary.yandex.net/api/v1/dicservice.json/lookup"

        let body = "key=dict.1.1.20200707T204930Z.ad0118aaace6d7cf.8e79f678653ae9589a3d414cfc330579d3d2dceb&lang=\(trDir)&text=\(requestWord)".data(using: .utf8)

        let url = URL.init(string: urlString)!

        let request = self.getRequestFull(urlStringComponent: nil, preferensURLConvertabele: url, params: nil, metodString: "POST", paramsForHeader: nil, body: body)!

        let session = URLSession.init(configuration: URLSessionConfiguration.default)

        return Observable<MyResponse>.create { (observer) -> Disposable in

            session.dataTaskMy(with: request) { (result: Res)  in
                switch result {
                case .success((let data, let response)):
                    switch response.statusCode {
                    case 200:
                        do{
                            let decoder = JSONDecoder()
                            let wordCodable = try decoder.decode(WordCodableJSON.self, from: data)
                            if let wordObjectRealm = WordObjectRealm.init(wordCodable: wordCodable){
                                observer.onNext(.success(wordObjectRealm))
                                if let jsonString = String(data: data, encoding: .utf8) {
                                    print(jsonString)
                                }
                            }else{
                                #if DEBUG
                                if let jsonString = String(data: data, encoding: .utf8) {
                                    print(jsonString)
                                }
                                #endif
                                observer.onNext(.failure(.ERR_DONT_PARSING_WORD_OBJECT_REALM))
                            }
                        } catch (_) {
                            observer.onNext(.failure(.ERR_DONT_GET_WORD_CODABLE_JSON))
                        }
                    case 400:
                        do{
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            if  let dictionary = json as? [String : Any] {
                                if let code = dictionary["code"] as? Int{
                                    let error = ErrorForGetRequestAPIYandex.makeSelfAtCode(code: code)
                                    observer.onNext(.failure(error))
                                }
                            } else {
                                print("JSON is invalid")
                                observer.onNext(.failure(.ERR_UNKNOWN))
                            }
                        } catch (_) {
                            observer.onNext(.failure(.ERR_UNKNOWN))
                        }
                    case 401:
                        observer.onNext(.failure(.ERR_KEY_INVALID))
                    case 402:
                        observer.onNext(.failure(.ERR_KEY_BLOCKED))
                    case 403:
                        observer.onNext(.failure(.ERR_DAILY_REQ_LIMIT_EXCEEDED))
                    case 413:
                        observer.onNext(.failure(.ERR_TEXT_TOO_LONG))
                    case 501:
                        observer.onNext(.failure(.ERR_LANG_NOT_SUPPORTED))
                    default:
                        observer.onNext(.failure(.ERR_UNKNOWN))
                    }
                case .failure(let error):
                    switch (error as NSError).code {
                    case 401:
                        observer.onNext(.failure(.ERR_KEY_INVALID))
                    case 402:
                        observer.onNext(.failure(.ERR_KEY_BLOCKED))
                    case 403:
                        observer.onNext(.failure(.ERR_DAILY_REQ_LIMIT_EXCEEDED))
                    case 413:
                        observer.onNext(.failure(.ERR_TEXT_TOO_LONG))
                    case 501:
                        observer.onNext(.failure(.ERR_LANG_NOT_SUPPORTED))
                    case 400:
                        observer.onNext(.failure(.BAD_REQUEST))
                    case 404:
                        observer.onNext(.failure(.NOT_FOUND))
                    case 600 ... 800 :
                        observer.onNext(.failure(.DONT_INTERNET))
                    case -2000 ... -1 :
                        observer.onNext(.failure(.DONT_INTERNET))
                    default:
                        observer.onNext(.failure(.ERR_UNKNOWN))
                    }
                }
            }.resume()
            return Disposables.create()
        }
        .observeOn(MainScheduler.instance)
    }


    //MARK- POSTRequest -> Observable<WordObjectRealm> with trows

    func getObservableWord(requestWord: String, translationDirection: TranslationDirection,
                           handlerError: @escaping (Error) throws -> Observable<WordObjectRealm>) -> Observable<WordObjectRealm> {
        return self.POSTRequestWordFull(requestWord: requestWord, translationDirection: translationDirection)
            .flatMap { (response) throws -> Observable<WordObjectRealm> in
                switch response {
                case .success(let wordObjectRealm) :
                    return Observable<WordObjectRealm>.of(wordObjectRealm)
                case .failure(let error):
                    return Observable.error(error)
                }
        }
        .catchError(handlerError)
    }

    func getWord(requestWord: String, translationDirection: TranslationDirection,
                           handlerError: @escaping (Error) throws -> Observable<WordObjectRealm> , observerSuccess: @escaping (WordObjectRealm) -> Void) throws -> Disposable{
        return self.POSTRequestWordFull(requestWord: requestWord, translationDirection: translationDirection)
            .flatMap { (response) throws -> Observable<WordObjectRealm> in
                switch response {
                case .success(let wordObjectRealm) :
                    return Observable<WordObjectRealm>.of(wordObjectRealm)
                case .failure(let error):
                    return Observable.error(error)
                }
        }
        .catchError(handlerError)
        .subscribe(onNext: observerSuccess)

    }


    //MARK- MakeRequest

    func getRequestFull(urlStringComponent: (sheme: String, host: String, path: String)? = nil ,preferensURLConvertabele urlConvertabele : URLConvertible? = nil, params: [String:String]? = nil, metodString: String, paramsForHeader: [String : String]? = nil, body: Data? = nil) -> URLRequest? {

        var urlComponents: URLComponents

        if let url = try? urlConvertabele?.asURL() {
            urlComponents = URLComponents.init(url: url, resolvingAgainstBaseURL: false)!
        }
        else{
            guard let urlStrComp = urlStringComponent else{
                print("error URLComponentString")
                return nil
            }
            urlComponents = URLComponents.init()
            urlComponents.scheme = urlStrComp.sheme
            urlComponents.host = urlStrComp.host
            urlComponents.path = urlStrComp.path
        }

        var items = [URLQueryItem]()
        if let params = params {
            for (key,value) in params {
                items.append(URLQueryItem(name: key, value: value))
            }
        }
        items = items.filter{!$0.name.isEmpty}
        if !items.isEmpty {
            urlComponents.queryItems = items
        }

        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = metodString
        if let httpBody = body{
            urlRequest.httpBody = httpBody
        }

        if let paramsForHeader = paramsForHeader {
            for (key, value) in paramsForHeader {
                let valueHeader:String = (key == "Content-Length") ? "\(urlRequest.httpBody?.count ?? 0)" : value
                urlRequest.addValue(valueHeader, forHTTPHeaderField: key)
            }
        }
        return urlRequest
    }

}

