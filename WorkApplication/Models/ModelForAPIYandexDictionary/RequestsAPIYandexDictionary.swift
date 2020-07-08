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

class RequestsAPIYandexDictionary {

    typealias MyJSONString = String
    static let Shared = RequestsAPIYandexDictionary()

    private init(){
        print("init RequestAPIYandexDictionary")
    }

    deinit {
        print("deinit RequestAPIYandexDictionary")
    }

//MARK- getRequestFull

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


//MARK- getRequestShort

    func getRequestShort(urlString: String, params: [String:String]?, metodString: String, paramsForHeader: [String : String]? = nil) -> URLRequest? {
        return getRequestFull(urlStringComponent: nil, preferensURLConvertabele: urlString, params: params, metodString: metodString, paramsForHeader: nil, body: nil)
    }


    func getResponseAtRequest(urlString: String, params: [String:String]?, metodString: String, paramsForHeader: [String : String]? = nil) -> (responseAnswer: URLResponse?, dataAnswer: Data?, errorAnswer: Error?) {

        guard var urlRequest = self.getRequestShort(urlString: urlString, params: params, metodString: metodString)
            else {print("return (nil,nil,nil)")
                return (nil,nil,nil)
        }

        if let parametrsHeader = paramsForHeader {
            for (value,headerField) in parametrsHeader {
                urlRequest.setValue(value, forHTTPHeaderField: headerField)
            }
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var responseAnswer: URLResponse?
        var dataAnswer: Data?
        var errorAnswer: Error?
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            responseAnswer = response!
            dataAnswer = data
            errorAnswer = error
        })
        let queue = OperationQueue.init()
        queue.addBarrierBlock {
            task.resume()
        }
        return (responseAnswer, dataAnswer, errorAnswer)
    }


    func getJSONStringAtRequest(urlString: String, params: [String:String]?, metodString: String, paramsForHeader: [String : String]? = nil ) -> MyJSONString? {
        let response = getResponseAtRequest(urlString: urlString, params: params, metodString: metodString, paramsForHeader: paramsForHeader)
        if let data = response.dataAnswer {
            guard let jsonString = String(data: data, encoding: .utf8) else {
                return nil
            }
            print(jsonString)
            return jsonString
        }
        return nil
    }

}
