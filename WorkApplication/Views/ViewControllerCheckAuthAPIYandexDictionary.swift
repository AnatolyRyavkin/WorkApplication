//
//  ViewControllerCheckAuthAPIYandexDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 30.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit
import WebKit

class ViewControllerCheckAuthAPIYandexDictionary: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red

//        let webConfiguration = WKWebViewConfiguration()
//        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        self.view = webView
//
//        let responseURL = "https://oauth.yandex.ru/authorize?"
//
//        let dirPathNoScheme = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String)
//          print(dirPathNoScheme)
//
//        let parameters = ["response_type" : "code",
//                          "client_id" : "2926153b3efa42aaa2cccaba713f38ca", // id App get by registration App
//                          "device_id" : "AD5B226C-D42F-4082-8F38-08DDBAB2C86F", // nidn make
//                          "device_name" : UIDevice.current.name,
//                          "redirect_uri" : "https://oauth.yandex.ru/verification_code",
//                          //"login_hint" : "",
//                          //"scope" : "Доступ к дате рождения",
//                          //"optional_scope" : "запрашиваемые опциональные права",
//                          "force_confirm" : "yes",
//                          "state" : "0"
//        ]
//
//        let requestForWebView = RequestsAPIYandexDictionary.Shared.getRequest(urlString: responseURL, params: parameters, metodString: "GET")
//        webView.load(requestForWebView)
    }
    
}
