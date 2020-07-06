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

    func getRequest(urlString: String, params: [String:String]?, metodString: String, paramsForHeader: [String : String]? = nil) -> URLRequest {
        let urlComp = NSURLComponents(string: urlString)!
        var items = [URLQueryItem]()
        if let params = params {
            for (key,value) in params {
                items.append(URLQueryItem(name: key, value: value))
            }
        }
        items = items.filter{!$0.name.isEmpty}
        if !items.isEmpty {
            urlComp.queryItems = items
        }
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = metodString
        return urlRequest
    }

    func getResponseAtRequest(urlString: String, params: [String:String]?, metodString: String, paramsForHeader: [String : String]? = nil) -> (responseAnswer: URLResponse?, dataAnswer: Data?, errorAnswer: Error?) {
        var urlRequest = self.getRequest(urlString: urlString, params: params, metodString: metodString)
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
        let response: (responseAnswer: URLResponse?, dataAnswer: Data?, errorAnswer: Error?) = self.getResponseAtRequest(urlString: urlString, params: params, metodString: metodString, paramsForHeader: paramsForHeader)
        switch response  {
        case _ where response.dataAnswer != nil :
            if let jsonString = String(data: response.dataAnswer!, encoding: .utf8) {
                print(jsonString)
                return jsonString
            }
            return nil
        case _ where response.errorAnswer != nil :
            print(response.errorAnswer!)
        case _ where response.responseAnswer != nil :
            print(response.responseAnswer!)
        default:
            print("default")
        }
        return nil
    }



//    func fetchAllRooms(completion: ([RemoteRoom]?) -> Void) {
//      Alamofire.request(
//        .GET,
//        "http://localhost:5984/rooms/_all_docs",
//        parameters: ["include_docs": "true"],
//        encoding: .URL)
//        .validate()
//        .responseJSON { (response) -> Void in
//          guard response.result.isSuccess else {
//            print("Error while fetching remote rooms: \(response.result.error)")
//            completion(nil)
//            return
//          }
//
//          guard let value = response.result.value as? [String: AnyObject],
//            rows = value["rows"] as? [[String: AnyObject]] else {
//              print("Malformed data received from fetchAllRooms service")
//               completion(nil)
//               return
//          }
//
//          var rooms = [RemoteRoom]()
//          for roomDict in rows {
//            rooms.append(RemoteRoom(jsonData: roomDict))
//          }
//
//          completion(rooms)
//      }
//    }

}







