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
    var observerOldUser: AnyObserver<String>!
    var observerNewUser: AnyObserver<String>!
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

        self.observerOldUser = AnyObserver<String>.init{ event in
            switch event{
            case .next:
                guard let string = event.element else{ return }
                let coordinatorListDictionary = CoordinatorListDictionary.init(userName: string)
            _ = self.coordinate(to: coordinatorListDictionary, from: self.nc)
            case .error(_):
                print(event.error!)
            case .completed:
                break
            }
        }

        self.observerNewUser = AnyObserver<String>.init{ event in
            switch event{
            case .next:
                guard let string = event.element else{ return }
            self.modelViewLogIn.showAllert(newUser: string)
            case .error(_):
                print(event.error!)
            case .completed:
                break
            }
        }

        self.modelViewLogIn.publishSubjectLaunchUserOld.subscribe(self.observerOldUser).disposed(by: self.disposeBag)
        self.modelViewLogIn.publishSubjectLaunchUserNew.subscribe(self.observerNewUser).disposed(by: self.disposeBag)
        
        nc.pushViewController(self.vcLogIn, animated: true)
        return Observable.empty()
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        return coordinator.start(from: self.nc) as! Observable<Void>
    }

}
