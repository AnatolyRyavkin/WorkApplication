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

    var dataSourse: DataSourseForTableWords!

    var firstvcListDictionaryDidAppear = true
    var isSubscribe:Disposable!

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

        print("binding")

        (self.vcDictionary as UIViewController).rx.viewDidLayoutSubviews
            .observeOn(MainScheduler.asyncInstance)
            .subscribeOn(MainScheduler.instance)
            .first()
            .subscribe({ _ in
                
                if self.firstvcListDictionaryDidAppear == false {
                    return
                }
                self.firstvcListDictionaryDidAppear = false

                self.tableView = self.vcDictionary.tableView
                self.tableView.isEditing = false
                self.vcDictionary.labelNavigationLabel.textColor = myColor(arColor: LabelTitle1)
                self.vcDictionary.labelNavigationLabel.text = "\(self.dictionaryObjectRealm.name) : \(self.dictionaryObjectRealm.typeDictionary)"

                self.tableView.rx.isEdit.subscribe(onNext: { isEdit in
                    self.vcDictionary.buttonEdit.tintColor = (isEdit) ? UIColor.red : myColor(arColor: NavigationBarTitle1)
                }).disposed(by: self.disposeBag)

                //MARK- binding dataSource with tableView

                self.dataSourse = DataSourseForTableWords.init(dictionary: self.dictionaryObjectRealm)
                self.dataSourse.behaviorSubjectModelsSectionDictionary//.debug()
                    .bind(to: self.tableView.rx.items(dataSource: ModelTableVeiwSectionDictionary.Shared)).disposed(by: self.disposeBag)

                self.tableView.rx.itemDeleted.asDriver().drive(onNext: { indexPath in

                }).disposed(by: self.disposeBag)

                //MARK- buttonAddWord subscribe

                self.vcDictionary.barButtonAdd.rx.tap.asDriver()
                    .drive(onNext: { _ in
                        self.vcDictionary.showSearchBarWithAnimation(durationAnimation: 0.3)
                    }).disposed(by: self.disposeBag)

                //MARK- search subcribe


                self.vcDictionary.searchBar.rx.searchButtonClicked
                    .subscribe(onNext: { _ in

                        try! self.dictionaryObjectRealm.metods.createNewWordObjectRealmFromRequestOrFromRealm(requestingString: self.textFromSearchBarCurrent, type: TranslationDirection.init(rawValue: self.dictionaryObjectRealm.typeDictionary)!, observerSuccess: { wordObjectRealm in

                            print("Word : \(wordObjectRealm.word)  Transclation First : \(wordObjectRealm.def[0].tr.first?.text! ?? "dont translate !!!! ")")

                            let alert = UIAlertController.init(title: "Alternativies", message: "Choose from the translation variations :", preferredStyle: .alert)

                            self.vcDictionary.searchBar.text = ""

                            wordObjectRealm.def[0].tr.forEach {  translationMeaningString in
                                guard let translationMeaningString = translationMeaningString.text else { return }

                                let action = UIAlertAction.init(title: translationMeaningString, style:
                                .default) { _ in

                                    if self.dictionaryObjectRealm.metods.returnWordObjectRealmIfExistSameToListSelfDictionarySameMainMeaning(wordAddMainMeaning: wordObjectRealm.word + translationMeaningString) != nil { return }

                                    if let wordObjectRealmFromRealm =  self.dictionaryObjectRealm.metods.returnWordObjectRealmIfExistSameToRealmSameMainMeaning(wordAddMainMeaning: wordObjectRealm.word + translationMeaningString) {

                                        self.dictionaryObjectRealm.metods
                                            .appendWordObjectRealmToDictionary(wordObjectRealm: wordObjectRealmFromRealm)
                                        return
                                    }

                                    self.dictionaryObjectRealm.metods.appendWordObjectRealmToDictionaryAndRealmWithKeyWord(wordObjectRealm: wordObjectRealm, mainMeaning: translationMeaningString)

                                }

                                alert.addAction(action)
                            }
                            self.vcDictionary.present(alert, animated: true, completion: nil)
                        })
                        { error in
                            var textError: String
                            switch error.myError() {
                            case .ERR_DONT_PARSING_WORD_OBJECT_REALM:
                                textError = "I couldn't find the translation, so try changing the word"
                            case .DONT_INTERNET:
                                textError = "no Internet connection"
                            default :
                                #if DEBUG
                                textError = error.myError().discript.nameError
                                #else
                                textError = "The service is not available"
                                #endif
                            }
                            let alert = UIAlertController.init(title: "Failure", message: textError, preferredStyle: .alert)
                            alert.addAction(UIAlertAction.init(title: "Ok", style: .cancel))
                            self.vcDictionary.present(alert, animated: true)
                        }

                    }).disposed(by: self.disposeBag)



//
//
//
//                                (wordObjectRealm in
//
//                                print("Word : \(wordObjectRealm.word)  Transclation First : \(wordObjectRealm.def[0].tr.first?.text! ?? "dont translate !!!! ")")
//
//                                let alert = UIAlertController.init(title: "Alternativies", message: "Choose from the translation variations :", preferredStyle: .alert)
//
//                                self.vcDictionary.searchBar.text = ""
//
//                                wordObjectRealm.def[0].tr.forEach {  translationMeaningString in
//                                    guard let translationMeaningString = translationMeaningString.text else { return }
//
//                                    let action = UIAlertAction.init(title: translationMeaningString, style:
//                                    .default) { _ in
//
//                                        if self.dictionaryObjectRealm.metods.returnWordObjectRealmIfExistSameToListSelfDictionarySameMainMeaning(wordAddMainMeaning: wordObjectRealm.word + translationMeaningString) != nil { return }
//
//                                        if let wordObjectRealmFromRealm =  self.dictionaryObjectRealm.metods.returnWordObjectRealmIfExistSameToRealmSameMainMeaning(wordAddMainMeaning: wordObjectRealm.word + translationMeaningString) {
//
//                                            self.dictionaryObjectRealm.metods
//                                                .appendWordObjectRealmToDictionary(wordObjectRealm: wordObjectRealmFromRealm)
//                                            return
//                                        }
//
//                                        self.dictionaryObjectRealm.metods.appendWordObjectRealmToDictionaryAndRealmWithKeyWord(wordObjectRealm: wordObjectRealm, mainMeaning: translationMeaningString)
//
//                                    }
//
//                                    alert.addAction(action)
//                                }
//                                self.vcDictionary.present(alert, animated: true, completion: nil)
//                            )
//                        } catch let error {
//                            var textError: String
//                            switch error.myError() {
//                            case .ERR_DONT_PARSING_WORD_OBJECT_REALM:
//                                textError = "I couldn't find the translation, so try changing the word"
//                            case .DONT_INTERNET:
//                                textError = "no Internet connection"
//                            default :
//                                #if DEBUG
//                                textError = error.myError().discript.nameError
//                                #else
//                                textError = "The service is not available"
//                                #endif
//                            }
//                            let alert = UIAlertController.init(title: "Failure", message: textError, preferredStyle: .alert)
//                            self.vcDictionary.present(alert, animated: true)
//                        }
//                    }).subscribe().disposed(by: self.disposeBag)








//                self.vcDictionary.searchBar.rx.searchButtonClicked
//                    .do(onNext: { _ in
//
//
//                        do {
//                            try self.dictionaryObjectRealm.metods.createNewWordObjectRealmFromRequestOrFromRealm(requestingString: self.textFromSearchBarCurrent, type: TranslationDirection.init(rawValue: self.dictionaryObjectRealm.typeDictionary)!) { wordObjectRealm in
//
//                                print("Word : \(wordObjectRealm.word)  Transclation First : \(wordObjectRealm.def[0].tr.first?.text! ?? "dont translate !!!! ")")
//
//                                let alert = UIAlertController.init(title: "Alternativies", message: "Choose from the translation variations :", preferredStyle: .alert)
//
//                                self.vcDictionary.searchBar.text = ""
//
//                                wordObjectRealm.def[0].tr.forEach {  translationMeaningString in
//                                    guard let translationMeaningString = translationMeaningString.text else { return }
//
//                                    let action = UIAlertAction.init(title: translationMeaningString, style:
//                                    .default) { _ in
//
//                                        if self.dictionaryObjectRealm.metods.returnWordObjectRealmIfExistSameToListSelfDictionarySameMainMeaning(wordAddMainMeaning: wordObjectRealm.word + translationMeaningString) != nil { return }
//
//                                        if let wordObjectRealmFromRealm =  self.dictionaryObjectRealm.metods.returnWordObjectRealmIfExistSameToRealmSameMainMeaning(wordAddMainMeaning: wordObjectRealm.word + translationMeaningString) {
//
//                                            self.dictionaryObjectRealm.metods
//                                                .appendWordObjectRealmToDictionary(wordObjectRealm: wordObjectRealmFromRealm)
//                                            return
//                                        }
//
//                                        self.dictionaryObjectRealm.metods.appendWordObjectRealmToDictionaryAndRealmWithKeyWord(wordObjectRealm: wordObjectRealm, mainMeaning: translationMeaningString)
//
//                                    }
//
//                                    alert.addAction(action)
//                                }
//                                self.vcDictionary.present(alert, animated: true, completion: nil)
//                            }
//                        } catch let error {
//                            var textError: String
//                            switch error.myError() {
//                            case .ERR_DONT_PARSING_WORD_OBJECT_REALM:
//                                textError = "I couldn't find the translation, so try changing the word"
//                            case .DONT_INTERNET:
//                                textError = "no Internet connection"
//                            default :
//                                #if DEBUG
//                                textError = error.myError().discript.nameError
//                                #else
//                                textError = "The service is not available"
//                                #endif
//                            }
//                            let alert = UIAlertController.init(title: "Failure", message: textError, preferredStyle: .alert)
//                            self.vcDictionary.present(alert, animated: true)
//                        }
//                    }).subscribe().disposed(by: self.disposeBag)

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
                            bool = AlphaBettaAllRus.filter { char in
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
                        self.textFromSearchBarCurrent = text
                    }).disposed(by: self.disposeBag)


                //MARK- subscribe barButtonEdit

                self.vcDictionary.buttonEdit.rx.tap
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

            }).disposed(by: self.disposeBag)

    }

}


