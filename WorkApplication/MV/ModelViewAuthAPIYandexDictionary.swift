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

class ModelViewAuthAPIYandexDictionary { //}: NSObject, WKNavigationDelegate{

    var keyAPIYandexDictionary: String?
    var validKeyAPIYandexBehaviorSubject: BehaviorSubject<StatusKey>!
    let disposeBag = DisposeBag.init()
    var responseWithKeyPublishSubject = PublishSubject<HTTPURLResponse>()
    weak var vcCheckAuthAPIYandex: ViewControllerCheckAuthAPIYandexDictionary!
    weak var coordinatorOAuthAPIYandex: CoordinatorOAuthAPIYandex!
    var getKeyAPIYandex: GetKeyAPIYandex!

    convenience init(vcCheckAuthAPIYandex: ViewControllerCheckAuthAPIYandexDictionary, coordinatorOAuthAPIYandex: CoordinatorOAuthAPIYandex) {
        self.init()
        self.vcCheckAuthAPIYandex = vcCheckAuthAPIYandex
        self.coordinatorOAuthAPIYandex = coordinatorOAuthAPIYandex
        self.keyAPIYandexDictionary = UserDefaults.standard.getKeyAPIYandexDictionary()
        self.validKeyAPIYandexBehaviorSubject = BehaviorSubject.init(value: CheckKeyAPIYandex.Shared.check(key: self.keyAPIYandexDictionary))
        self.validKeyAPIYandexBehaviorSubject.subscribe(onNext: { (valid) in
            self.transitionAtValidationKey(statusKey: valid)
        }).self.disposed(by: self.disposeBag)
        print(self.vcCheckAuthAPIYandex.view.subviews)
        print("init ModelViewAuthAPIYandexDictionary")
    }

    deinit {
        print("deinit ModelViewAuthAPIYandexDictionary")
    }
    
    func transitionAtValidationKey(statusKey: StatusKey) {
        var title: String
        var message: String
        var actionAlertFirst: UIAlertAction
        var actionAlertSecond: UIAlertAction

        switch statusKey {
        case .StatusKeyValid:
            self.coordinatorOAuthAPIYandex.gotoCoordinatorLogin()
            return
        case .StatusKeyEmpty:
            title = "Please!"
            message = "For work with a servis Yandex.Dictionary need the key to OAuth!!!"
            actionAlertFirst = UIAlertAction(title: "Authorization", style: .default, handler: { action in
                self.getKeyAPIYandex = GetKeyAPIYandex.init(s: nil)
                self.getKeyAPIYandex.getKey(login: nil, vc: self.vcCheckAuthAPIYandex)
                    .subscribe(
                    onNext: { key in
                        print("key = ", key)
                        self.validKeyAPIYandexBehaviorSubject.onNext(CheckKeyAPIYandex.Shared.check(key:key))
                        print(self.vcCheckAuthAPIYandex.view.debugDescription)
                },
                    onError: { error in
                    print("case .StatusKeyEmpty:", error)
                }).disposed(by: self.disposeBag)
            })

            actionAlertSecond = UIAlertAction(title: "Work without service Yandex.Dictionary", style: .default, handler: { _ in
                self.coordinatorOAuthAPIYandex.gotoCoordinatorLogin()
            })

        case .StatusKeyDontValid(let error):

            //variants error

            title = "Error"
            message = "\(error)"
            actionAlertFirst = UIAlertAction(title: "Work without service Yandex.Dictionary", style: .default, handler: { action in
                self.coordinatorOAuthAPIYandex.gotoCoordinatorLogin()
            })
            actionAlertSecond = UIAlertAction(title: "Try again", style: .default, handler: { _ in
                // reload
            })
        case .StatusKeyUnknowInternetFails:
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
        self.vcCheckAuthAPIYandex.present(alert, animated: true, completion: nil)

    }

}
