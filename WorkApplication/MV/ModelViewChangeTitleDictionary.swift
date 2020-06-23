//
//  ModelViewChangeTitleDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 22.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ModelViewChangeTitleDictionary{

    var dictionaryObjectChangeTitle: DictionaryObject!

    var disposeBag: DisposeBag! = DisposeBag()
    weak var vcChangeTitleDictionary: ChangeTitleDictionaryViewController!
    var userName: String!
    var textTitleInput: String!

    var nc: UINavigationController?{
        return self.vcChangeTitleDictionary.navigationController
    }
    var dateSourseBeginLaunch: DataSourceBeginLaunch{
        if let dataSource = DataSourceBeginLaunch.dataSourceBeginLaunchForUser,
            dataSource.userName == self.userName{
            return dataSource
        }else{
            return DataSourceBeginLaunch.init(userName: self.userName)
        }
    }

    init(dictionaryObjectChangeTitle: DictionaryObject, userName: String){
        self.dictionaryObjectChangeTitle = dictionaryObjectChangeTitle
        self.userName = userName
        print("init ModelViewChangeTitleDictionary")
    }

    deinit {
        print("deinit ModelViewChangeTitleDictionary")
    }

    func binding(){

        (self.vcChangeTitleDictionary as UIViewController).rx.viewWillDisappear.asDriver().drive(onNext: { _ in
            AppCoordinator.arrayCoordinators.removeAll {
                $0 is CoordinatorChangeTitleDictionary
            }
        }).disposed(by: self.disposeBag)

        (self.vcChangeTitleDictionary as UIViewController).rx.viewDidLoad.asDriver().drive(onNext: { _ in
            Observable<String>.just(self.dictionaryObjectChangeTitle.name)
            .bind(to: self.vcChangeTitleDictionary.textFieldOldName.rx.bindText)
            .disposed(by: self.disposeBag)
        }).disposed(by: self.disposeBag)

        (self.vcChangeTitleDictionary as UIViewController).rx.viewDidAppear.asDriver().drive(onNext: { _ in

            self.vcChangeTitleDictionary.textFieldNewName.becomeFirstResponder()
            
            self.vcChangeTitleDictionary.textFieldNewName.rx.text
            .map { (string) -> Bool in
                let isStringDontEmpty = string?.count ?? 0 < 1 || string?.filter{$0 == Character(" ")}.count == string?.count
                if !isStringDontEmpty{
                    self.vcChangeTitleDictionary.buttonSave.backgroundColor = ColorScheme.Shared.colorNDButtonContinueActive
                    self.textTitleInput = string
                }else{
                    self.vcChangeTitleDictionary.buttonSave.backgroundColor = ColorScheme.Shared.colorNDButtonContinueDontActive
                }
                return !isStringDontEmpty
            }
            .bind(to: self.vcChangeTitleDictionary.buttonSave.rx.isEnabled)
            .disposed(by: self.disposeBag)

            self.vcChangeTitleDictionary.buttonSave.rx.tap.asDriver()
            .drive(onNext: {
                try! self.dateSourseBeginLaunch.changeNameDictionary(dictionaryObject: self.dictionaryObjectChangeTitle, newName: self.textTitleInput)
                self.nc?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)

        }).disposed(by: self.disposeBag)

    }

}

