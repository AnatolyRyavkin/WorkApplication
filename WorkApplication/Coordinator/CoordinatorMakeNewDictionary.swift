//
//  CoordinatorMakeNewDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 13.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class CoordinatorMakeNewDictionary: CoordinatorProtocol{

    var userName: String
    var vcMakeNewDictionary: MakeNewDictionaryViewController
    lazy var nc: UINavigationController! = vcMakeNewDictionary.navigationController
    var modelViewMakeNewDictionary: ModelViewMakeNewDictionary!

    init?(userName: String) throws{
        self.userName = userName

        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcMakeNewDictionary") as? MakeNewDictionaryViewController
            else{
                print("error init MakeNewDictionaryViewController")
                return nil
        }
        self.vcMakeNewDictionary = vc
        self.modelViewMakeNewDictionary = ModelViewMakeNewDictionary.init(userName: userName)
        self.modelViewMakeNewDictionary.vcMakeNewDictionary = self.vcMakeNewDictionary
        AppCoordinator.addCoordinatorToArray(coor: self)
        print("init CoordinatorMakeNewDictionary")
    }

    deinit{
        self.modelViewMakeNewDictionary = nil
        print("deinit CoordinatorMakeNewDictionary")
    }

    func start(from nc: UINavigationController) -> Observable<Void> {
        self.nc = nc
        self.modelViewMakeNewDictionary.binding()
        print("start coordinatorMakeNewDictionary for userName: \(self.userName)")
        self.nc.pushViewController(self.vcMakeNewDictionary, animated: true)
        return Observable.empty()
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        return Observable.empty()
    }


}
