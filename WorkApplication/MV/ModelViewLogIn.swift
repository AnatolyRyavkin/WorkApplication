//
//  ModelViewLogIn.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift


class ModelViewLogIn{

    weak var coordinatorLogIn: CoordinatorLogIn!

    private let disposeBag = DisposeBag()
    var loginFromTextField: String!
    weak var vcLogIn: ViewControllerLogin!
    var arrayUserName: [String]
    var behaviorSubjectForPicker: BehaviorSubject<Array<String>>
    var publishSubjectLaunchUserOld = PublishSubject<String>()
    var publishSubjectLaunchUserNew = PublishSubject<String>()

    var firstLaunchVCLogInDidAppear = true

    public static let Shared = ModelViewLogIn()

    private init(){

        RequestsAPIYandexDictionary.Shared.requestTranslate(requestWord: "swift", translationDirection: .EnRu).subscribe(onNext: { wordCodable in
            guard let wordCodable = wordCodable else {return}
            try? ModelRealmWordCodable.Shared.appendWordRealmYAPI(wordCodable:wordCodable)
            print(" --- ")
            let text = ModelRealmWordCodable.Shared.getArrayWordRealmYAPI()
            print(text?.description ?? "sdkjlaovkj;a???")
            //dump(wordCodable)
        }).disposed(by: self.disposeBag)
        
        self.arrayUserName = UserDefaults.standard.object(forKey: "allUsers") as? [String] ?? ["Default profile"]
        print(self.arrayUserName)

        self.behaviorSubjectForPicker = BehaviorSubject.init(value: self.arrayUserName)
        print("init ModelViewLogIn")
    }

    deinit {
        print("deinit ModelViewLogIn")
    }

    func binding(){

        guard let vcLog = self.vcLogIn else {
            print("self.vcLogin = nil")
            return
        }


        (vcLog as UIViewController).rx.viewDidAppear.asDriver().drive(onNext: { _ in

            if !self.firstLaunchVCLogInDidAppear {
                return
            }
            self.firstLaunchVCLogInDidAppear = false

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
                    let isThreeCharts = !(string?.count ?? 0 < 1)
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
                var coordinatorListDictionary: CoordinatorListDictionary? = nil
                Observable.from(CoordinatorApp.arrayCoordinators).subscribe(onNext: {coordinator in
                    if coordinator is CoordinatorListDictionary {
                        coordinatorListDictionary = coordinator as? CoordinatorListDictionary
                    }
                }).disposed(by: self.disposeBag)

                if coordinatorListDictionary?.userName == userName && userName != nil{
                    guard let nc = self.vcLogIn.navigationController else {
                        return
                    }
                    nc.pushViewController(coordinatorListDictionary!.vcListDictionary, animated: true)
                    return
                }

                if coordinatorListDictionary != nil {
                    CoordinatorApp.arrayCoordinators.removeAll{
                        $0 is CoordinatorListDictionary
                    }
                }
                if userName != nil {
                    self.publishSubjectLaunchUserOld.onNext(userName!)
                }else{
                    self.publishSubjectLaunchUserNew.onNext(self.loginFromTextField)
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
            self.publishSubjectLaunchUserOld.onNext(newUser)
        }))
        alert.addAction(UIAlertAction(title: "Назад", style: UIAlertAction.Style.cancel, handler: nil))
        self.vcLogIn.present(alert, animated: true, completion: nil)
    }
}
