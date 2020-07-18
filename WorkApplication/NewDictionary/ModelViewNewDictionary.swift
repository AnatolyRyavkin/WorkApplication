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
    var userObjectRealm: UserObjectRealm = UserObjectRealm.CurrentUserObjectRealm!
    var textNameDictionaryInput: String!
    var typeDictionary: TranslationDirection!

    var segmentType: Int = 0
    var nc: UINavigationController?{
        return self.vcNewDictionary.navigationController
    }


    var firstLaunchVCNewDictionaryDidAppear = true
    
    init(coordinatorNewDictionary: CoordinatorNewDictionary){
        self.coordinatorNewDictionary = coordinatorNewDictionary
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
                .map({ (num) -> TranslationDirection in
                    return (num == 0) ? .RuEn : .EnRu
            })
            .drive(onNext: { typeDictionary in
                self.typeDictionary = typeDictionary
            }).disposed(by: self.disposeBag)


            self.vcNewDictionary.buttonSaveBack.rx.tap
            .do(onNext:{ _ in
                do {
                    _ = try self.userObjectRealm.metods.creatingDictionaryAndAddToListDictionaryThisUser(title: self.textNameDictionaryInput, type: self.typeDictionary)
                    if let arrayVC = self.nc?.viewControllers{
                        let vc = arrayVC.filter { $0 is ViewControllerListDictionary }.first
                        if vc != nil{
                            self.nc?.popViewController(animated: true)
                        }else{print("error - vc = nil")}
                    }else{print("error - arrayNC = nil")}
                } catch let error {
                    let myError = error.myError()
                    switch myError {
                    case .AlREADY_EXIST_TO_BASE_SAME_DICTIONARY_FOR_THIS_USER :
                        let alert = UIAlertController.init(title: "Attention ", message: "This Dictionary Already Exist", preferredStyle: .alert)
                        alert.addAction(UIAlertAction.init(title: "Replace with deleting the old one ", style: .default, handler: { _ in
                            guard
                            let dictionaryObjectRealm = self.userObjectRealm.metods.returnDictionaryIfAlreadyExistToBaseDictionaryWithSameParamsThisUser(title: self.textNameDictionaryInput, type: self.typeDictionary)
                                else { return }
                            self.userObjectRealm.metods.deleteDictionaryOnEverySide(deletingDictionary: dictionaryObjectRealm)
                            _ = try? self.userObjectRealm.metods.creatingDictionaryAndAddToListDictionaryThisUser(title: self.textNameDictionaryInput, type: self.typeDictionary)
                            if let arrayVC = self.nc?.viewControllers{
                                let vc = arrayVC.filter { $0 is ViewControllerListDictionary }.first
                                if vc != nil{
                                    self.nc?.popViewController(animated: true)
                                }else{print("error - vc = nil")}
                            }else{print("error - arrayNC = nil")}

                        }))

                        alert.addAction(UIAlertAction.init(title: "Cancel ", style: .cancel, handler: nil))

                        self.vcNewDictionary!.present(alert, animated: true, completion: nil)

                    default :
                        print(myError.discript.nameError)
                        let alert = UIAlertController.init(title: nil, message: "No Enternet", preferredStyle: .alert)
                        self.vcNewDictionary!.present(alert, animated: true, completion: nil)
                    }

                }
                })
            .subscribe()
            .disposed(by: self.disposeBag)


            self.vcNewDictionary.buttonSaveNext.rx.tap
            .do(onNext:{ _ in
                do {
                    let newDictionary = try self.userObjectRealm.metods.creatingDictionaryAndAddToListDictionaryThisUser(title: self.textNameDictionaryInput, type: self.typeDictionary)
                    self.coordinatorNewDictionary!.openDictionary(dictionaryObject: newDictionary!)
                    CoordinatorApp.arrayCoordinators.removeAll{
                        $0 is CoordinatorNewDictionary
                    }
                    self.nc?.viewControllers.removeAll{
                        $0 is ViewControllerNewDictionary
                    }

                } catch let error {
                    let myError = error.myError()
                    switch myError {
                    case .AlREADY_EXIST_TO_BASE_SAME_DICTIONARY_FOR_THIS_USER :
                        let alert = UIAlertController.init(title: "Attention ", message: "This Dictionary Already Exist", preferredStyle: .alert)
                        alert.addAction(UIAlertAction.init(title: "Replace with deleting the old one ", style: .default, handler: { _ in
                            guard
                            let dictionaryObjectRealm = self.userObjectRealm.metods.returnDictionaryIfAlreadyExistToBaseDictionaryWithSameParamsThisUser(title: self.textNameDictionaryInput, type: self.typeDictionary)
                                else { return }
                            self.userObjectRealm.metods.deleteDictionaryOnEverySide(deletingDictionary: dictionaryObjectRealm)
                            let newDictionary = try? self.userObjectRealm.metods.creatingDictionaryAndAddToListDictionaryThisUser(title: self.textNameDictionaryInput, type: self.typeDictionary)
                            self.coordinatorNewDictionary!.openDictionary(dictionaryObject: newDictionary!)
                            CoordinatorApp.arrayCoordinators.removeAll{
                                $0 is CoordinatorNewDictionary
                            }
                            self.nc?.viewControllers.removeAll{
                                $0 is ViewControllerNewDictionary
                            }
                        }))

                        alert.addAction(UIAlertAction.init(title: "Cancel ", style: .cancel, handler: nil))
                        self.vcNewDictionary!.present(alert, animated: true, completion: nil)

                    default :
                        print(myError.discript.nameError)
                        let alert = UIAlertController.init(title: nil, message: "No Enternet", preferredStyle: .alert)
                        self.vcNewDictionary!.present(alert, animated: true, completion: nil)
                    }

                }
                })
            .subscribe()
            .disposed(by: self.disposeBag)

            

//            self.vcNewDictionary.buttonSaveBack.rx.tap.asDriver()
//            .drive(onNext: {
//
//                try! self.userObjectRealm.metods.appendDictionary(title: self.textNameDictionaryInput, type: self.typeDictionary)
//
//                if let arrayVC = self.nc?.viewControllers{
//                    let vc = arrayVC.filter { $0 is ViewControllerListDictionary }.first
//                    if vc != nil{
//                        self.nc?.popViewController(animated: true)
//                    }else{print("error - vc = nil")}
//                }else{print("error - arrayNC = nil")}
//
//            }).disposed(by: self.disposeBag)


//            self.vcNewDictionary.buttonSaveNext.rx.tap.asDriver()
//            .drive(onNext: {
//
//                try! self.userObject.metods.appendDictionary(title: self.textNameDictionaryInput, type: self.typeDictionary)
//                guard let dictionary = self.userObject.metods.getLastDictionaryForUser() else {
//                    print("dictionary = nil")
//                    return
//                }
//                self.coordinatorNewDictionary!.openDictionary(dictionaryObject: dictionary)
//                CoordinatorApp.arrayCoordinators.removeAll{
//                    $0 is CoordinatorNewDictionary
//                }
//                self.nc?.viewControllers.removeAll{
//                    $0 is ViewControllerNewDictionary
//                }
//            }).disposed(by: self.disposeBag)
            
        }).disposed(by: self.disposeBag)

    }
    
}
