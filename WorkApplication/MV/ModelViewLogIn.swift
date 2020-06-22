//
//  ModelViewLogIn.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift


class ModelViewLogIn {

    private let disposeBag = DisposeBag()
    var loginFromTextField: String!
    var vcLogIn: LoginViewController!
    var arrayUserName: [String]
    var behaviorSubjectForPicker: BehaviorSubject<Array<String>>
    var publishSubjectUserLaunchOld = PublishSubject<String>()
    var publishSubjectUserLaunchNew = PublishSubject<String>()

    var firstVCLogInDidAppear = true

    public static let Shared = ModelViewLogIn()

    private init(){
        self.arrayUserName = UserDefaults.standard.object(forKey: "allUsers") as? [String] ?? ["Default profile"]
        print(self.arrayUserName)
        self.behaviorSubjectForPicker = BehaviorSubject.init(value: self.arrayUserName)
        print("init ModelViewLogIn")
    }

    deinit {
        print("deinit ModelViewLogIn")
    }

    func linking(){

        guard let vcLog = self.vcLogIn else {
            print("self.vcLogin = nil")
            return
        }


        (vcLog as UIViewController).rx.viewDidAppear.asDriver().drive(onNext: { _ in

            if !self.firstVCLogInDidAppear {
                return
            }
            self.firstVCLogInDidAppear = false

            //MARK- Enable Button Next

            self.vcLogIn.textFieldUsername.rx.text.asDriver().drive(onNext: { text in
                self.loginFromTextField = text
            }).disposed(by: self.disposeBag)

            self.vcLogIn.textFieldUsername.rx.observe(String.self, "text").asObservable().map { (string) -> Bool in
                self.loginFromTextField = string!
                self.vcLogIn.buttonNext.backgroundColor = ColorScheme.Shared.colorLVCButtonNextActive
                return true
            }
            .bind(to: self.vcLogIn.buttonNext.rx.isEnabled)
            .disposed(by: self.disposeBag)

            self.vcLogIn.textFieldUsername.rx.text
                .map { (string) -> Bool in
                    let isThreeCharts = !(string?.count ?? 0 < 3)
                    if isThreeCharts{
                        self.vcLogIn.buttonNext.backgroundColor = ColorScheme.Shared.colorLVCButtonNextActive
                        self.loginFromTextField = string
                    }else{
                        self.vcLogIn.buttonNext.backgroundColor = ColorScheme.Shared.colorLVCButtonNextDontActive
                    }
                    return isThreeCharts
            }
            .bind(to: self.vcLogIn.buttonNext.rx.isEnabled)
            .disposed(by: self.disposeBag)


            //MARK- Tap button Next

            self.vcLogIn.buttonNext.rx.tap.asDriver().drive(onNext: { _ in
                let userName = UserDefaults.standard.readLogged(forKey: self.loginFromTextField)
                var coordinatorBeginLaunch: CoordinatorBeginLaunch? = nil
                Observable.from(AppCoordinator.arrayCoordinators).subscribe(onNext: {coordinator in
                    if coordinator is CoordinatorBeginLaunch {
                        coordinatorBeginLaunch = coordinator as? CoordinatorBeginLaunch
                    }
                }).disposed(by: self.disposeBag)

                if coordinatorBeginLaunch?.userName == userName && userName != nil{
                    guard let nc = self.vcLogIn.navigationController else {
                        return
                    }
                    nc.pushViewController(coordinatorBeginLaunch!.vcBeginLaunch, animated: true)
                    return
                }

                if coordinatorBeginLaunch != nil {
//                    let nc = self.vcLogIn.navigationController
                    // dont ->
//                    nc?.viewControllers.removeAll{
//                        $0 === coordinatorBeginLaunch!.vcBeginLaunch
//                    }
                    AppCoordinator.arrayCoordinators.removeAll{
                        $0 is CoordinatorBeginLaunch
                    }
                    coordinatorBeginLaunch!.modelViewBeginLaunch.cleanProperties()
                    coordinatorBeginLaunch!.cleanProperties()
                    AppCoordinator.Shared.coordinatorBeginLaunch = nil
                    CoordinatorLogIn.Shared.coordinatorBeginLaunch = nil
                }

                if userName != nil {
                    self.publishSubjectUserLaunchOld.onNext(userName!)
                }else{
                    self.publishSubjectUserLaunchNew.onNext(self.loginFromTextField)
                }
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
                        self.vcLogIn.buttonNext.backgroundColor = ColorScheme.Shared.colorLVCButtonNextDontActive
                        self.vcLogIn.buttonNext.isEnabled = isDontHidden
                    }
                })
                .bind(to: self.vcLogIn.pickerProfiles.rx.isHidden)
                .disposed(by: self.disposeBag)

            self.vcLogIn.buttonFindProfile.rx.tap
                .map { !self.vcLogIn.pickerProfiles.isUserInteractionEnabled }
                .bind(to: self.vcLogIn.pickerProfiles.rx.isUserInteractionEnabled)
                .disposed(by: self.disposeBag)

            self.behaviorSubjectForPicker.bind(to: self.vcLogIn.pickerProfiles.rx.itemTitles){ _, string in
                return string
            }.disposed(by: self.disposeBag)

            self.vcLogIn.pickerProfiles.rx.itemSelected.asDriver().drive(onNext: { (row, component) in
                self.vcLogIn.textFieldUsername.text = self.arrayUserName[row]
            }).disposed(by: self.disposeBag)

        }).disposed(by: self.disposeBag)
    }

    func showAllert(newUser: String) {
        let alert = UIAlertController(title: "Подтвердить", message: "Действительно создать новый профайл:  \(newUser)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Продолжить", style: .default, handler: { action in
            UserDefaults.standard.setLoggedIn(userName: newUser)
            self.arrayUserName.append(newUser)
            self.behaviorSubjectForPicker.onNext(self.arrayUserName)
            self.publishSubjectUserLaunchOld.onNext(newUser)
        }))
        alert.addAction(UIAlertAction(title: "Назад", style: UIAlertAction.Style.cancel, handler: nil))
        self.vcLogIn.present(alert, animated: true, completion: nil)
    }
}
