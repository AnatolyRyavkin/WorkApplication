//
//  ModelViewBeginLaunch.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources


class ModelViewBeginLaunch : NSObject, ModelView, UITableViewDelegate{

    let cellBeginLaunch = "cellBeginLaunch"

    private var disposeBag: DisposeBag! = DisposeBag()
    var vcBeginLaunch: BeginLaunchViewController!
    var userName: String!
    var tableView: UITableView!
    var dateSourseBeginLaunch: DataSourceBeginLaunch!
    var behaviorSubjectData: BehaviorSubject<[DictionaryObject]>!

    weak var coordinatorBeginLaunch: CoordinatorBeginLaunch?

    var firstVCBeginLaunchDidAppear = true

    init(userName: String, coordinator: CoordinatorBeginLaunch){
        self.coordinatorBeginLaunch = coordinator
        self.userName = userName
        print("init ModelViewBeginLaunch")
    }

    deinit {
        print("deinit ModelViewBeginLaunch")
    }

    func cleanProperties() {
        disposeBag = nil
        vcBeginLaunch = nil
        userName = nil
        tableView = nil
        dateSourseBeginLaunch = nil
        behaviorSubjectData = nil
    }

    func binding(){

        (self.vcBeginLaunch as UIViewController).rx.viewDidAppear.asDriver().drive(onNext: { _ in

            if self.firstVCBeginLaunchDidAppear == false {
                return
            }
            self.firstVCBeginLaunchDidAppear = false
            
            self.tableView = self.vcBeginLaunch.tableView
            
            self.dateSourseBeginLaunch = DataSourceBeginLaunch.init(userName: self.userName)
            
            self.behaviorSubjectData = self.dateSourseBeginLaunch.behaviorSubject

            _ = self.behaviorSubjectData.bind(to: self.tableView.rx.items(cellIdentifier: "cellBeginLaunch", cellType: TableViewCellBeginLaunch.self)){row, dictionary, cell in
                switch row{
                case 0:
                    let myShadow = NSShadow()
                    myShadow.shadowBlurRadius = 2
                    myShadow.shadowOffset = CGSize(width: 2, height: 2)
                    myShadow.shadowColor = UIColor.gray

                    let attribute = [ NSAttributedString.Key.foregroundColor: ColorScheme.Shared.colorBLCTextTitle ,
                                      NSAttributedString.Key.font: UIFont(name: "Futura", size: 25.0)!,
                                      NSAttributedString.Key.shadow: myShadow,
                    ]
                    
                    var string: String = "Count"
                    var attributeString = NSAttributedString(string: string, attributes: attribute)
                    cell.labelCountItem.attributedText = attributeString
                    cell.labelCountItem.backgroundColor = ColorScheme.Shared.colorBLCBackgroundTitleTable

                    string = "Name"
                    attributeString = NSAttributedString(string: string, attributes: attribute)
                    cell.labelNameDictionary.attributedText = attributeString
                    cell.labelNameDictionary.backgroundColor = ColorScheme.Shared.colorBLCBackgroundTitleTable

                    string = "Type"
                    attributeString = NSAttributedString(string: string, attributes: attribute)
                    cell.labelTypeDictionary.attributedText = attributeString
                    cell.labelTypeDictionary.backgroundColor = ColorScheme.Shared.colorBLCBackgroundTitleTable

                    cell.contentView.backgroundColor = ColorScheme.Shared.colorBLCBackgroundTitleTable

                default:

                    let attribute = [ NSAttributedString.Key.foregroundColor: ColorScheme.Shared.colorBLCText ,
                                      NSAttributedString.Key.font: UIFont(name: "Futura", size: 20.0)!,

                    ]

                    var string: String = "\(dictionary.listWordObjectsByID.count)"
                    var attributeString = NSAttributedString(string: string, attributes: attribute)
                    cell.labelCountItem.attributedText = attributeString

                    string = dictionary.name
                    attributeString = NSAttributedString(string: string, attributes: attribute)
                    cell.labelNameDictionary.attributedText = attributeString

                    string = (dictionary.typeDictionary == "typeDictionaryEngRus") ? "eng-rus" : "rus-eng"
                    attributeString = NSAttributedString(string: string, attributes: attribute)
                    cell.labelTypeDictionary.attributedText = attributeString

                    cell.contentView.backgroundColor = ColorScheme.Shared.colorBLCBackgroundShared

                }

            }

            self.vcBeginLaunch.barButtonAddDictionary.rx.tap
                .subscribe(onNext: {
                    _ = self.coordinatorBeginLaunch!.launchCoordinatorMakeNewDictionary(userName: self.userName)
            }).disposed(by: self.disposeBag)

            self.vcBeginLaunch.barButtonEdit.rx.tap
                .subscribe(onNext: {
                    self.tableView.setEditing(!self.tableView.isEditing, animated: true)
                }).disposed(by: self.disposeBag)

            self.tableView.rx.itemDeleted.asDriver().drive(onNext: { indexPath in
                if indexPath.row != 0 {
                    self.dateSourseBeginLaunch.deleteDictionary(numberDictionary: indexPath.row - 1)
                }
            }).disposed(by: self.disposeBag)

            self.tableView.rx.itemSelected.asDriver()
                .do(onNext: { indexPath in
                    self.tableView.deselectRow(at: indexPath, animated: false)
                })
                .filter({ indexPath -> Bool in
                    indexPath.row != 0
                })
                .do(onNext: { indexPath in
                    self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = ColorScheme.Shared.colorBLCCellSelected
                })
                .drive(onNext: { indexPath in
                    UIView.animate(withDuration: 0.5) {
                        self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = ColorScheme.Shared.colorBLCBackgroundShared
                    }
                }).disposed(by: self.disposeBag)

            self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)



        }).disposed(by: self.disposeBag)

    }

    //MARK- tableViewDelegate

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch indexPath.row {
        case 0:
            return UITableViewCell.EditingStyle.none
        default:
            return UITableViewCell.EditingStyle.delete
        }
    }

}








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




