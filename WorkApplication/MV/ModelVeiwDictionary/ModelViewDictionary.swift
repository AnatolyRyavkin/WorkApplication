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

    var dictionaryObject: DictionaryObjectRealm!

    var disposeBag: DisposeBag! = DisposeBag()
    weak var vcDictionary: ViewControllerDictionary!
    var userName: String!

    var firstvcListDictionaryDidAppear = true

    var tableView: UITableView!

    var nc: UINavigationController?{
        return self.vcDictionary.navigationController
    }

//    var dateSourseDictionaryForUser: MetodsForDictionary{
//        if let dataSource = MetodsForDictionary.objectMetodsDictionaryForSpecificUser,
//            dataSource.userName == self.userName{
//            return dataSource
//        }else{
//            return MetodsForDictionary.init(userName: self.userName)
//        }
//    }

    init(dictionaryObject: DictionaryObjectRealm, userName: String, coordinatorDictionary: CoordinatorDictionary){
        self.coordinatorDictionary = coordinatorDictionary
        self.dictionaryObject = dictionaryObject
        self.userName = userName
        print("init ModelViewDictionary")
    }

    deinit {
        print("deinit ModelViewDictionary")
    }

    func binding(){


        (self.vcDictionary as UIViewController).rx.viewWillAppear.asDriver().drive(onNext: { _ in
            self.tableView = self.vcDictionary.tableView
            self.tableView.isEditing = false
        }).disposed(by: self.disposeBag)


        (self.vcDictionary as UIViewController).rx.viewDidAppear.asDriver().drive(onNext: { _ in



            if self.firstvcListDictionaryDidAppear == false {
                return
            }
            self.firstvcListDictionaryDidAppear = false

            //self.tableView = self.vcDictionary.tableView

            self.tableView.rx.isEdit.subscribe(onNext: { isEdit in
                self.vcDictionary.barButtonEdit.tintColor = (isEdit) ? UIColor.red : ColorScheme.Shared.cFFE69C
            }).disposed(by: self.disposeBag)

            self.dictionaryObject.behaviorSubjectModelSectionDictionary
                .bind(to: self.tableView.rx.items(dataSource: ModelTableVeiwSectionDictionary.Shared)).disposed(by: self.disposeBag)


//            self.dictionaryObject.behaviorSubjectModelSectionDictionary
//                .subscribe(onNext: self.tableView.rx.items(dataSource: ModelTableVeiwSectionDictionary.Shared)).disposed(by: self.disposeBag)



//            _ = self.dateSourseDictionaryForUser.behaviorSubjectDictionary.bind(to: self.tableView.rx.items(cellIdentifier: "cellListDictionary", cellType: TableViewCellListDictionary.self)){row, dictionary, cell in
//                switch row{
//                case 0:
//                    let myShadow = NSShadow()
//                    myShadow.shadowBlurRadius = 2
//                    myShadow.shadowOffset = CGSize(width: 2, height: 2)
//                    myShadow.shadowColor = UIColor.gray
//
//                    let attribute = [ NSAttributedString.Key.foregroundColor: ColorScheme.Shared.colorBLCTextTitle ,
//                                      NSAttributedString.Key.font: UIFont(name: "Futura", size: 25.0)!,
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
//
//                default:
//
//                    let attribute = [ NSAttributedString.Key.foregroundColor: ColorScheme.Shared.colorBLCText ,
//                                      NSAttributedString.Key.font: UIFont(name: "Futura", size: 20.0)!,
//
//                    ]
//
//                    var string: String = "\(dictionary.listWordObjects.count)"
//                    var attributeString = NSAttributedString(string: string, attributes: attribute)
//                    cell.labelCountItem.attributedText = attributeString
//
//                    string = dictionary.name
//                    attributeString = NSAttributedString(string: string, attributes: attribute)
//                    cell.labelNameDictionary.attributedText = attributeString
//
//                    string = (dictionary.typeDictionary == "typeDictionaryEngRus") ? "eng-rus" : "rus-eng"
//                    attributeString = NSAttributedString(string: string, attributes: attribute)
//                    cell.labelTypeDictionary.attributedText = attributeString
//
//                    cell.contentView.backgroundColor = ColorScheme.Shared.colorBLCBackgroundShared
//
//                }
//
//            }

//            self.vcListDictionary.barButtonAddDictionary.rx.tap
//                .subscribe(onNext: {
//                    _ = self.coordinatorListDictionary!.launchCoordinatorMakeNewDictionary(userName: self.userName)
//            }).disposed(by: self.disposeBag)

            self.vcDictionary.barButtonEdit.rx.tap
                .subscribe(onNext: {
                    self.tableView.setEditing(!self.tableView.isEditing, animated: true)
                    //if self.tableView.isEditing {self.tableView}
                }).disposed(by: self.disposeBag)

            self.tableView.rx.itemDeleted.asDriver().drive(onNext: { indexPath in
                if indexPath.row != 0 {
                    //self.dateSourseDictionaryForUser.deleteDictionary(numberDictionary: indexPath.row - 1)
                }
            }).disposed(by: self.disposeBag)

//            self.tableView.rx.itemSelected.asDriver()
//                .do(onNext: { indexPath in
//                    self.tableView.deselectRow(at: indexPath, animated: false)
//                })
//                .filter({ indexPath -> Bool in
//                    indexPath.row != 0
//                })
//                .do(onNext: { indexPath in
//                    self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = ColorScheme.Shared.colorBLCCellSelected
//                    self.dictionaryObject = self.dateSourseDictionaryForUser.getDictionariesForUserWithInsertFirstEmpty()[indexPath.row]
//                    switch self.tableView.isEditing{
//                    case true:  _ = self.coordinatorListDictionary?.launchCoordinatorChangeTitleDictionary(dictionaryObjectRename: self.dictionaryObject, userName: self.userName)
//                    case false: self.coordinatorListDictionary!.openDictionary(dictionaryObject: self.dictionaryObject)
//                    }
//
//                })
//                .drive(onNext: { indexPath in
//                    UIView.animate(withDuration: 0.5) {
//                        self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = ColorScheme.Shared.colorBLCBackgroundShared
//                    }
//                }).disposed(by: self.disposeBag)

            self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)


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
            //init sectionModel

        }).disposed(by: self.disposeBag)

        (self.vcDictionary as UIViewController).rx.viewDidAppear.asDriver().drive(onNext: { _ in
        }).disposed(by: self.disposeBag)
    }
}
