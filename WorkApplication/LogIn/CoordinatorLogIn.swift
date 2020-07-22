//
//  Coordinator1.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 14.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class CoordinatorLogIn: CoordinatorProtocol{

    let modelViewLogIn = ModelViewLogIn.Shared
    private let disposeBag = DisposeBag()
    var nc: UINavigationController!
    var vcLogIn: ViewControllerLogin


    public static let Shared = CoordinatorLogIn()

    private init(){
        self.vcLogIn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcLogIn") as! ViewControllerLogin
        self.modelViewLogIn.vcLogIn = self.vcLogIn
        self.modelViewLogIn.coordinatorLogIn = self
        CoordinatorApp.addCoordinatorToArray(coor: self)
        print("init CoordinatorLogIn")
    }

    deinit {
        print("deinit CoordinatorLogIn")
    }


    func start(from nc: UINavigationController) -> Observable<Void>{

        self.nc = nc

        self.modelViewLogIn.binding()

        if self.nc.viewControllers.contains(self.vcLogIn){
            self.nc.popToViewController(self.vcLogIn, animated: true)
            return Observable.empty()
        } else {
            nc.pushViewController(self.vcLogIn, animated: true)
        }

        return Observable.empty()
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        return coordinator.start(from: self.nc) as! Observable<Void>
    }

    func goToAtButtonNext(loginFromTextField: String) {

        guard let userObjectRealm: UserObjectRealm = RealmUser.shared.realmUser.objects(UserObjectRealm.self).filter("userName = %@",loginFromTextField).first else {
            CoordinatorApp.arrayCoordinators.removeAll { $0 is CoordinatorListDictionary }
            self.vcLogIn.navigationController!.viewControllers.removeAll { $0 is ViewControllerListDictionary }
            self.modelViewLogIn.publishSubjectLaunchUserNew.onNext(loginFromTextField)
            return
        }

        var coordinatorListDictionary: CoordinatorListDictionary? = nil
        CoordinatorApp.arrayCoordinators.forEach { (coor) in
            if coor is CoordinatorListDictionary {
                coordinatorListDictionary = (coor as! CoordinatorListDictionary)
            }
        }

        guard coordinatorListDictionary != nil else {
            self.modelViewLogIn.publishSubjectLaunchUserOld.onNext(userObjectRealm)
            return
        }

        if userObjectRealm.userName == UserObjectRealm.CurrentUserObjectRealm?.userName {
            _ = coordinatorListDictionary?.start(from: self.vcLogIn.navigationController!)
        } else {
            CoordinatorApp.arrayCoordinators.removeAll { $0 is CoordinatorListDictionary }
            self.vcLogIn.navigationController!.viewControllers.removeAll { $0 is ViewControllerListDictionary }
            self.modelViewLogIn.publishSubjectLaunchUserOld.onNext(userObjectRealm)
        }
    }
}
