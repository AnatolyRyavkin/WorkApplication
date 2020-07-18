//
//  CoordinatorNewDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 13.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class CoordinatorNewDictionary: CoordinatorProtocol{

    var userObjectRealm: UserObjectRealm = UserObjectRealm.CurrentUserObjectRealm!
    
    var vcNewDictionary: ViewControllerNewDictionary!
    lazy var nc: UINavigationController! = vcNewDictionary.navigationController
    var modelViewNewDictionary: ModelViewNewDictionary!

    init(){
       let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcNewDictionary") as! ViewControllerNewDictionary
        self.vcNewDictionary = vc
        self.modelViewNewDictionary = ModelViewNewDictionary.init(coordinatorNewDictionary: self)
        self.modelViewNewDictionary.vcNewDictionary = self.vcNewDictionary
        CoordinatorApp.addCoordinatorToArray(coor: self)
        print("init CoordinatorNewDictionary")
    }

    deinit{
        modelViewNewDictionary.disposeBag = nil
        print("deinit CoordinatorNewDictionary")
    }

    func start(from nc: UINavigationController) -> Observable<Void> {
        self.nc = nc
        self.modelViewNewDictionary.binding()
        print("start coordinatorMakeDictionary for userName: \(self.userObjectRealm.userName)")
        self.nc.pushViewController(self.vcNewDictionary, animated: true)
        return Observable.empty()
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        _ = coordinator.start(from: nc)
        return Observable.empty()
    }

    func openDictionary(dictionaryObject: DictionaryObjectRealm){
        let cootdinatorDictionary = CoordinatorDictionary.init(dictionaryObject: dictionaryObject)
        _ = coordinate(to: cootdinatorDictionary, from: self.nc)
    }


}
