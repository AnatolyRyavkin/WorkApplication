//
//  CoordinatorOAuthAPIYandex.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 29.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CoordinatorOAuthAPIYandex: CoordinatorProtocol {

    var modelViewAuthAPIYandexDictionary: ModelViewAuthAPIYandexDictionary!
    private let disposeBag = DisposeBag()
    var nc: UINavigationController!
    weak var vcCheckAuthAPIYandex: ViewControllerCheckAuthAPIYandexDictionary!

    init(){
        CoordinatorApp.addCoordinatorToArray(coor: self)
        print("init CoordinatorOAuthAPIYandex")
    }

    deinit {
        print("deinit CoordinatorOAuthAPIYandex")
    }

    func start(from nc: UINavigationController) -> Observable<Void> {
        self.nc = nc
        self.vcCheckAuthAPIYandex = self.nc.visibleViewController as? ViewControllerCheckAuthAPIYandexDictionary
        (self.vcCheckAuthAPIYandex as UIViewController).rx.viewDidAppear.subscribe(onNext: { _ in
            self.modelViewAuthAPIYandexDictionary = ModelViewAuthAPIYandexDictionary.init(vcCheckAuthAPIYandex: self.vcCheckAuthAPIYandex, coordinatorOAuthAPIYandex: self)
        }).disposed(by: self.disposeBag)

        return  Observable<Void>.empty()
    }

    func gotoCoordinatorLogin() {
        if let userLast = UserDefaults.standard.getLastLoggedIn() {
            let coordinatorListDictionary = CoordinatorListDictionary.init(userName: userLast)
            self.coordinate(to: coordinatorListDictionary, from: self.nc).subscribe{ _ in}.disposed(by: self.disposeBag)
        }else{
            let coordinatorLogIn = CoordinatorLogIn.Shared
            self.coordinate(to: coordinatorLogIn, from: self.nc).subscribe{ _ in}.disposed(by: self.disposeBag)
        }
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        return coordinator.start(from: self.nc) as! Observable<Void>
    }
}
