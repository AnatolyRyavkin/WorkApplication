//
//  authAPIYandexDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 29.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

let keyAPIYandexDictionary = "dict.1.1.20200707T204930Z.ad0118aaace6d7cf.8e79f678653ae9589a3d414cfc330579d3d2dceb"

class ModelViewAuthAPIYandexDictionary { //}: NSObject, WKNavigationDelegate{

    var tokenAPIYandexDictionary: String?
    var validTokenAPIYandexBehaviorSubject: BehaviorSubject<StatusToken>!
    let disposeBag = DisposeBag.init()
    weak var vcCheckAuthAPIYandex: ViewControllerCheckAuthAPIYandexDictionary!
    weak var coordinatorOAuthAPIYandex: CoordinatorOAuthAPIYandex!
    var getTokenAPIYandex: GetTokenAPIYandex!

    convenience init(vcCheckAuthAPIYandex: ViewControllerCheckAuthAPIYandexDictionary, coordinatorOAuthAPIYandex: CoordinatorOAuthAPIYandex) {
        self.init()
        self.vcCheckAuthAPIYandex = vcCheckAuthAPIYandex
        self.coordinatorOAuthAPIYandex = coordinatorOAuthAPIYandex
        self.tokenAPIYandexDictionary = UserDefaults.standard.getToken()
        self.validTokenAPIYandexBehaviorSubject = BehaviorSubject.init(value: CheckTokenAPIYandex.Shared.check(token: self.tokenAPIYandexDictionary))
        self.validTokenAPIYandexBehaviorSubject
            .observeOn(MainScheduler.init())
            .subscribe(onNext: { (valid) in
                self.transitionAtValidationToken(statusToken: valid)
        }).self.disposed(by: self.disposeBag)
        print(self.vcCheckAuthAPIYandex.view.subviews)
        print("init ModelViewAuthAPIYandexDictionary")
    }

    deinit {
        print("deinit ModelViewAuthAPIYandexDictionary")
    }
    
    func transitionAtValidationToken(statusToken: StatusToken) {
        var title: String
        var message: String
        var actionAlertFirst: UIAlertAction
        var actionAlertSecond: UIAlertAction

        switch statusToken {
        case .StatusTokenValid:
            self.coordinatorOAuthAPIYandex.gotoCoordinatorLogin()
            return 
        case .StatusTokenEmpty:
            title = "Please!"
            message = "For work with a servis Yandex.Dictionary need the token to OAuth!!!"
            actionAlertFirst = UIAlertAction(title: "Authorization", style: .default, handler: { action in
                self.getTokenAPIYandex = GetTokenAPIYandex.init(s: nil)
                self.getTokenAPIYandex.getToken(login: nil, vc: self.vcCheckAuthAPIYandex)
                    .subscribe(onNext: { token in
                        print("token = ", token)
                        self.validTokenAPIYandexBehaviorSubject.onNext(CheckTokenAPIYandex.Shared.check(token:token))
                },
                    onError: { error in
                    print("case .StatusTokenEmpty:", error)
                }).disposed(by: self.disposeBag)
            })

            actionAlertSecond = UIAlertAction(title: "Work without service Yandex.Dictionary", style: .default, handler: { _ in
                self.coordinatorOAuthAPIYandex.gotoCoordinatorLogin()
            })

        case .StatusTokenDontValid(let error):

            //variants error

            title = "Error"
            message = "\(error)"
            actionAlertFirst = UIAlertAction(title: "Work without service Yandex.Dictionary", style: .default, handler: { action in
                self.coordinatorOAuthAPIYandex.gotoCoordinatorLogin()
            })
            actionAlertSecond = UIAlertAction(title: "Try again", style: .default, handler: { _ in
                // reload
            })
        case .StatusTokenUnknowInternetFails:
            title = "No Internet"
            message = "no connection to the server"
            actionAlertFirst = UIAlertAction(title: "Work without service Yandex.Dictionary", style: .default, handler: { action in
                self.coordinatorOAuthAPIYandex.gotoCoordinatorLogin()
            })
            actionAlertSecond = UIAlertAction(title: "Try again", style: .default, handler: { _ in
                // reload
            })

        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(actionAlertFirst)
        alert.addAction(actionAlertSecond)
        print(Thread.current)
        self.vcCheckAuthAPIYandex.present(alert, animated: true, completion: nil)

    }

}


