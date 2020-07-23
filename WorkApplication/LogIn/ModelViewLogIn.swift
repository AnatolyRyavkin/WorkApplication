//
//  ModelViewLogIn.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift


class ModelViewLogIn{

    weak var coordinatorLogIn: CoordinatorLogIn!

    private let disposeBag = DisposeBag()
    var realmUser: Realm {
        RealmUser.shared.realmUser
    }
    var loginFromTextField: String!
    weak var vcLogIn: ViewControllerLogin!
    var arrayUserObjects: Array<UserObjectRealm> {
        let r = Array<UserObjectRealm>(RealmUser.shared.realmUser.objects(UserObjectRealm.self))
        return r
    }
    var arrayUserName: [String]{
        let arrayUserName = self.arrayUserObjects.compactMap({ (userObjectRealm) -> String in
            if userObjectRealm.userName != "" {
                return userObjectRealm.userName
            } else {
                return "userDefault"
            }
        })
        return (arrayUserName.count == 0) ? ["userDefault"] : arrayUserName
    }
    var behaviorSubjectForPicker: BehaviorSubject<Array<String>>!
    var publishSubjectLaunchUserOld = PublishSubject<UserObjectRealm>()
    var publishSubjectLaunchUserNew = PublishSubject<String>()
    var observerOldUser: AnyObserver<UserObjectRealm>!
    var observerNewUser: AnyObserver<String>!

    var firstLaunchVCLogInDidAppear = true

    public static let Shared = ModelViewLogIn()

    private init(s: String? = nil){}

    convenience init(){
        self.init(s: nil)
        print(self.arrayUserName)
        self.behaviorSubjectForPicker = BehaviorSubject.init(value: self.arrayUserName)
        print("init ModelViewLogIn")
    }

    deinit {
        print("deinit ModelViewLogIn")
    }

