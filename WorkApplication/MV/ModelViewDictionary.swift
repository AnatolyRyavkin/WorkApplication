//
//  ModelViewDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 25.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ModelViewDictionary {

    weak var coordinatorDictionary: CoordinatorDictionary!

    var dictionaryObject: DictionaryObject!

    var disposeBag: DisposeBag! = DisposeBag()
    weak var vcDictionary: ViewControllerDictionary!
    var userName: String!

    var nc: UINavigationController?{
        return self.vcDictionary.navigationController
    }
    var dateSourseDictionaryForUser: DataSourceDictionariesForUser{
        if let dataSource = DataSourceDictionariesForUser.dataSourceDictionariesForUser,
            dataSource.userName == self.userName{
            return dataSource
        }else{
            return DataSourceDictionariesForUser.init(userName: self.userName)
        }
    }

    init(dictionaryObject: DictionaryObject, userName: String, coordinatorDictionary: CoordinatorDictionary){
        self.coordinatorDictionary = coordinatorDictionary
        self.dictionaryObject = dictionaryObject
        self.userName = userName
        print("init ModelViewDictionary")
    }

    deinit {
        print("deinit ModelViewDictionary")
    }

    func binding(){
        
        (self.vcDictionary as UIViewController).rx.viewWillDisappear.asDriver().drive(onNext: { _ in
            self.nc?.viewControllers.removeAll{
                $0 is ViewControllerDictionary
            }
            CoordinatorApp.arrayCoordinators.removeAll{
                $0 is CoordinatorDictionary
            }
        }).disposed(by: self.disposeBag)

        (self.vcDictionary as UIViewController).rx.viewDidLoad.asDriver().drive(onNext: { _ in
            //init sectionModel
            






        }).disposed(by: self.disposeBag)

        (self.vcDictionary as UIViewController).rx.viewDidAppear.asDriver().drive(onNext: { _ in
        }).disposed(by: self.disposeBag)
    }
}
