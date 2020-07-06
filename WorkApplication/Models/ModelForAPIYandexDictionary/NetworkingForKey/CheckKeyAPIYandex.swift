//
//  CheckKeyAPIYandex.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 30.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift

enum StatusKey{
    case StatusKeyValid
    case StatusKeyEmpty
    case StatusKeyDontValid(error: Error)
    case StatusKeyUnknowInternetFails
}

class CheckKeyAPIYandex{

    static let Shared = CheckKeyAPIYandex()

    private init(){
        print("init CheckKeyAPIYandex")
    }

    deinit{
        print("init CheckKeyAPIYandex")
    }

    func check(key: String?) ->  StatusKey{
        if let key = key{
            let response: (responseAnswer: URLResponse?, dataAnswer: Data?, errorAnswer: Error?) = RequestsAPIYandexDictionary.Shared.getResponseAtRequest(urlString: "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=\(key)&lang=en-ru&text=time", params: nil, metodString: "GET")
            switch response {
            case _ where response.dataAnswer != nil :
                print(response.dataAnswer!)
                
                return .StatusKeyValid
            case _ where response.errorAnswer != nil :
                print(response.errorAnswer!)
                return .StatusKeyDontValid(error: response.errorAnswer!)
            default:
                print("default")
                return .StatusKeyUnknowInternetFails
            }
        }else{
            return .StatusKeyEmpty
        }
    }
}

