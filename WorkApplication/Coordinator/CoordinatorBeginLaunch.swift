//
//  Coordinator2.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 14.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import UIKit

class CoordinatorBeginLaunch: CoordinatorProtocol{

    static var numberSelf = 0
    var num = CoordinatorBeginLaunch.numberSelf
    private var disposeBag: DisposeBag! = DisposeBag()
    weak var nc: UINavigationController!
    var userName: String!
    var vcBeginLaunch: BeginLaunchViewController!
    var modelViewBeginLaunch: ModelViewBeginLaunch!


    init(userName: String){
        CoordinatorBeginLaunch.numberSelf += 1
        self.userName = userName
        self.vcBeginLaunch = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcBeginLaunch") as? BeginLaunchViewController
        self.modelViewBeginLaunch = ModelViewBeginLaunch.init(userName: userName, coordinator: self)
        self.modelViewBeginLaunch.vcBeginLaunch = self.vcBeginLaunch
        AppCoordinator.addCoordinatorToArray(coor: self)
        print("init CoordinatorBeginLaunch  - ",num)
    }
    
    deinit {
        print("deinit CoordinatorBeginLaunch - ",num)
    }

    func cleanProperties() {

        disposeBag = nil
        nc = nil
        userName = nil
        vcBeginLaunch = nil
        modelViewBeginLaunch = nil
    }

    func start(from nc: UINavigationController) -> Observable<Void> {
        self.nc = nc
        self.modelViewBeginLaunch.binding()
        print("start coordinatorBeginLaunch for userName: \(self.userName!)")
        self.nc.pushViewController(self.vcBeginLaunch, animated: true)
        return Observable.empty()
    }

    func launchCoordinatorMakeNewDictionary(userName: String) -> Observable<Void> {
        do{
            var coordinatorMakeNewDictionary: CoordinatorMakeNewDictionary
            let result = AppCoordinator.arrayCoordinators.filter{ $0 is CoordinatorMakeNewDictionary}
            if let coor = (result.first as? CoordinatorMakeNewDictionary), coor.userName == userName {
                coordinatorMakeNewDictionary = coor
            }else{
                AppCoordinator.arrayCoordinators.removeAll{$0 is CoordinatorMakeNewDictionary}
                coordinatorMakeNewDictionary = try CoordinatorMakeNewDictionary.init(userName: self.userName)!
            }
            _ = self.coordinate(to: coordinatorMakeNewDictionary, from: self.nc)
        }catch{
            print("error init vcMakeNewDictionary")
        }
        return Observable.empty()
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        _ = coordinator.start(from: nc)
        return Observable.empty()
    }

}
