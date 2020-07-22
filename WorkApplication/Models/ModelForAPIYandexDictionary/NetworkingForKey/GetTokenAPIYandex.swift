//
//  GetTokenAPIYandex.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 01.07.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import WebKit
import RxSwift


class GetTokenAPIYandex: NSObject, WKNavigationDelegate{

    var webView: WKWebView!
    var responseWithCodePublishSubject = PublishSubject<Observable<String>?>()
    var responseWithTokenPublishSubject = PublishSubject<String>()
    let disposeBag = DisposeBag()

    override init() {
        print("init GetTokenAPIYandex")
    }

    convenience init(s: String? = nil){
        self.init()
        self.responseWithCodePublishSubject
            .subscribe(onNext: {observableCode in
                observableCode?
                    .subscribe(onNext: { (code) in
                        let postData = "grant_type=authorization_code&code=\(code)&client_id=2926153b3efa42aaa2cccaba713f38ca&client_secret=418202e9a0bd45f3a77daf4ddb2bc41f&device_id=AD5B226C-D42F-4082-8F38-08DDBAB2C86F&device_name=\(UIDevice.current.name)".data(using: .utf8)
                        var headers = [String : String]()
                        headers["Content-Type"] = "application/x-www-form-urlencoded"
                        headers["Content-Length"] = ""

                        guard let request = RequestsAPIYandexDictionary.Shared.getRequestFull(urlStringComponent: (sheme: "https", host: "oauth.yandex.ru", path: "/token"), preferensURLConvertabele: nil, params: nil, metodString: "POST", paramsForHeader: headers, body: postData)
                            else{
                                print("Error request make")
                                return
                        }
                        
                        let config = URLSessionConfiguration.default
                        let session = URLSession(configuration: config)

                        let task = session.dataTaskMy(with: request, completionHandlerMy: {result in
                            switch result {
                            case .success((let data, _)):
                                do {
                                    let jsonString = String(data: data, encoding: .utf8)
                                    print(jsonString!)

                                    
                                    let res = try JSONDecoder().decode(DataToken.self, from: data)
                                    print("t=",res.access_token)
                                    let token = res.access_token.filter { (c) -> Bool in
                                        c != " "
                                    }
                                    print("t=",token)
                                    UserDefaults.standard.setToken(token: token)
                                    self.responseWithTokenPublishSubject.onNext(token)
                                } catch let error {
                                    print(error)
                                }
                            case .failure(let error):
                                print(error)
                            }
                        })
                        task.resume()
                    }).disposed(by: self.disposeBag)
            }).disposed(by: self.disposeBag)
    }
    deinit {
        print("deinit GetAPIYandex")
    }

//MARK- getToken

    func getToken(login: String?, vc: ViewControllerCheckAuthAPIYandexDictionary) -> PublishSubject<String> {
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

        guard let requestForWebView = RequestsAPIYandexDictionary.Shared.getRequestShort(urlString: responseURL, params: parameters, metodString: "GET") else {
            print(" error requestForWebView = nil !!")
            return self.responseWithTokenPublishSubject
        }
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