//
//    var webView: WKWebView!
//
//    override init() {
//        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webView.uiDelegate = self
//        webView.navigationDelegate = self
//    }
//
//    func requestCodeForAuthUser(login: String) -> Observable<String?> {
//        return Observable<String?>.create{str in
//            return Disposables.create()
//        }
//    }
//
//    func requestKeyAtCode(){
//
//    }
//
//    private func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        if let response = navigationResponse.response as? HTTPURLResponse {
//            print(response.debugDescription)
//            //4110844
//        }
//        decisionHandler(.allow)
//    }
//
//    private func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webView.evaluateJavaScript("document.getElementById(\"my-id\").innerHTML", completionHandler: { (jsonRaw: Any?, error: Error?) in
//            guard let jsonString = jsonRaw as? String else { return }
//            _ = JSONSerialization.isValidJSONObject(String.self) //JSON(parseJSON: jsonString)
//            // do stuff
//        })
//    }
//
////    func getRequestToGetCodeForUser(login: String) -> URLRequest {
////            let urlComp = NSURLComponents(string: urlString)!
////            var items = [URLQueryItem]()
////            for (key,value) in params {
////                items.append(URLQueryItem(name: key, value: value))
////            }
////            items = items.filter{!$0.name.isEmpty}
////            if !items.isEmpty {
////              urlComp.queryItems = items
////            }
////            var urlRequest = URLRequest(url: urlComp.url!)
////            urlRequest.httpMethod = "GET"
////
////            return urlRequest
//
//    //        let config = URLSessionConfiguration.default
//    //        let session = URLSession(configuration: config)
//    //        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
//    //        })
//    //        task.resume()
//        }
//
////        func requestToGetCodeForUserfvber(urlString: String, params: [String:String], metodString: String ) -> URLRequest {
////
////            let myURL = "https://oauth.yandex.ru/authorize?"
////            let parameters = ["response_type" : "code",
////                              "client_id" : "2926153b3efa42aaa2cccaba713f38ca",
////                              "device_id" : "2BEB4031-8EE2-41EC-8B63-9D4F3EFBAAF4",
////                              "device_name" : UIDevice.current.name,
////                              "redirect_uri" : "https://oauth.yandex.ru/verification_code",
////                              "login_hint" : "toryavkin",
////                              //"scope" : "Доступкдатерождения",
////                              //"optional_scope" : "запрашиваемые опциональные права",
////                              "force_confirm" : "yes",
////                              "state" : "0"
////            ]
////            let myRequest = self.getRequest(urlString: myURL, params: parameters, metodString: "GET")
////            let urlComp = NSURLComponents(string: urlString)!
////            var items = [URLQueryItem]()
////            for (key,value) in params {
////                items.append(URLQueryItem(name: key, value: value))
////            }
////            items = items.filter{!$0.name.isEmpty}
////            if !items.isEmpty {
////              urlComp.queryItems = items
////            }
////            var urlRequest = URLRequest(url: urlComp.url!)
////            urlRequest.httpMethod = "GET"
////
////            return urlRequest
////
////    //        let config = URLSessionConfiguration.default
////    //        let session = URLSession(configuration: config)
////    //        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
////    //        })
////    //        task.resume()
////        }
////
////        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
////            if let response = navigationResponse.response as? HTTPURLResponse {
////                print(response.debugDescription)
////                //4110844
////            }
////            decisionHandler(.allow)
////        }
////
////        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
////            webView.evaluateJavaScript("document.getElementById(\"my-id\").innerHTML", completionHandler: { (jsonRaw: Any?, error: Error?) in
////                guard let jsonString = jsonRaw as? String else { return }
////                _ = JSONSerialization.isValidJSONObject(String.self) //JSON(parseJSON: jsonString)
////                // do stuff
////            })
////        }
////
////    //    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
////    //        if challenge.protectionSpace.host == "https://vplan.bielefeld-marienschule.logoip.de/subst_002.htm" {
////    //            let userStr = "********"
////    //            let passwordStr = "********"
////    //            let credential = URLCredential(user: userStr, password: passwordStr, persistence: URLCredential.Persistence.forSession)
////    //            challenge.sender?.use(credential, for: challenge)
////    //            completionHandler(.useCredential, credential)
////    //        }
////    //    }
////
////        override func viewDidLoad() {
////            super.viewDidLoad()
////
////    //        let dirPathNoScheme = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
////    //        print(dirPathNoScheme)
////
////            print(UIDevice.current.name)
////            print(UIDevice.current.systemName)
////            print(UIDevice.current.systemVersion)
////            print(UIDevice.current.model)
////            print(UIDevice.current.localizedModel)
////            print(UIDevice.current.userInterfaceIdiom)
////            print(UIDevice.current.identifierForVendor)
////            print(UIDevice.current.batteryLevel)
////
////
////
////            let myURL = "https://oauth.yandex.ru/authorize?"
////            let parameters = ["response_type" : "code",
////                              "client_id" : "2926153b3efa42aaa2cccaba713f38ca",
////                              "device_id" : "2BEB4031-8EE2-41EC-8B63-9D4F3EFBAAF4",
////                              "device_name" : UIDevice.current.name,
////                              "redirect_uri" : "https://oauth.yandex.ru/verification_code",
////                              "login_hint" : "toryavkin",
////                              //"scope" : "Доступкдатерождения",
////                              //"optional_scope" : "запрашиваемые опциональные права",
////                              "force_confirm" : "yes",
////                              "state" : "0"
////            ]
////            let myRequest = self.getRequest(urlString: myURL, params: parameters, metodString: "GET")
////            let wkNavigation = webView.load(myRequest)
////            print(wkNavigation.debugDescription)
////
////            //UUID DBBD5345-9B3C-4495-B2FB-9F0A036F0225
////
////            ///Users/ryavkinto/Library/Developer/CoreSimulator/Devices/AD5B226C-D42F-4082-8F38-08DDBAB2C86F/data/Containers/Data/Application/9489FEFC-D20E-467E-90FB-F4D51BFB2D3E/Documents
////
////            ///Users/ryavkinto/Library/Developer/CoreSimulator/Devices/AD5B226C-D42F-4082-8F38-08DDBAB2C86F/data/Containers/Data/Application/A06E865C-8830-46ED-BDBF-0603CB4C4ED0/Documents
////
////            //5A919FFB-FD53-4423-B3EA-FB21D3BE3C67
////
////    //        AF.request("https://oauth.yandex.ru/authorize?",
////    //                   method: .get,
////    //                   parameters: ["response_type" : "code",
////    //                                "client_id" : "2926153b3efa42aaa2cccaba713f38ca",
////    //                                "device_id" : "идентификатор устройства",
////    //                                "device_name" : "имя устройства",
////    //                                "redirect_uri" : "адрес перенаправления",
////    //                                "login_hint" : "имя пользователя или электронный адрес",
////    //                                "scope" : "запрашиваемые необходимые права",
////    //                                "optional_scope" : "запрашиваемые опциональные права",
////    //                                "force_confirm" : "yes",
////    //                                "state" : "произвольная строка"
////    //            ]).response { response in
////    //            debugPrint(response)
////    //        }
////
////    //        GetKeyForYandexDictionaries().requstFirst()
////        }
////
////        override func viewDidAppear(_ animated: Bool) {
////            super.viewDidAppear(animated)
////        }
////
////        override func viewWillAppear(_ animated: Bool) {
////            super.viewWillAppear(animated)
////            self.navigationController?.isNavigationBarHidden = true
////        }
////
////}
