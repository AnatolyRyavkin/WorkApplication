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

    var firstVCBeginLaunchDidAppear = true

    init(userName: String){
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

            if !self.firstVCBeginLaunchDidAppear {
                return
            }
            self.firstVCBeginLaunchDidAppear = false
            
            self.tableView = self.vcBeginLaunch.tableView
            self.dateSourseBeginLaunch = DataSourceBeginLaunch.init(userName: self.userName)
            
            self.behaviorSubjectData = self.dateSourseBeginLaunch.behaviorSubject

            _ = self.behaviorSubjectData.bind(to: self.tableView.rx.items(cellIdentifier: "cellBeginLaunch", cellType: TableViewCellBeginLaunch.self)){row, dictionary, cell in

                cell.labelCountItem.text = "\(dictionary.listWordObjectsByID.count)"
                cell.labelNameDictionary.text = dictionary.name
                cell.labelTypeDictionary.text = (dictionary.typeDictionary == "typeDictionaryEngRus") ? "eng-rus" : "rus-eng"

            }

            self.vcBeginLaunch.barButtonAddDictionary.rx.tap
                .subscribe(onNext: {

                    Observable.from(AppCoordinator.arrayCoordinators)
                        .filter { (coor) -> Bool in
                            coor is CoordinatorBeginLaunch
                    }
                    .subscribe(onNext: { (coor) in
                        let coordinatorBeginLaunch = coor as! CoordinatorBeginLaunch
                        _ = coordinatorBeginLaunch.launchCoordinatorMakeNewDictionary(userName: self.userName)
                    }).disposed(by: self.disposeBag)

//                    do{
//                        try self.dateSourseBeginLaunch.appendDictionary()
//                    }catch let error{
//                        print(error.localizedDescription)
//                    }
            }).disposed(by: self.disposeBag)

        }).disposed(by: self.disposeBag)


    }

    

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



}
