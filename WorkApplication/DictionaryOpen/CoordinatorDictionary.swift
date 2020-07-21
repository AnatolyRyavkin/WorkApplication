//
//  CoordinatorDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 25.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class CoordinatorDictionary: CoordinatorProtocol {

    var dictionaryObject: DictionaryObjectRealm!

    private var disposeBag: DisposeBag! = DisposeBag()
    weak var nc: UINavigationController!
    var userObjectRealm: UserObjectRealm = UserObjectRealm.CurrentUserObjectRealm!
    var vcDictionary: ViewControllerDictionary!
    var modelViewDictionary: ModelViewDictionary!


    init(dictionaryObject: DictionaryObjectRealm){


        self.vcDictionary = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcDictionary") as? ViewControllerDictionary
        self.modelViewDictionary = ModelViewDictionary.init(dictionaryObject: dictionaryObject,  coordinatorDictionary: self)
        self.modelViewDictionary.vcDictionary = self.vcDictionary
        CoordinatorApp.addCoordinatorToArray(coor: self)
        print("init CoordinatorDictionary  - ",self)
    }

    deinit {
        self.modelViewDictionary.dictionaryObjectRealm.metods.clean()
        self.modelViewDictionary.disposeBag = nil
        self.vcDictionary = nil
        self.modelViewDictionary = nil
        print("deinit CoordinatorDictionary - ",self)
    }

    func start(from nc: UINavigationController) -> Observable<Void> {
        self.nc = nc
        self.modelViewDictionary.binding()
        print("start coordinatorDictionary for userName: \(self.userObjectRealm.userName)")
        self.nc.pushViewController(self.vcDictionary, animated: true) //true)
        return Observable.empty()
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        return Observable.empty()
    }


}
