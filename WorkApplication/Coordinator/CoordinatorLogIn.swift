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
    var coordinatorBeginLaunch: CoordinatorBeginLaunch!
    var observerOldUser: AnyObserver<String>!
    var observerNewUser: AnyObserver<String>!
    var vcLogIn: LoginViewController


    public static let Shared = CoordinatorLogIn()

    private init(){
        self.vcLogIn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcLogIn") as! LoginViewController
        self.modelViewLogIn.vcLogIn = self.vcLogIn
        AppCoordinator.addCoordinatorToArray(coor: self)
        print("init CoordinatorLogIn")
    }

    deinit {
        print("deinit CoordinatorLogIn")
    }

    func start(from nc: UINavigationController) -> Observable<Void>{

        self.nc = nc
        self.modelViewLogIn.linking()

        self.observerOldUser = AnyObserver<String>.init{ event in
            switch event{
            case .next:
                guard let string = event.element else{ return }
                self.coordinatorBeginLaunch = CoordinatorBeginLaunch.init(userName: string)
            _ = self.coordinate(to: self.coordinatorBeginLaunch, from: self.nc)
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

        self.modelViewLogIn.publishSubjectUserLaunchOld.subscribe(self.observerOldUser).disposed(by: self.disposeBag)
        self.modelViewLogIn.publishSubjectUserLaunchNew.subscribe(self.observerNewUser).disposed(by: self.disposeBag)
        
        nc.pushViewController(self.vcLogIn, animated: true)
        return Observable.empty()
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        return coordinator.start(from: self.nc) as! Observable<Void>
    }

}
