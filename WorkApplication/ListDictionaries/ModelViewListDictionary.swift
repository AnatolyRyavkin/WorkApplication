//
//  ModelViewListDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources


class ModelViewListDictionary : NSObject {

    weak var coordinatorListDictionary: CoordinatorListDictionary?

    let cellListDictionary = "cellListDictionary"
    var disposeBag: DisposeBag! = DisposeBag()
    weak var vcListDictionary: ViewControllerListDictionary!
    var userObject: UserObjectRealm {
        UserObjectRealm.CurrentUserObjectRealm!
    }
    weak var tableView: UITableView!

    var firstvcListDictionaryDidAppear = true

    init( coordinatorListDictionary: CoordinatorListDictionary){
        self.coordinatorListDictionary = coordinatorListDictionary
        print("init ModelViewListDictionary")
    }

    deinit {
        print("deinit ModelViewListDictionary")
    }

    func binding(){

//MARK-  subscribe at vcListDictionary viewWillAppear

        (self.vcListDictionary as UIViewController).rx.viewWillAppear.asDriver().drive(onNext: { _ in

            self.vcListDictionary.navigationController?.navigationBar.addSubview(self.vcListDictionary.labelNavigationItem)
            self.vcListDictionary.labelNavigationItem.text = self.userObject.userName
            self.vcListDictionary.labelNavigationItem.textAlignment = .center
            
            self.vcListDictionary.tableView.isEditing = false
            if self.firstvcListDictionaryDidAppear == false {
                return
            }

            //self.userObject.metods.emmitingBehaviorSubjectDictionaryToUser()

        }).disposed(by: self.disposeBag)

//MARK-  subscribe at vcListDictionary viewDidAppear


        (self.vcListDictionary as UIViewController).rx.viewDidAppear.asDriver().drive(onNext: { _ in

            self.userObject.metods.emmitingBehaviorSubjectDictionaryToUser()
            
            if self.firstvcListDictionaryDidAppear == false {
                return
            }
            self.firstvcListDictionaryDidAppear = false
            
            self.tableView = self.vcListDictionary.tableView

            self.tableView.rx.isEdit.subscribe(onNext: { isEdit in
                self.vcListDictionary.barButtonEdit.tintColor = (isEdit) ? UIColor.red : myColor(arColor: NavigationBarTitle1)
            }).disposed(by: self.disposeBag)


            _ = self.userObject.metods.behaviorSubjectDictionaryToUser.bind(to: self.tableView.rx.items(cellIdentifier: "cellListDictionary", cellType: TableViewCellListDictionary.self)){row, dictionary, cell in

//                    let attribute = [ NSAttributedString.Key.foregroundColor: myColor(arColor: LabelTitle1) ,
//                                      NSAttributedString.Key.font: FontForTable.Shared,
//                    ]

                    let attributeButtonAdd = [ NSAttributedString.Key.foregroundColor: myColor(arColor: LabelTitle1) ,
                                  NSAttributedString.Key.font: FontForTable.Shared,
                    ]

                    var string: String = "\(dictionary.listWordObjects.count)"
                    var attributeString = NSAttributedString(string: string, attributes: attributeButtonAdd)
                    cell.labelCountItem.attributedText = attributeString

                    string = dictionary.name
                    attributeString = NSAttributedString(string: string, attributes: attributeButtonAdd)
                    cell.labelNameDictionary.attributedText = attributeString

                    string = (dictionary.typeDictionary == TranslationDirection.EnRu.rawValue) ? TranslationDirection.EnRu.rawValue : TranslationDirection.RuEn.rawValue
                    attributeString = NSAttributedString(string: string, attributes: attributeButtonAdd)
                    cell.labelTypeDictionary.attributedText = attributeString


                cell.backgroundColor = myColor(arColor: ViewBackground1)
                cell.contentView.layer.cornerRadius = 15
                cell.contentView.backgroundColor = myColor(arColor: LabelBackground2)

            }

            self.vcListDictionary.barButtonCancelProfile.rx.tap
                .subscribe(onNext: { _ in
                    _ = self.coordinatorListDictionary!.launchCoordinatorLogIn()
                }).disposed(by: self.disposeBag)

            self.vcListDictionary.barButtonAddDictionary.rx.tap
                .subscribe(onNext: {
                    _ = self.coordinatorListDictionary!.launchCoordinatorMakeNewDictionary()
            }).disposed(by: self.disposeBag)

            self.vcListDictionary.buttonAddDictionary.rx.tap
                .subscribe(onNext: {
                    _ = self.coordinatorListDictionary!.launchCoordinatorMakeNewDictionary()
            }).disposed(by: self.disposeBag)

            self.vcListDictionary.barButtonEdit.rx.tap
                .subscribe(onNext: {
                    self.tableView.setEditing(!self.tableView.isEditing, animated: true)
                }).disposed(by: self.disposeBag)

            self.tableView.rx.itemDeleted.asDriver().drive(onNext: { indexPath in
                self.userObject.metods.deleteDictionaryOnEverySideAtNumberInListDictionaryThisDictionary(numberDictionary: indexPath.row)
            }).disposed(by: self.disposeBag)

            self.tableView.rx.itemSelected.asDriver()
                .do(onNext: { indexPath in
                    self.tableView.deselectRow(at: indexPath, animated: true)
                })
                .do(onNext: { indexPath in
                    var dictionaryObject: DictionaryObjectRealm
                    self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = myColor(arColor: ViewBackground1)
                    dictionaryObject = self.userObject.listDictionary[indexPath.row]
                    switch self.tableView.isEditing{
                    case true:  _ = self.coordinatorListDictionary?.launchCoordinatorChangeTitleDictionary(dictionaryObjectRename: dictionaryObject)
                    case false:
                        self.coordinatorListDictionary!.openDictionary(dictionaryObject: dictionaryObject)
                    }

                })
                .drive(onNext: { indexPath in
                    UIView.animate(withDuration: 0.1) {
                        self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = myColor(arColor: LabelBackground2)
                    }
                }).disposed(by: self.disposeBag)

        }).disposed(by: self.disposeBag)

    }

}
