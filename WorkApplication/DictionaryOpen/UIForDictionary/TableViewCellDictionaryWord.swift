//
//  TableViewCellDictionaryWord.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 11.07.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class TableViewCellDictionaryWord: UITableViewCell {

    @IBOutlet weak var labelFirst: UILabel!
    @IBOutlet weak var labelSecond: UILabel!


    weak var tableView: UITableView?


//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }

//    override func layoutSubviews(){
//        super.layoutSubviews()
//
//        guard let tableView = self.tableView else {return}
//        tableView.rowHeight = 50
//    }

    func setMeaning(dataSource: ModelTableVeiwSectionDictionary, indexPath: IndexPath, tableView: UITableView) {

        self.tableView = tableView

        self.labelFirst.backgroundColor = myColor(arColor: ViewBackground1)
        self.labelSecond.backgroundColor = myColor(arColor: ViewBackground1)

        self.backgroundColor = myColor(arColor: ViewBackground1)
        self.contentView.backgroundColor = myColor(arColor: ViewBackground1)

        let arrayWordObjectRealmForSection = dataSource.sectionModels
        let arrayWordObjectRealm = arrayWordObjectRealmForSection[indexPath.section].arrayWordObjectRealm
        if indexPath.row < arrayWordObjectRealm.count {

            let wordObjectRealm = arrayWordObjectRealmForSection[indexPath.section].arrayWordObjectRealm[indexPath.row]

            let attributeForWord = [ NSAttributedString.Key.foregroundColor: myColor(arColor: LabelTitle1) ,
                              NSAttributedString.Key.font: FontForTable.Shared,
                              
                ] as [NSAttributedString.Key : Any]

            let attributeForMainMeaning = [ NSAttributedString.Key.foregroundColor: myColor(arColor: LabelTitle2) ,
                          NSAttributedString.Key.font: FontForTable.Shared,

            ] as [NSAttributedString.Key : Any]

            let stringWord = wordObjectRealm.word
            let stringMainMeaning = wordObjectRealm.mainMeaning

            let attributeStringWord = NSAttributedString(string: stringWord, attributes: attributeForWord)
            let attributeStringMainMeaning = NSAttributedString(string: stringMainMeaning, attributes: attributeForMainMeaning)

            labelFirst.lineBreakMode = .byCharWrapping
            labelSecond.lineBreakMode = .byCharWrapping

            labelFirst.attributedText = attributeStringWord
            labelSecond.attributedText = attributeStringMainMeaning

//            labelFirst.adjustsFontSizeToFitWidth = true
//            labelSecond.adjustsFontSizeToFitWidth = true

            self.labelFirst.text = wordObjectRealm.word
            self.labelSecond.text = wordObjectRealm.mainMeaning
        } else {
            self.labelFirst.text = "==="
            self.labelSecond.text = "==="
        }

    }
}



