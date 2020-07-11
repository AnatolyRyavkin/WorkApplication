//
//  ModelTableVeiwSectionDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 11.07.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ModelTableVeiwSectionDictionary: RxTableViewSectionedAnimatedDataSource<ModelSectionDictionary> {

    static let Shared: ModelTableVeiwSectionDictionary = {

        let configurationCellWord: ModelTableVeiwSectionDictionary.ConfigureCell = { dataSources, tableView, indexPath, item in
                var cell: TableViewCellDictionaryWord? = tableView.dequeueReusableCell(withIdentifier: "TableViewCellDictionaryWord") as? TableViewCellDictionaryWord
                if cell == nil{
                    cell = TableViewCellDictionaryWord.init(style: .default, reuseIdentifier: "TableViewCellDictionaryWord")
                }
                return cell!
            }

            let configureHeaderSection: ModelTableVeiwSectionDictionary.TitleForHeaderInSection = { (dataSourse, numberSection) -> String? in

                return  ("ABCDEFGHIJKLMNOPQRSTUVWXYZ" as AnyObject as! [String])[numberSection]
            }

            let sectionForSectionIndexTitle: ModelTableVeiwSectionDictionary.SectionForSectionIndexTitle = { (dataSource, string, num) -> Int in
                print("string = \(string) num = \(num)")
                return 3
            }

            let mod = ModelTableVeiwSectionDictionary.init(configureCell: configurationCellWord,
                                            titleForHeaderInSection: configureHeaderSection,
                                            canEditRowAtIndexPath: { (dataSourse, indexPath) -> Bool in
                                                true
                                            },
                                            canMoveRowAtIndexPath: { (dataSourse, indexPath) -> Bool in true },
                                            sectionIndexTitles: { dataSourse in ["0","1","2","3"] },
                                            sectionForSectionIndexTitle: sectionForSectionIndexTitle)

            return mod
        }()

}
