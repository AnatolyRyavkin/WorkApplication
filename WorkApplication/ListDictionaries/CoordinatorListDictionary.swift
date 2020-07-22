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

class CoordinatorListDictionary: CoordinatorProtocol{

    private var disposeBag: DisposeBag! = DisposeBag()
    weak var nc: UINavigationController!
    var userObjectRealm: UserObjectRealm = UserObjectRealm.CurrentUserObjectRealm!

    var vcListDictionary: ViewControllerListDictionary!
    var modelViewListDictionary: ModelViewListDictionary!

    static var FirstAppear = true

    init(){
        self.vcListDictionary = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcListDictionary") as? ViewControllerListDictionary
        self.modelViewListDictionary = ModelViewListDictionary.init( coordinatorListDictionary: self)
        self.modelViewListDictionary.vcListDictionary = self.vcListDictionary
        CoordinatorApp.addCoordinatorToArray(coor: self)
        print("init CoordinatorListDictionary  - ",self)
    }

    deinit {
        modelViewListDictionary.disposeBag = nil
        print("deinit CoordinatorListDictionary - ",self)
    }

    func start(from nc: UINavigationController) -> Observable<Void> {
        self.nc = nc
        self.modelViewListDictionary.binding()
        print("start coordinatorListDictionary for userName: \(self.userObjectRealm.userName)")

        if self.nc.viewControllers.contains(self.vcListDictionary){
            self.nc.popToViewController(self.vcListDictionary, animated: true)
            return Observable.empty()
        } else {
            nc.pushViewController(self.vcListDictionary, animated: true) 
            CoordinatorListDictionary.FirstAppear = false
        }
        return Observable.empty()
    }

    func launchCoordinatorMakeNewDictionary() -> Observable<Void> {
        var coordinatorMakeNewDictionary: CoordinatorNewDictionary
        let result = CoordinatorApp.arrayCoordinators.filter{ $0 is CoordinatorNewDictionary}
        if let coor = (result.first as? CoordinatorNewDictionary), coor.userObjectRealm == self.userObjectRealm {
            coordinatorMakeNewDictionary = coor
        }else{
            CoordinatorApp.arrayCoordinators.removeAll{$0 is CoordinatorNewDictionary}
            coordinatorMakeNewDictionary = CoordinatorNewDictionary.init()
        }
        _ = self.coordinate(to: coordinatorMakeNewDictionary, from: self.nc)
        
        return Observable.empty()
    }

    func launchCoordinatorChangeTitleDictionary(dictionaryObjectRename: DictionaryObjectRealm) -> Observable<Void> {
        let coordinatorChangeTitleDictionary = CoordinatorRenameDictionary.init(dictionaryObjectRename: dictionaryObjectRename)
        _ = self.coordinate(to: coordinatorChangeTitleDictionary, from: self.nc)
        return Observable.empty()
    }

    func launchCoordinatorLogIn() -> Observable<Void> {
        CoordinatorLogIn.Shared.start(from: self.nc)
    }

    func openDictionary(dictionaryObject: DictionaryObjectRealm){
        let cootdinatorDictionary = CoordinatorDictionary.init(dictionaryObject: dictionaryObject )
        _ = coordinate(to: cootdinatorDictionary, from: self.nc)
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        _ = coordinator.start(from: nc)
        return Observable.empty()
    }

}


























//    init(userName: String){
//        self.userName = userName
//        self.vcListDictionary = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcListDictionary") as? ViewControllerListDictionary
//        self.modelViewListDictionary = ModelViewListDictionary.init(userName: userName, coordinatorListDictionary: self)
//        self.modelViewListDictionary.vcListDictionary = self.vcListDictionary
//        CoordinatorApp.addCoordinatorToArray(coor: self)
//        print("init CoordinatorListDictionary  - ",self)
//    }
//
//    deinit {
//        modelViewListDictionary.disposeBag = nil
//        print("deinit CoordinatorListDictionary - ",self)
//    }
//
//    func start(from nc: UINavigationController) -> Observable<Void> {
//        self.nc = nc
//        self.modelViewListDictionary.binding()
//        print("start coordinatorListDictionary for userName: \(self.userName!)")
//        self.nc.pushViewController(self.vcListDictionary, animated: true)
//        return Observable.empty()
//    }
//
//    func launchCoordinatorMakeNewDictionary(userName: String) -> Observable<Void> {
//        do{
//            var coordinatorMakeNewDictionary: CoordinatorNewDictionary
//            let result = CoordinatorApp.arrayCoordinators.filter{ $0 is CoordinatorNewDictionary}
//            if let coor = (result.first as? CoordinatorNewDictionary), coor.userName == userName {
//                coordinatorMakeNewDictionary = coor
//            }else{
//                CoordinatorApp.arrayCoordinators.removeAll{$0 is CoordinatorNewDictionary}
//                coordinatorMakeNewDictionary = try CoordinatorNewDictionary.init(userName: self.userName)!
//            }
//            _ = self.coordinate(to: coordinatorMakeNewDictionary, from: self.nc)
//        }catch{
//            print("error init vcNewDictionary")
//        }
//        return Observable.empty()
//    }
//
//    func launchCoordinatorChangeTitleDictionary(dictionaryObjectRename: DictionaryObjectRealm, userName: String) -> Observable<Void> {
//        let coordinatorChangeTitleDictionary = CoordinatorRenameDictionary.init(dictionaryObjectRename: dictionaryObjectRename, userName: userName)!
//        _ = self.coordinate(to: coordinatorChangeTitleDictionary, from: self.nc)
//        return Observable.empty()
//    }
//
//    func openDictionary(dictionaryObject: DictionaryObjectRealm){
//        let cootdinatorDictionary = CoordinatorDictionary.init(dictionaryObject: dictionaryObject, userName: self.userName)
//        _ = coordinate(to: cootdinatorDictionary, from: self.nc)
//    }
//
//    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
//        _ = coordinator.start(from: nc)
//        return Observable.empty()
//    }
//
//}
