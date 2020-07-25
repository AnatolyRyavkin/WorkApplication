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

    enum ModeTable {
        case SortAlphaBetta
        case Sections
        case None
    }

    var modeSearchBar: ModeTable = .None

    weak var coordinatorDictionary: CoordinatorDictionary!
    weak var vcDictionary: ViewControllerDictionary!
    var dictionaryObjectRealm: DictionaryObjectRealm!
    weak var tableView: UITableView!

    var dataSourse: DataSourseForTableWords!

    var disposeBindDataSourceWithTableView : Disposable!

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
                self.disposeBindDataSourceWithTableView = self.dataSourse.behaviorSubjectModelsSectionDictionary//.debug()
                    .bind(to: self.tableView.rx.items(dataSource: ModelTableVeiwSectionDictionary.Shared))

                self.tableView.rx.itemDeleted.asDriver().drive(onNext: { indexPath in
                    print(indexPath)
                }).disposed(by: self.disposeBag)

                //MARK- change dataSource tableView

                self.vcDictionary.buttonSearch.rx.tap.asDriver()
                    .drive(onNext: { _ in
                        self.invocationTableAtSerch()
                    }).disposed(by: self.disposeBag)


                //MARK- enable searchBar subscribe

                self.vcDictionary.barButtonAdd.rx.tap.asDriver()
                    .drive(onNext: { _ in
                        switch self.modeSearchBar{
                        case .None:
                            self.modeSearchBar = .Sections
                            self.vcDictionary.barButtonAdd.tintColor = myColor(arColor: ControlTitleActive3)
                            self.vcDictionary.showSearchBarWithAnimation(durationAnimation: 0.3)
                            self.vcDictionary.searchBar.placeholder = "Search new word"
                        case .Sections:
                            self.modeSearchBar = .None
                            self.vcDictionary.barButtonAdd.tintColor = myColor(arColor: ControlTitleActive2)
                            self.vcDictionary.hiddenSearchBarWithAnimation(durationAnimation: 0.3)
                        case .SortAlphaBetta:
                            self.modeSearchBar = .Sections
                            self.disposeBindDataSourceWithTableView.dispose()
                            self.disposeBindDataSourceWithTableView = self.dataSourse.behaviorSubjectModelsSectionDictionary
                                .bind(to: self.tableView.rx.items(dataSource: ModelTableVeiwSectionDictionary.Shared))
                            UIView.animate(withDuration: 0.3, animations: {
                                self.vcDictionary.hiddenSearchBarWithAnimation(durationAnimation: 0)
                                self.vcDictionary.buttonSearch.tintColor = myColor(arColor: ControlTitleActive2)
                            }) { (y) in
                                self.vcDictionary.searchBar.placeholder = "Search new word"
                                self.vcDictionary.showSearchBarWithAnimation(durationAnimation: 0.3)
                                self.vcDictionary.barButtonAdd.tintColor = myColor(arColor: ControlTitleActive3)
                            }
                        }
                    }).disposed(by: self.disposeBag)

                self.vcDictionary.buttonSearch.rx.tap.asDriver()
                    .drive(onNext: { _ in
                        switch self.modeSearchBar{
                        case .None:
                            self.modeSearchBar = .SortAlphaBetta
                            self.vcDictionary.buttonSearch.tintColor = myColor(arColor: ControlTitleActive3)
                            self.vcDictionary.showSearchBarWithAnimation(durationAnimation: 0.3)
                            self.invocationTableAtSerch()
                            self.vcDictionary.searchBar.placeholder = "Search word to \(self.dictionaryObjectRealm.name)"
                        case .Sections:
                            self.modeSearchBar = .SortAlphaBetta
                            UIView.animate(withDuration: 1, animations: {
                                self.vcDictionary.hiddenSearchBarWithAnimation(durationAnimation: 0.3)
                                self.vcDictionary.barButtonAdd.tintColor = myColor(arColor: ControlTitleActive2)
                                UIView.animate(withDuration: 0.3, animations: {
                                    self.vcDictionary.searchBar.placeholder = "Search word to \(self.dictionaryObjectRealm.name)"
                                })
                            }) { (y) in
                                self.vcDictionary.showSearchBarWithAnimation(durationAnimation: 0.3)
                                self.vcDictionary.buttonSearch.tintColor = myColor(arColor: ControlTitleActive3)
                            }
                            self.invocationTableAtSerch()
                        case .SortAlphaBetta:
                            self.modeSearchBar = .None
                            self.vcDictionary.buttonSearch.tintColor = myColor(arColor: ControlTitleActive2)
                            self.vcDictionary.hiddenSearchBarWithAnimation(durationAnimation: 0.3)
                            self.disposeBindDataSourceWithTableView.dispose()
                            self.disposeBindDataSourceWithTableView = self.dataSourse.behaviorSubjectModelsSectionDictionary//.debug()
                                .bind(to: self.tableView.rx.items(dataSource: ModelTableVeiwSectionDictionary.Shared))
                            self.tableView.reloadData()
                        }
                    }).disposed(by: self.disposeBag)



                self.vcDictionary.searchBar.rx.cancelButtonClicked
                    .subscribe(onNext: { _ in

                        self.modeSearchBar = .None
                        self.vcDictionary.hiddenSearchBarWithAnimation(durationAnimation: 0.3)
                        self.vcDictionary.buttonSearch.tintColor = myColor(arColor: ControlTitleActive2)
                        self.vcDictionary.buttonSearch.tintColor = myColor(arColor: ControlTitleActive2)
                        if self.modeSearchBar == .SortAlphaBetta {
                            self.disposeBindDataSourceWithTableView.dispose()
                            self.disposeBindDataSourceWithTableView = self.dataSourse.behaviorSubjectModelsSectionDictionary
                        }
                    }).disposed(by: self.disposeBag)


                //MARK- search subcribe

                self.vcDictionary.searchBar.rx.searchButtonClicked
                    .subscribe(onNext: { _ in
                        switch self.modeSearchBar {
                        case .Sections:
                            self.searchNewWord()
                        case .SortAlphaBetta:
                            self.dictionaryObjectRealm.metods.emmitingBehaviorSubjectWordToAlphaBetta(text: self.textFromSearchBarCurrent)
                        default: break
                        }

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
                        if self.modeSearchBar == .SortAlphaBetta {
                            self.dictionaryObjectRealm.metods.emmitingBehaviorSubjectWordToAlphaBetta(text: self.textFromSearchBarCurrent)
                        }
                    }).disposed(by: self.disposeBag)

                //MARK- subscribe barButtonEdit

                self.vcDictionary.buttonEdit.rx.tap.bind(to: self.vcDictionary.tableView.rx.edit).disposed(by: self.disposeBag)

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

    func invocationTableAtSerch() {

        self.disposeBindDataSourceWithTableView.dispose()
        self.dictionaryObjectRealm.metods.emmitingBehaviorSubjectWordToAlphaBetta(text: "")
        self.disposeBindDataSourceWithTableView =
            self.dictionaryObjectRealm.metods.behaviorSubjectWordToAlphaBetta
                .bind(to: self.tableView.rx.items(cellIdentifier: "TableViewCellDictionaryWord", cellType: TableViewCellDictionaryWord.self)){row, word, cell in
                    cell.setMeaning(tableView: self.tableView)
                    let attributeLabelFirst = [ NSAttributedString.Key.foregroundColor: myColor(arColor: LabelTitle1) ,
                                                NSAttributedString.Key.font: FontForTable.Shared,
                    ]
                    let attributeLabelSecond = [ NSAttributedString.Key.foregroundColor: myColor(arColor: LabelTitle4) ,
                                                 NSAttributedString.Key.font: FontForTable.Shared,
                    ]

                    var string = word.word
                    var attributeString = NSAttributedString(string: string, attributes: attributeLabelFirst)
                    cell.labelFirst.attributedText = attributeString

                    string = word.mainMeaning
                    attributeString = NSAttributedString(string: string, attributes: attributeLabelSecond)
                    cell.labelSecond.attributedText = attributeString

                    cell.backgroundColor = myColor(arColor: LabelBackground1)
                    cell.contentView.backgroundColor = myColor(arColor: LabelBackground1)
        }
    }


    func searchNewWord() {
        try! self.dictionaryObjectRealm.metods.createNewWordObjectRealmFromRequestOrFromRealm(requestingString: self.textFromSearchBarCurrent, type: TranslationDirection.init(rawValue: self.dictionaryObjectRealm.typeDictionary)!, observerSuccess: { wordObjectRealm in

            print("Word : \(wordObjectRealm.word)  Transclation First : \(wordObjectRealm.def[0].tr.first?.text! ?? "dont translate !!!! ")")

            let alert = UIAlertController.init(title: "Alternativies", message: "Choose from the translation variations :", preferredStyle: .alert)

            self.vcDictionary.searchBar.text = ""

            wordObjectRealm.def[0].tr.forEach {  translationMeaningString in
                guard let translationMeaningString = translationMeaningString.text else { return }

                let action = UIAlertAction.init(title: translationMeaningString, style:
                .default) { action in
                    if self.dictionaryObjectRealm.metods.returnWordObjectRealmIfExistSameToListSelfDictionarySameMainMeaning(wordAddMainMeaning: wordObjectRealm.word + translationMeaningString) != nil { return }
                    if let wordObjectRealmFromRealm =  self.dictionaryObjectRealm.metods.returnWordObjectRealmIfExistSameToRealmSameMainMeaning(wordAddMainMeaning: wordObjectRealm.word + translationMeaningString) {
                        self.dictionaryObjectRealm.metods.appendWordObjectRealmToDictionary(wordObjectRealm: wordObjectRealmFromRealm)
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
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
                alert.dismiss(animated: true)
            }
        }
    }

    //MARK- delegate TableView

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return  .delete 
    }

}


