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

                    let attribute = [ NSAttributedString.Key.foregroundColor: myColor(arColor: LabelTitle1) ,
                                      NSAttributedString.Key.font: FontForTable.Shared,

                    ]

                    var string: String = "\(dictionary.listWordObjects.count)"
                    var attributeString = NSAttributedString(string: string, attributes: attribute)
                    cell.labelCountItem.attributedText = attributeString

                    string = dictionary.name
                    attributeString = NSAttributedString(string: string, attributes: attribute)
                    cell.labelNameDictionary.attributedText = attributeString

                    string = (dictionary.typeDictionary == TranslationDirection.EnRu.rawValue) ? TranslationDirection.EnRu.rawValue : TranslationDirection.RuEn.rawValue
                    attributeString = NSAttributedString(string: string, attributes: attribute)
                    cell.labelTypeDictionary.attributedText = attributeString

                    cell.contentView.backgroundColor = myColor(arColor: ViewBackground1)

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
                    UIView.animate(withDuration: 0.5) {
                        self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = myColor(arColor: ViewBackground1)
                    }
                }).disposed(by: self.disposeBag)

        }).disposed(by: self.disposeBag)

    }

}





























//               switch row{
//                case 0:
//                    let myShadow = NSShadow()
//                    myShadow.shadowBlurRadius = 2
//                    myShadow.shadowOffset = CGSize(width: 2, height: 2)
//                    myShadow.shadowColor = UIColor.gray
//
//                    let attribute = [ NSAttributedString.Key.foregroundColor: ColorScheme.Shared.colorBLCTextTitle ,
//                                      NSAttributedString.Key.font: FontForTable.Shared,
//                                      NSAttributedString.Key.shadow: myShadow,
//                    ]
//
//                    var string: String = "Count"
//                    var attributeString = NSAttributedString(string: string, attributes: attribute)
//                    cell.labelCountItem.attributedText = attributeString
//                    cell.labelCountItem.backgroundColor = ColorScheme.Shared.colorBLCBackgroundTitleTable
//
//                    string = "Name"
//                    attributeString = NSAttributedString(string: string, attributes: attribute)
//                    cell.labelNameDictionary.attributedText = attributeString
//                    cell.labelNameDictionary.backgroundColor = ColorScheme.Shared.colorBLCBackgroundTitleTable
//
//                    string = "Type"
//                    attributeString = NSAttributedString(string: string, attributes: attribute)
//                    cell.labelTypeDictionary.attributedText = attributeString
//                    cell.labelTypeDictionary.backgroundColor = ColorScheme.Shared.colorBLCBackgroundTitleTable
//
//                    cell.contentView.backgroundColor = ColorScheme.Shared.colorBLCBackgroundTitleTable

//                default:








//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let closeAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { ac, view, success in
//            ac.backgroundColor = UIColor.blue
//            success(true)
//         })
//         return UISwipeActionsConfiguration(actions: [closeAction])
//    }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let closeAction = UIContextualAction(style: .normal, title:  "Del", handler: { ac, view, success in
//            success(true)
//         })
//         closeAction.backgroundColor = .purple
//         return nil
//









//            tableView.rx.setDelegate(self).disposed(by: disposeBag)
//
//            self.dataSource?.asDriver(onErrorRecover: { error -> SharedSequence<DriverSharingStrategy, [DataSourceDecemalModelSection]> in
//                print(error)
//                return SharedSequence<DriverSharingStrategy, [DataSourceDecemalModelSection]>.just([DataSourceDecemalModelSection.init(numberDecade: 1)])
//            }).drive(tableView.rx.items(dataSource: modelTableViewModel2))
//                .disposed(by: disposeBag)
//
//            (self.viewControllerWithTableView as UIViewController).rx.viewWillAppear.subscribe(onNext: { _ in
//                self.model2.updateToInitial()
//            }).disposed(by: disposeBag)
//
//    //MARK- BarButton Taps
//
//            self.viewControllerWithTableView.barButtonAddSection.rx.tap.asDriver().drive(self.model2.observerNewSection)
//            .disposed(by: self.disposeBag)
//
//            self.viewControllerWithTableView.barButtonEditTableView.rx.tap
//                .do(onNext: { _ in
//                    self.editingStyleTableView = UITableViewCell.EditingStyle.delete
//                })
//                .bind(to: tableView.rx.edit).disposed(by: self.disposeBag)
//
//            self.viewControllerWithTableView.barButtonAddItem.rx.tap
//                .do(onNext: { _ in
//                    self.editingStyleTableView = UITableViewCell.EditingStyle.insert
//                })
//                .bind(to: tableView.rx.edit).disposed(by: self.disposeBag)
//
//    //MARK- Actions
//
//            tableView.rx.itemInserted.asDriver().drive(model2.observerItemInserted).disposed(by: disposeBag)
//
//            tableView.rx.itemSelected.asDriver().drive(model2.itemSelectedPublishSubject).disposed(by: self.disposeBag)
//
//            tableView.rx.itemMoved.asDriver { (error) -> SharedSequence<DriverSharingStrategy, (sourceIndex: IndexPath, destinationIndex: IndexPath)> in
//                SharedSequence<DriverSharingStrategy, (sourceIndex: IndexPath, destinationIndex: IndexPath)>.just((sourceIndex: IndexPath.init(row: 0, section: 0), destinationIndex: IndexPath.init(row: 0, section: 0)))
//            }.drive(model2.observerItemMoved).disposed(by: disposeBag)
//
//            tableView.rx.itemDeleted.asDriver().drive(model2.observerItemDeleted).disposed(by: disposeBag)
//
//
//
//        }

        //MARK- Delegate Table View

//        func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
//            print(self.editingStyleTableView.rawValue)
//            return  self.editingStyleTableView
//        }
//
//        func tableView(_ tableView: UITableView, commitEditingStyle indexPath: IndexPath) -> UITableViewCell.EditingStyle{
//            return  self.editingStyleTableView
//        }




