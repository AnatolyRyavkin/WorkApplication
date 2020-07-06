//
//  GetKeyAPIYandex.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 01.07.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import WebKit
import RxSwift


class GetKeyAPIYandex: NSObject, WKNavigationDelegate{

    var webView: WKWebView!
    var key: String?
    var responseWithCodePublishSubject = PublishSubject<Observable<String>?>()
    let disposeBag = DisposeBag()
    var observableKey: Observable<String?>!
    var responseWithTokenPublishSubject = PublishSubject<String>()
    var disposedResponseWithCodePublishSubject: Disposable!

    override init() {
        print("init GetKeyAPIYandex")
    }

    convenience init(s: String? = nil){
        self.init()
        self.responseWithCodePublishSubject
            .subscribe(onNext: {observableCode in
                observableCode?.subscribe(onNext: { (code) in


                    var urlComponents = URLComponents()
                    urlComponents.scheme = "http"
                    urlComponents.host = "oauth.yandex.ru"
                    urlComponents.path = "/token"
                    guard let url = urlComponents.url else {
                        fatalError("Could not create URL from components")
                    }

                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"

                    let parameters = [
                        "grant_type" : "authorization_code",
                        "code" : code,
                        "client_id" : "2926153b3efa42aaa2cccaba713f38ca",
                        "client_secret" : "418202e9a0bd45f3a77daf4ddb2bc41f",
                        "device_id" : "AD5B226C-D42F-4082-8F38-08DDBAB2C86F",
                        "device_name" : UIDevice.current.name,
                    ]

                    do {
                        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    } catch let error {
                        print(error.localizedDescription)
                    }

                    guard let contentLength = request.httpBody?.count else{
                        print("contentLength = nil !!!")
                        return
                    }

                    var headers = request.allHTTPHeaderFields ?? [:]
                    headers["Content-Type"] = "application/x-www-form-urlencoded"
                    headers["Content-Length"] = "\(contentLength)"
                    request.allHTTPHeaderFields = headers

                    // Create and run a URLSession data task with our JSON encoded POST request
                    let config = URLSessionConfiguration.default
                    let session = URLSession(configuration: config)
                    let task = session.dataTask(with: request) { (responseData, response, responseError) in
                        guard responseError == nil else {
                            print(responseError!)
                            //TODO: error handling
                            return
                        }

                        if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                            print("response: ", utf8Representation)
                        } else {
                            print("no readable data received in response")
                        }
                    }
                    task.resume()

                    //                    // Now let's encode out Post struct into JSON data...
                    //                    let encoder = JSONEncoder()
                    //                    do {
                    //                        let jsonData = try encoder.encode(scan)
                    //                        // ... and set our request's HTTP body
                    //                        request.httpBody = jsonData
                    //                        print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
                    //                    } catch {
                    //                        //TODO: error handling
                    //                    }








//                    let parameters = [
//                        "grant_type" : "authorization_code",
//                        "code" : code,
//                        "client_id" : "2926153b3efa42aaa2cccaba713f38ca", // id App get by registration App
//                        "client_secret" : "418202e9a0bd45f3a77daf4ddb2bc41f",
//                        "device_id" : "AD5B226C-D42F-4082-8F38-08DDBAB2C86F", // nidn make
//                        "device_name" : UIDevice.current.name,
//                    ]
//                    let requestWithCode = RequestsAPIYandexDictionary.Shared.getRequest(urlString: "https://oauth.yandex.ru", params: parameters, metodString: "POST")
//                    print(requestWithCode.debugDescription)
//                    URLSession.shared.dataTask(with: requestWithCode, completionHandler: {data, response, error in
//                        print(data?.description)
//                        if let data = data {
//                            do {
//                                let res = try JSONDecoder().decode(ResponseWithToken.self, from: data)
//                                print(res.access_token)
//                                print(res.expires_in)
//                                print(res.refresh_token)
//                                self.responseWithTokenPublishSubject.onNext(res.access_token)
//                            } catch let error {
//                                print(error)
//                            }
//                        }
//                    }).resume()


                }).disposed(by: self.disposeBag)
            }).disposed(by: self.disposeBag)
    }

    deinit {
        print("deinit GetAPIYandex")
    }

    func getKey(login: String?, vc: ViewControllerCheckAuthAPIYandexDictionary) -> PublishSubject<String> {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        vc.view = webView

        let responseURL = "https://oauth.yandex.ru/authorize?"

        let dirPathNoScheme = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String)
        print(dirPathNoScheme)

        let parameters = ["response_type" : "code",
                          "client_id" : "2926153b3efa42aaa2cccaba713f38ca", // id App get by registration App
                          "device_id" : "AD5B226C-D42F-4082-8F38-08DDBAB2C86F", // nidn make
                          "device_name" : UIDevice.current.name,
                          "redirect_uri" : "https://oauth.yandex.ru/verification_code",
                          //"login_hint" : login ?? "",
                          //"scope" : "Доступ к дате рождения",
                          //"optional_scope" : "запрашиваемые опциональные права",
                          "force_confirm" : "yes",
                          "state" : "0"
        ]

        let requestForWebView = RequestsAPIYandexDictionary.Shared.getRequest(urlString: responseURL, params: parameters, metodString: "GET")
        webView?.load(requestForWebView)
        return self.responseWithTokenPublishSubject
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse {
            self.responseWithCodePublishSubject.on(.next(ParsingResponse.Shared.getObservableCodeToGetTokenFromResponse(response: response)))
        }
        decisionHandler(.allow)
    }
}
