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

class CoordinatorChangeTitleDictionary: CoordinatorProtocol {

    var dictionaryChange: DictionaryObject
    var userName: String!
    var vcChangeTitleDictionary: ChangeTitleDictionaryViewController!
    lazy var nc: UINavigationController! = vcChangeTitleDictionary.navigationController
    var modelViewChangeTitleDictionary: ModelViewChangeTitleDictionary!

    init?(dictionaryChange: DictionaryObject, userName: String) {
        self.dictionaryChange = dictionaryChange
        self.userName = userName

        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcChangeTitleDictionary") as? ChangeTitleDictionaryViewController
            else{
                print("error init MakeNewDictionaryViewController")
                return nil
        }
        self.vcChangeTitleDictionary = vc
        self.modelViewChangeTitleDictionary = ModelViewChangeTitleDictionary.init(dictionaryObjectChangeTitle: dictionaryChange, userName: userName)
        self.modelViewChangeTitleDictionary.vcChangeTitleDictionary = self.vcChangeTitleDictionary
        AppCoordinator.addCoordinatorToArray(coor: self)
        print("init CoordinatorChangeTitleDictionary")
    }

    deinit{
        self.modelViewChangeTitleDictionary.disposeBag = nil
        print("deinit CoordinatorChangeTitleDictionary")
    }

    func start(from nc: UINavigationController) -> Observable<Void> {
        self.nc = nc
        self.modelViewChangeTitleDictionary.binding()
        print("start coordinatorChangeTitleDictionary for userName: \(self.userName ?? "nil user")")
        self.nc.pushViewController(self.vcChangeTitleDictionary, animated: true)
        return Observable.empty()
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        return Observable.empty()
    }


}
