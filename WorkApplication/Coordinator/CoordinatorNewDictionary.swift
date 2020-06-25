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

    var userName: String
    var vcNewDictionary: ViewControllerNewDictionary
    lazy var nc: UINavigationController! = vcNewDictionary.navigationController
    var modelViewNewDictionary: ModelViewNewDictionary!

    init?(userName: String) throws{
        self.userName = userName

        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcNewDictionary") as? ViewControllerNewDictionary
            else{
                print("error init ViewControllerDictionary")
                return nil
        }
        self.vcNewDictionary = vc
        self.modelViewNewDictionary = ModelViewNewDictionary.init(userName: userName, coordinatorNewDictionary: self)
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
        print("start coordinatorMakeDictionary for userName: \(self.userName)")
        self.nc.pushViewController(self.vcNewDictionary, animated: true)
        return Observable.empty()
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        _ = coordinator.start(from: nc)
        return Observable.empty()
    }

    func openDictionary(dictionaryObject: DictionaryObject){
        let cootdinatorDictionary = CoordinatorDictionary.init(dictionaryObject: dictionaryObject, userName: self.userName)
        _ = coordinate(to: cootdinatorDictionary, from: self.nc)
    }


}
