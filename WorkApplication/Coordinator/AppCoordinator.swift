//
//  AppCoordinator.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 14.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class AppCoordinator: CoordinatorProtocol {

    static var arrayCoordinators: Array<AnyObject> = Array<AnyObject>()
    public static let Shared = AppCoordinator()
    var coordinatorLogIn: CoordinatorLogIn!
    var coordinatorBeginLaunch: CoordinatorBeginLaunch!
    private let disposeBag = DisposeBag()
    var nc: UINavigationController!

    private init(){
        print("init CoordinatorApp")
    }

    deinit {
        print("deinit CoordinatorApp")
    }

    static func addCoordinatorToArray(coor: AnyObject){
        AppCoordinator.arrayCoordinators.append(coor)
    }

    func start(from nc: UINavigationController) -> Observable<Void> {
        self.nc = nc
        if let userLast = UserDefaults.standard.getLastLoggedIn() {
            self.coordinatorBeginLaunch = CoordinatorBeginLaunch.init(userName: userLast)
            self.coordinate(to: self.coordinatorBeginLaunch, from: self.nc).subscribe{ _ in}.disposed(by: self.disposeBag)
        }else{
            self.coordinatorLogIn = CoordinatorLogIn.Shared
            self.coordinate(to: self.coordinatorLogIn, from: self.nc).subscribe{ _ in}.disposed(by: self.disposeBag)
        }
        return  Observable<Void>.empty()
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        return coordinator.start(from: self.nc) as! Observable<Void>
    }

}
