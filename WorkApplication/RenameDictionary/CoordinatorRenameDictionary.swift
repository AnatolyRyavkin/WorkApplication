//
//  CoordinatorOpenDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 22.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class CoordinatorRenameDictionary: CoordinatorProtocol {

    var dictionaryObjectRename: DictionaryObjectRealm
    var userObjectRealm: UserObjectRealm = UserObjectRealm.CurrentUserObjectRealm!
    var vcRenameDictionary: ViewControllerRenameDictionary!
    lazy var nc: UINavigationController! = vcRenameDictionary.navigationController
    var modelViewRenameDictionary: ModelViewRenameDictionary!

    init(dictionaryObjectRename: DictionaryObjectRealm) {
        self.dictionaryObjectRename = dictionaryObjectRename
         let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcRenameDictionary") as? ViewControllerRenameDictionary
        self.vcRenameDictionary = vc
        self.modelViewRenameDictionary = ModelViewRenameDictionary.init(dictionaryObjectRename: dictionaryObjectRename, coordinatorRenameDictionary: self)
        self.modelViewRenameDictionary.vcRenameDictionary = self.vcRenameDictionary
        CoordinatorApp.addCoordinatorToArray(coor: self)
        print("init CoordinatorRenameDictionary")
    }

    deinit{
        self.modelViewRenameDictionary.disposeBag = nil
        print("deinit CoordinatorRenameDictionary")
    }

    func start(from nc: UINavigationController) -> Observable<Void> {
        self.nc = nc
        self.modelViewRenameDictionary.binding()
        print("start coordinatorRenameDictionary for userName: \(self.userObjectRealm.userName )")
        self.nc.pushViewController(self.vcRenameDictionary, animated: true)
        return Observable.empty()
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        _ = coordinator.start(from: nc)
        return Observable.empty()
    }

    func openDictionary(dictionaryObject: DictionaryObjectRealm){
        let cootdinatorDictionary = CoordinatorDictionary.init(dictionaryObject: dictionaryObject )
        _ = coordinate(to: cootdinatorDictionary, from: self.nc)
    }


}
