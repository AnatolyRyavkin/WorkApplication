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

    private static var SharedInvoke: ModelTableVeiwSectionDictionary!

    static var Shared: ModelTableVeiwSectionDictionary! {

        if ModelTableVeiwSectionDictionary.SharedInvoke == nil {

            ModelTableVeiwSectionDictionary.SharedInvoke = {

                let configurationCellWordMy: ModelTableVeiwSectionDictionary.ConfigureCell = { dataSources, tableView, indexPath, item in

                    var cell: TableViewCellDictionaryWord? = tableView.dequeueReusableCell(withIdentifier: "TableViewCellDictionaryWord") as? TableViewCellDictionaryWord
                    if cell == nil{
                        cell = TableViewCellDictionaryWord.init(style: .default, reuseIdentifier: "TableViewCellDictionaryWord")
                    }

                    cell!.setMeaning(dataSource: dataSources as! ModelTableVeiwSectionDictionary, indexPath: indexPath, tableView: tableView)

                    return cell!
                }

                let configureHeaderSectionMy: (TableViewSectionedDataSource<ModelSectionDictionary>, Int) -> String? = { (dataSource, numberSection) -> String? in

                    var alphaBettaArrayUpper = [""]
                    switch DataSourseForTableWords.lastUseTypeDictionary! {
                    case TranslationDirection.EnRu: alphaBettaArrayUpper = AlphaBettaArrayEngUpper
                    case TranslationDirection.RuEn: alphaBettaArrayUpper = AlphaBettaArrayRusUpper
                    default: alphaBettaArrayUpper = AlphaBettaArrayEngUpper
                    }
                    return "\(alphaBettaArrayUpper[numberSection])"

                }

                let sectionIndexTitlesMy: (TableViewSectionedDataSource<ModelSectionDictionary>) -> [String]? = { dataSource in

                    var alphaBettaArrayUpper = [""]
                    switch DataSourseForTableWords.lastUseTypeDictionary! {
                    case TranslationDirection.EnRu: alphaBettaArrayUpper = AlphaBettaArrayEngUpper
                    case TranslationDirection.RuEn: alphaBettaArrayUpper = AlphaBettaArrayRusUpper
                    default: alphaBettaArrayUpper = AlphaBettaArrayEngUpper
                    }
                    return alphaBettaArrayUpper

                }

                let sectionForSectionIndexTitleMy: ModelTableVeiwSectionDictionary.SectionForSectionIndexTitle = { (dataSource, string, num) -> Int in
                    var alphaBettaArrayUpper = [""]
                    switch DataSourseForTableWords.lastUseTypeDictionary! {
                    case TranslationDirection.EnRu: alphaBettaArrayUpper = AlphaBettaArrayEngUpper
                    case TranslationDirection.RuEn: alphaBettaArrayUpper = AlphaBettaArrayRusUpper
                    default: alphaBettaArrayUpper = AlphaBettaArrayEngUpper
                    }
                    print(string,num)
                    return alphaBettaArrayUpper.count
                }

                return ModelTableVeiwSectionDictionary.init( configureCell: configurationCellWordMy,
                                                             titleForHeaderInSection: configureHeaderSectionMy,
                                                             sectionIndexTitles: sectionIndexTitlesMy,
                                                             sectionForSectionIndexTitle: sectionForSectionIndexTitleMy )

            }()
        }

        return ModelTableVeiwSectionDictionary.SharedInvoke

    }

    static func Clean() {
        ModelTableVeiwSectionDictionary.SharedInvoke = nil
    }

}