    func binding(){

        guard let vcLogIn = self.vcLogIn else {
            print("self.vcLogin = nil")
            return
        }

        (vcLogIn as UIViewController).rx.viewWillAppear.asDriver().drive(onNext: { _ in
            if !self.firstLaunchVCLogInDidAppear {
                return
            }
            self.observerOldUser = AnyObserver<UserObjectRealm>.init{ event in
                switch event{
                case .next(let userObjectRealm):
                    UserObjectRealm.CurrentUserObjectRealm = userObjectRealm
                    let coordinatorListDictionary = CoordinatorListDictionary.init()
                    _ = self.coordinatorLogIn.coordinate(to: coordinatorListDictionary, from: self.vcLogIn.navigationController!)
                case .error(_):
                    print(event.error!)
                case .completed:
                    break
                }
            }


            self.observerNewUser = AnyObserver<String>.init{ event in
                switch event{
                case .next(let newUserObjectRealm):
                    self.showAllert(newUserName: newUserObjectRealm)
                case .error(_):
                    print(event.error!)
                case .completed:
                    break
                }
            }

        }).disposed(by: self.disposeBag)

//MARK- subscribe to vcLog


        (vcLogIn as UIViewController).rx.viewWillAppear.asDriver().drive(onNext: { _ in

            if !self.firstLaunchVCLogInDidAppear {
                return
            }
            self.firstLaunchVCLogInDidAppear = false

            self.vcLogIn.textFieldUsername.text = (self.arrayUserName.count > 0) ? self.arrayUserName[0] : ""

//MARK- Subscribe on launch ListDictionary


            self.publishSubjectLaunchUserOld.subscribe(self.observerOldUser).disposed(by: self.disposeBag)
            self.publishSubjectLaunchUserNew.subscribe(self.observerNewUser).disposed(by: self.disposeBag)

//MARK- subscribe textFieldUserName

//MARK- Enable Button Next


            self.vcLogIn.textFieldUsername.rx.text.asDriver().drive(onNext: { text in
                self.loginFromTextField = text
            }).disposed(by: self.disposeBag)

            self.vcLogIn.textFieldUsername.rx.observe(String.self, "text").asObservable().map { (string) -> Bool in
                self.loginFromTextField = string!
                self.vcLogIn.buttonNext.backgroundColor = myColor(arColor: ControlBackgroundActive1)
                self.vcLogIn.buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist.tintColor = myColor(arColor: ControlBackgroundActive1)
                return true
            }
            .do(onNext: { b in
                self.vcLogIn.buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist.isEnabled = b
            })
            .bind(to: self.vcLogIn.buttonNext.rx.isEnabled)
            .disposed(by: self.disposeBag)

            self.vcLogIn.textFieldUsername.rx.text
                .map { (string) -> Bool in
                    let isThreeCharts = !(string?.count ?? 0 < 1)
                    if isThreeCharts{
                        self.vcLogIn.buttonNext.backgroundColor = myColor(arColor: ControlBackgroundActive1)
                        self.vcLogIn.buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist.tintColor = myColor(arColor: ControlBackgroundActive1)
                        self.loginFromTextField = string
                    }else{
                        self.vcLogIn.buttonNext.backgroundColor = myColor(arColor: ControlBackgroundDontActive1)
                        self.vcLogIn.buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist.tintColor = myColor(arColor: ControlBackgroundDontActive1)
                    }
                    return isThreeCharts
            }
            .do(onNext: { b in
                self.vcLogIn.buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist.isEnabled = b
            })
            .bind(to: self.vcLogIn.buttonNext.rx.isEnabled)
            .disposed(by: self.disposeBag)


//MARK- Tap button Next

            self.vcLogIn.buttonNext.rx.tap.asDriver().drive(onNext: { _ in

                self.vcLogIn.textFieldUsername.resignFirstResponder()

                self.coordinatorLogIn.goToAtButtonNext(loginFromTextField: self.loginFromTextField)

            }).disposed(by: self.disposeBag)

//MARK- Tap button Find Profile

            self.vcLogIn.buttonFindProfile.rx.tap
                .map { !self.vcLogIn.pickerProfiles.isHidden }
                .do(onNext: { isDontHidden in
                    switch isDontHidden{
                    case false :
                        self.vcLogIn.textFieldUsername.text = self.arrayUserName[self.vcLogIn.pickerProfiles.selectedRow(inComponent: 0)]
                    case true :  self.vcLogIn.textFieldUsername.text = ""
                        self.vcLogIn.textFieldUsername.becomeFirstResponder()
                        self.vcLogIn.buttonNext.backgroundColor = myColor(arColor: ControlBackgroundDontActive1)
                        self.vcLogIn.buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist.tintColor = myColor(arColor: ControlBackgroundDontActive1)
                        if self.vcLogIn.textFieldUsername.text?.count == 0 {
                            self.vcLogIn.buttonNext.isEnabled = false
                            self.vcLogIn.buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist.isEnabled = false
                        }
                        else {
                            self.vcLogIn.buttonNext.isEnabled = isDontHidden
                            self.vcLogIn.buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist.isEnabled = isDontHidden
                        }
                    }
                })
                .bind(to: self.vcLogIn.pickerProfiles.rx.isHidden)
                .disposed(by: self.disposeBag)

            

            self.vcLogIn.buttonFindProfile.rx.tap
                .map { _ in
                    let b = self.vcLogIn.pickerProfiles.isUserInteractionEnabled
                    return !b
                }
                .bind(to: self.vcLogIn.pickerProfiles.rx.isUserInteractionEnabled)
                .disposed(by: self.disposeBag)

//MARK- PicerProfiles

            self.behaviorSubjectForPicker.bind(to: self.vcLogIn.pickerProfiles.rx.itemTitles){ _, string in
                self.vcLogIn.pickerProfiles.selectedRow(inComponent: 0)
                return string
            }.disposed(by: self.disposeBag)



            self.vcLogIn.pickerProfiles.rx.itemSelected.asDriver().drive(onNext: { (row, component) in
                self.vcLogIn.textFieldUsername.text = self.arrayUserName[row]
            }).disposed(by: self.disposeBag)

//MARK- buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist

            self.vcLogIn.buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist.rx.tap
                .asDriver()
                .drive(onNext: { _ in
                    guard let userName = self.vcLogIn.textFieldUsername.text else { return }
                    if (self.arrayUserName.contains(userName) && userName != "userDefault") ||
                        (userName == "userDefault"  && (RealmUser.shared.findUserObjectRealmAtUserName(userName: "userDefault") != nil) )  {
                        let alert = UIAlertController.init(title: "Warning", message: "Select delete profile \(userName) or clear the text field", preferredStyle: .alert)
                        alert.addAction(UIAlertAction.init(title: "Delete profile \(userName)", style: .default, handler: { _ in
                            RealmUser.shared.removeUserObjectIfExistAtUserName(userName: userName)
                            UserObjectRealm.CleanCurrentUser()
                            self.behaviorSubjectForPicker.onNext(self.arrayUserName)
                            self.vcLogIn.pickerProfiles.selectRow(0, inComponent: 0, animated: true)
                            self.vcLogIn.textFieldUsername.text = (self.arrayUserName.count > 0) ? self.arrayUserName[0] : ""
                        }))
                        alert.addAction(UIAlertAction.init(title: "Clear text field", style: .cancel, handler: nil) )
                        self.vcLogIn.present(alert, animated: true, completion: nil)
                    }
                self.vcLogIn.textFieldUsername.text = ""
                self.vcLogIn.buttonNext.isEnabled = false
                self.vcLogIn.buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist.isEnabled = false
                self.vcLogIn.buttonNext.backgroundColor = myColor(arColor: ControlBackgroundDontActive1)
                self.vcLogIn.buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist.tintColor = myColor(arColor: ControlBackgroundDontActive1)
            }).disposed(by: self.disposeBag)


        }).disposed(by: self.disposeBag)
    }

//MARK- alert

    func showAllert(newUserName: String) {

        let alert = UIAlertController(title: "Create", message: "Really create a new profile:  \(newUserName)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            let newUserObjectRealm = UserObjectRealm.init()
            try! RealmUser.shared.realmUser.write {
                newUserObjectRealm.userName = newUserName
                RealmUser.shared.realmUser.add(newUserObjectRealm, update: .all)
            }
            self.behaviorSubjectForPicker.onNext(self.arrayUserName)
            self.publishSubjectLaunchUserOld.onNext(newUserObjectRealm)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.vcLogIn.present(alert, animated: true, completion: nil)
    }
}
