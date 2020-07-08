//
//  CheckTokenAPIYandex.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 30.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift

enum StatusToken{
    case StatusTokenValid
    case StatusTokenEmpty
    case StatusTokenDontValid(error: Error)
    case StatusTokenUnknowInternetFails
}

class CheckTokenAPIYandex{

    static let Shared = CheckTokenAPIYandex()

    private init(){
        print("init CheckTokenAPIYandex")
    }

    deinit{
        print("init CheckTokenAPIYandex")
    }

//    func check(token: String?) ->  StatusToken{
//        if let token = token{
//            let urlStr =
//            "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=dict.1.1.20200707T204930Z.ad0118aaace6d7cf.8e79f678653ae9589a3d414cfc330579d3d2dceb&lang=en-ru&text=time"
//
//            var response: (responseAnswer: URLResponse?, dataAnswer: Data?, errorAnswer: Error?)
//            let queue = OperationQueue.init()
//            queue.addBarrierBlock {
//                response =
//                    RequestsAPIYandexDictionary.Shared.getResponseAtRequest(urlString: urlStr, params: nil, metodString: "GET")
//            }
//
//            print(response)
//
//            switch response {
//            case _ where response.dataAnswer != nil :
//                print(response.dataAnswer!)
//                return .StatusTokenValid
//            case _ where response.errorAnswer != nil :
//                print(response.errorAnswer!)
//                return .StatusTokenDontValid(error: response.errorAnswer!)
//            default:
//                print("default")
//                return .StatusTokenUnknowInternetFails
//            }
//        }else{
//            return .StatusTokenEmpty
//        }
//    }

//    func check(token: String?) ->  StatusToken{
//        guard let token = token else {
//            return .StatusTokenEmpty
//        }
//        print("token=",token)
////        let urlStr = https://dictionary.yandex.net/api/v1/dicservice/getLangs?key=API-ключ
////        "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=AgAAAAAV-ExOAAZsEgByKXIc7U59rRx7KhY5ym4&lang=en-ru&text=time"
//
//        let urlStr = "https://dictionary.yandex.net/api/v1/dicservice/getLangs?key=AgAAAAAV-ExOAAZsEgByKXIc7U59rRx7KhY5ym4"
//
//        guard let request = RequestsAPIYandexDictionary.Shared.getRequestFull(urlStringComponent: nil, preferensURLConvertabele: urlStr, params: nil, metodString: "GET", paramsForHeader: nil, body: nil)
//            else{
//                print("Error request make")
//                return .StatusTokenUnknowInternetFails
//        }
//
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//
//        let task = session.dataTaskMy(with: request, completionHandlerMy: {result in
//            switch result {
//            case .success((let data, _)):
//                do {
//                    //let res = try JSONDecoder().decode(DataToken.self, from: data)
//                    if let jsonString = String(data: data, encoding: .utf8) {
//                       print(jsonString)
//                    }
//                } catch let error {
//                    print(error)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        })
//        task.resume()
//
//        return .StatusTokenValid
//    }


    func check(token: String?) ->  StatusToken{
        guard let token = token else {
            return .StatusTokenEmpty
        }
        print("token=",token)

        let urlStr = "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=dict.1.1.20200707T204930Z.ad0118aaace6d7cf.8e79f678653ae9589a3d414cfc330579d3d2dceb&lang=en-ru&text=time"

        let url = URL.init(string: urlStr)!

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: url) { (d, r, e) in
            let jsonString = String(data: d!, encoding: .utf8)
            print(jsonString!)

        }

        task.resume()

        return .StatusTokenValid
    }
}


 




