//
//  ModelViewRenameDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 22.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ModelViewRenameDictionary{

    weak var coordinatorRenameDictionary: CoordinatorRenameDictionary!

    var dictionaryObjectRename: DictionaryObjectRealm!

    var disposeBag: DisposeBag! = DisposeBag()
    weak var vcRenameDictionary: ViewControllerRenameDictionary!
    var userObjectRealm: UserObjectRealm = UserObjectRealm.CurrentUserObjectRealm!
    var textNameDictionaryInput: String!

    var nc: UINavigationController?{
        return self.vcRenameDictionary.navigationController
    }


    init(dictionaryObjectRename: DictionaryObjectRealm, coordinatorRenameDictionary: CoordinatorRenameDictionary){
        self.dictionaryObjectRename = dictionaryObjectRename
        self.coordinatorRenameDictionary = coordinatorRenameDictionary
        print("init ModelViewRenameDictionary")
    }

    deinit {
        print("deinit ModelViewRenameDictionary")
    }

    func binding(){

        (self.vcRenameDictionary as UIViewController).rx.viewWillDisappear.asDriver().drive(onNext: { _ in
            CoordinatorApp.arrayCoordinators.removeAll {
                $0 is CoordinatorRenameDictionary
            }
        }).disposed(by: self.disposeBag)

        (self.vcRenameDictionary as UIViewController).rx.viewDidLoad.asDriver().drive(onNext: { _ in
            Observable<String>.just(self.dictionaryObjectRename.name)
            .bind(to: self.vcRenameDictionary.textFieldOldName.rx.bindText)
            .disposed(by: self.disposeBag)
        }).disposed(by: self.disposeBag)

        (self.vcRenameDictionary as UIViewController).rx.viewDidAppear.asDriver().drive(onNext: { _ in

            self.vcRenameDictionary.textFieldNewName.becomeFirstResponder()
            
            self.vcRenameDictionary.textFieldNewName.rx.text
            .map { (string) -> Bool in
                let isStringDontEmpty = string?.count ?? 0 < 1 || string?.filter{$0 == Character(" ")}.count == string?.count
                if !isStringDontEmpty{
                    self.vcRenameDictionary.buttonSaveBack.backgroundColor = ColorScheme.Shared.colorNDButtonContinueActive
                    self.vcRenameDictionary.buttonSaveNext.backgroundColor = ColorScheme.Shared.colorNDButtonContinueActive
                    self.textNameDictionaryInput = string
                }else{
                    self.vcRenameDictionary.buttonSaveBack.backgroundColor = ColorScheme.Shared.colorNDButtonContinueDontActive
                    self.vcRenameDictionary.buttonSaveNext.backgroundColor = ColorScheme.Shared.colorNDButtonContinueDontActive
                }
                self.vcRenameDictionary.buttonSaveNext.isEnabled = !isStringDontEmpty
                return !isStringDontEmpty
            }
            .bind(to: self.vcRenameDictionary.buttonSaveBack.rx.isEnabled)
            .disposed(by: self.disposeBag)

            self.vcRenameDictionary.buttonSaveBack.rx.tap.asDriver()
            .drive(onNext: {
                //try! self.dictionaryObjectRename.metods.changeNameDictionary( newName: self.textNameDictionaryInput)
                try! self.userObjectRealm.metods.renameDictionary(dictionaryObjectRealm: self.dictionaryObjectRename, newName: self.textNameDictionaryInput)
                self.nc?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)

            self.vcRenameDictionary.buttonSaveNext.rx.tap.asDriver()
            .drive(onNext: {
                try! self.dictionaryObjectRename.metods.changeNameDictionary( newName: self.textNameDictionaryInput)
                self.coordinatorRenameDictionary!.openDictionary(dictionaryObject: self.dictionaryObjectRename)
                CoordinatorApp.arrayCoordinators.removeAll{
                    $0 is CoordinatorRenameDictionary
                }
                self.nc?.viewControllers.removeAll{
                    $0 is ViewControllerRenameDictionary
                }
            }).disposed(by: self.disposeBag)

        }).disposed(by: self.disposeBag)

    }

}

