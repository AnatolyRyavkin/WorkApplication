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

class ModelViewDictionary: NSObject, UIScrollViewDelegate {

    weak var coordinatorDictionary: CoordinatorDictionary!
    weak var vcDictionary: ViewControllerDictionary!
    var dictionaryObjectRealm: DictionaryObjectRealm!
    weak var tableView: UITableView!

    var firstvcListDictionaryDidAppear = true

    var nc: UINavigationController?{
        return self.vcDictionary.navigationController
    }

    var textFromSearchBarCurrent: String!

    var disposeBag: DisposeBag! = DisposeBag()

    init(dictionaryObject: DictionaryObjectRealm, coordinatorDictionary: CoordinatorDictionary){
        self.coordinatorDictionary = coordinatorDictionary
        self.dictionaryObjectRealm = dictionaryObject
        print("init ModelViewDictionary")
    }

    deinit {
        self.dictionaryObjectRealm.metods.dictionary = nil
        self.dictionaryObjectRealm = nil
        self.vcDictionary = nil
        self.tableView = nil
        self.disposeBag = nil

        print("deinit ModelViewDictionary")
    }

    func binding(){

        (self.vcDictionary as UIViewController).rx.viewWillAppear.asDriver().drive(onNext: { _ in
            self.tableView = self.vcDictionary.tableView
            self.tableView.isEditing = false
            self.vcDictionary.labelNavigationLabel.text = "\(self.dictionaryObjectRealm.name) : \(self.dictionaryObjectRealm.typeDictionary)"
            self.vcDictionary.hiddenSearchBarWithoutAnimation()
        }).disposed(by: self.disposeBag)

        (self.vcDictionary as UIViewController).rx.viewDidAppear.asDriver().drive(onNext: { _ in

            if self.firstvcListDictionaryDidAppear == false {
                return
            }
            self.firstvcListDictionaryDidAppear = false

            self.tableView.rx.isEdit.subscribe(onNext: { isEdit in
                self.vcDictionary.barButtonEdit.tintColor = (isEdit) ? UIColor.red : ColorScheme.Shared.cFFE69C
            }).disposed(by: self.disposeBag)

            //MARK- binding dataSource with tableView

            let dataSourse = DataSourseForTableWords.init(dictionary: self.dictionaryObjectRealm)

//            dataSourse.behaviorSubjectModelsSectionDictionary.debug()
//                .subscribe(onNext: { m in 
//                    print(m.debugDescription)
//                }).disposed(by: self.disposeBag)

            dataSourse.behaviorSubjectModelsSectionDictionary//.debug()
                .bind(to: self.tableView.rx.items(dataSource: ModelTableVeiwSectionDictionary.Shared)).disposed(by: self.disposeBag)

            self.tableView.rx.itemDeleted.asDriver().drive(onNext: { indexPath in

            }).disposed(by: self.disposeBag)

            //self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)

            //MARK- buttonAddWord subscribe

            self.vcDictionary.buttonAddWord.rx.tap.asDriver()
                .drive(onNext: { _ in
                    self.vcDictionary.showSearchBarWithAnimation(durationAnimation: 0.3)
                }).disposed(by: self.disposeBag)

            //MARK- search subcribe

            self.vcDictionary.searchBar.rx.searchButtonClicked
                .do(onNext: { _ in
                    do {
                        try self.dictionaryObjectRealm.metods.createNewWordObjectRealmFromRequest(requestingString: self.textFromSearchBarCurrent, type: TranslationDirection.init(rawValue: self.dictionaryObjectRealm.typeDictionary)!) { wordObjectRealm in

                            print("Word : \(wordObjectRealm.word)  Transclation First : \(wordObjectRealm.def[0].tr.first?.text! ?? "dont translate !!!! ")")

                            let alert = UIAlertController.init(title: "Alternativies", message: "Choose from the translation variations :", preferredStyle: .alert)

                            self.vcDictionary.searchBar.text = ""

                            wordObjectRealm.def[0].tr.forEach{ (translationObject) in
                                guard let translateWord = translationObject.text else { return }
                                let action = UIAlertAction.init(title: translateWord, style:
                                .default) { _ in
                                    //print(self.dictionaryObjectRealm.debugDescription)
                                    self.dictionaryObjectRealm.metods.appendWordObjectRealmToDictionaryAndRealmWithKeyWord(wordObjectRealm: wordObjectRealm, mainMeaning: translateWord)
                                }
                                alert.addAction(action)
                            }
                            self.vcDictionary.present(alert, animated: true, completion: nil)

                        }
                    } catch let error {
                        switch error.myError() {
                        default :
                            self.vcDictionary.present(UIAlertController.init(title: "Error", message: error.myError().discript.nameError, preferredStyle: .alert), animated: true)
                        }
                    }
                }).subscribe().disposed(by: self.disposeBag)

            self.vcDictionary.searchBar.rx.cancelButtonClicked
                .subscribe(onNext: { _ in
                    self.vcDictionary.searchBar.text = ""
                    self.vcDictionary.hiddenSearchBarWithAnimation(durationAnimation: 0.3)
                }).disposed(by: self.disposeBag)


            self.vcDictionary.searchBar.rx.text
                .orEmpty.asObservable()
                .filter({ text  in
                    guard text != "" else {
                        return false
                    }
                    var bool = false
                    switch self.dictionaryObjectRealm.typeDictionary {
                    case TranslationDirection.EnRu.rawValue :
                        bool = AlphaBettaAllEng.filter { char in
                            char == text.last!
                        }.count > 0
                    case TranslationDirection.RuEn.rawValue :
                    bool = AlphaBettaAllEng.filter { char in
                        char == text.last!
                    }.count > 0
                    default: return false
                    }
                    if bool == false {
                        var textLast = text
                        textLast.removeLast()
                        self.vcDictionary.searchBar.text = textLast
                    }
                    return bool
                })
                .subscribe(onNext: { text in
                    print(text)
                    self.textFromSearchBarCurrent = text
                }).disposed(by: self.disposeBag)


            //MARK- subscribe barButtonEdit

            self.vcDictionary.barButtonEdit.rx.tap
                .subscribe(onNext: {
                    self.tableView.setEditing(!self.tableView.isEditing, animated: true)
                }).disposed(by: self.disposeBag)
        
        (self.vcDictionary as UIViewController).rx.viewWillDisappear.asDriver().drive(onNext: { _ in
            self.nc?.viewControllers.removeAll{
                $0 is ViewControllerDictionary
            }
            CoordinatorApp.arrayCoordinators.removeAll{
                $0 is CoordinatorDictionary
            }
        }).disposed(by: self.disposeBag)

        (self.vcDictionary as UIViewController).rx.viewDidLoad.asDriver().drive(onNext: { _ in

        }).disposed(by: self.disposeBag)

        (self.vcDictionary as UIViewController).rx.viewDidAppear.asDriver().drive(onNext: { _ in

        }).disposed(by: self.disposeBag)


    })

}




}


