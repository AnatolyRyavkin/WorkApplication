//
//  ModelViewNewDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 13.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ModelViewNewDictionary{

    weak var coordinatorNewDictionary: CoordinatorNewDictionary!
    
    var disposeBag: DisposeBag! = DisposeBag()
    weak var vcNewDictionary: ViewControllerNewDictionary!
    var userName: String!
    var textNameDictionaryInput: String!
    var typeDictionary: DictionaryObjectRealm.EnumDictionaryType!

    var segmentType: Int = 0
    var nc: UINavigationController?{
        return self.vcNewDictionary.navigationController
    }
    var dateSourseDictionaryForUser: MetodsForDictionary{
        if let dataSource = MetodsForDictionary.objectMetodsDictionaryForSpecificUser,
            dataSource.userName == self.userName{
            return dataSource
        }else{
            return MetodsForDictionary.init(userName: self.userName)
        }
    }

    var firstLaunchVCNewDictionaryDidAppear = true
    
    init(userName: String, coordinatorNewDictionary: CoordinatorNewDictionary){
        self.coordinatorNewDictionary = coordinatorNewDictionary
        self.userName = userName
        print("init ModelViewNewDictionary")
    }
    
    deinit {
        print("deinit ModelViewNewDictionary")
    }
    
    func binding(){

        (self.vcNewDictionary as UIViewController).rx.viewWillDisappear.asDriver().drive(onNext: { _ in
            CoordinatorApp.arrayCoordinators.removeAll {
                $0 is CoordinatorNewDictionary
            }
        }).disposed(by: self.disposeBag)


        (self.vcNewDictionary as UIViewController).rx.viewDidAppear.asDriver().drive(onNext: { _ in

            if self.firstLaunchVCNewDictionaryDidAppear == false{
                return
            }
            self.firstLaunchVCNewDictionaryDidAppear = false

            self.vcNewDictionary.textFieldImputNameDictionary.becomeFirstResponder()


            self.vcNewDictionary.textFieldImputNameDictionary.rx.text
            .map { (string) -> Bool in
                let isStringDontEmpty = string?.count ?? 0 < 1 || string?.filter{$0 == Character(" ")}.count == string?.count
                if !isStringDontEmpty{
                    self.vcNewDictionary.buttonSaveBack.backgroundColor = ColorScheme.Shared.colorNDButtonContinueActive
                    self.vcNewDictionary.buttonSaveNext.backgroundColor = ColorScheme.Shared.colorNDButtonContinueActive
                    self.textNameDictionaryInput = string
                }else{
                    self.vcNewDictionary.buttonSaveBack.backgroundColor = ColorScheme.Shared.colorNDButtonContinueDontActive
                    self.vcNewDictionary.buttonSaveNext.backgroundColor = ColorScheme.Shared.colorNDButtonContinueDontActive
                }
                self.vcNewDictionary.buttonSaveNext.isEnabled = !isStringDontEmpty
                return !isStringDontEmpty
            }
            .bind(to: self.vcNewDictionary.buttonSaveBack.rx.isEnabled)
            .disposed(by: self.disposeBag)


            self.vcNewDictionary.segmentTypeDictionary.rx.value.asDriver()
                .map({ (num) -> DictionaryObjectRealm.EnumDictionaryType in
                    return (num == 0) ? .typeDictionaryRusEng : .typeDictionaryEngRus
            })
            .drive(onNext: { typeDictionary in
                self.typeDictionary = typeDictionary
            }).disposed(by: self.disposeBag)

            self.vcNewDictionary.buttonSaveBack.rx.tap.asDriver()
            .drive(onNext: {

                
                try! self.dateSourseDictionaryForUser.appendDictionary(title: self.textNameDictionaryInput, type: self.typeDictionary)

                if let arrayVC = self.nc?.viewControllers{
                    let vc = arrayVC.filter { $0 is ViewControllerListDictionary }.first
                    if vc != nil{
                        self.nc?.popViewController(animated: true)
                    }else{print("error - vc = nil")}
                }else{print("error - arrayNC = nil")}

            }).disposed(by: self.disposeBag)

            self.vcNewDictionary.buttonSaveNext.rx.tap.asDriver()
            .drive(onNext: {
                try! self.dateSourseDictionaryForUser.appendDictionary(title: self.textNameDictionaryInput, type: self.typeDictionary)
                guard let dictionary = self.dateSourseDictionaryForUser.getLastDictionaryForUser() else {
                    print("dictionary = nil")
                    return
                }
                self.coordinatorNewDictionary!.openDictionary(dictionaryObject: dictionary)
                CoordinatorApp.arrayCoordinators.removeAll{
                    $0 is CoordinatorNewDictionary
                }
                self.nc?.viewControllers.removeAll{
                    $0 is ViewControllerNewDictionary
                }
            }).disposed(by: self.disposeBag)
            
        }).disposed(by: self.disposeBag)

    }
    
}
