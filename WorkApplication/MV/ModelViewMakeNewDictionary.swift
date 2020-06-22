//
//  ModelViewMakeNewDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 13.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ModelViewMakeNewDictionary{
    
    private var disposeBag: DisposeBag! = DisposeBag()
    weak var vcMakeNewDictionary: MakeNewDictionaryViewController!
    var userName: String!
    var behaviorSubjectData: BehaviorSubject<[DictionaryObject]>!
    var textTitleInput: String!
    var typeDictionary: DictionaryObject.EnumDictionaryType!

    var segmentType: Int = 0
    var nc: UINavigationController?{
        return self.vcMakeNewDictionary.navigationController
    }
    var dateSourseBeginLaunch: DataSourceBeginLaunch{
        if let dataSource = DataSourceBeginLaunch.dataSourceBeginLaunchForUser,
            dataSource.userName == self.userName{
            return dataSource
        }else{
            return DataSourceBeginLaunch.init(userName: self.userName)
        }
    }

    var firstVCMakeNewDictionaryDidAppear = true
    
    init(userName: String){
        self.userName = userName
        print("init ModelViewMakeNewDictionary")
    }
    
    deinit {
        print("deinit ModelViewMakeNewDictionary")
    }

    func cleanProperties() {
        disposeBag = nil
        vcMakeNewDictionary = nil
        userName = nil
        behaviorSubjectData = nil
    }
    
    func binding(){


        (self.vcMakeNewDictionary as UIViewController).rx.viewDidAppear.asDriver().drive(onNext: { _ in

            if self.firstVCMakeNewDictionaryDidAppear == false{
                return
            }
            self.firstVCMakeNewDictionaryDidAppear = false

            self.vcMakeNewDictionary.textFieldImputTitle.becomeFirstResponder()


            self.vcMakeNewDictionary.textFieldImputTitle.rx.text
            .map { (string) -> Bool in
                let isStringDontEmpty = string?.count ?? 0 < 1 || string?.filter{$0 == Character(" ")}.count == string?.count
                if !isStringDontEmpty{
                    self.vcMakeNewDictionary.buttonContinue.backgroundColor = ColorScheme.Shared.colorNDButtonContinueActive
                    self.textTitleInput = string
                }else{
                    self.vcMakeNewDictionary.buttonContinue.backgroundColor = ColorScheme.Shared.colorNDButtonContinueDontActive 
                }
                return !isStringDontEmpty
            }
            .bind(to: self.vcMakeNewDictionary.buttonContinue.rx.isEnabled)
            .disposed(by: self.disposeBag)


            self.vcMakeNewDictionary.segmentTypeDictionary.rx.value.asDriver()
                .map({ (num) -> DictionaryObject.EnumDictionaryType in
                    return (num == 0) ? .typeDictionaryRusEng : .typeDictionaryEngRus
            })
            .drive(onNext: { typeDictionary in
                self.typeDictionary = typeDictionary
            }).disposed(by: self.disposeBag)

            self.vcMakeNewDictionary.buttonContinue.rx.tap.asDriver()
            .drive(onNext: {

                try! self.dateSourseBeginLaunch.appendDictionary(title: self.textTitleInput, type: self.typeDictionary)

                if let arrayVC = self.nc?.viewControllers{
                    let vc = arrayVC.filter { $0 is BeginLaunchViewController }.first
                    if vc != nil{
                        self.nc?.popToViewController(vc!, animated: true)
                    }else{print("error - vc = nil")}
                }else{print("error - arrayNC = nil")}

            }).disposed(by: self.disposeBag)



        }).disposed(by: self.disposeBag)

    }
    
}
