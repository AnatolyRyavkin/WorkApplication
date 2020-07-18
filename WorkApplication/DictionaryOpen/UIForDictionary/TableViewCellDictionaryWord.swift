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

//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }

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
        let arrayWordObjectRealmForSection = dataSource.sectionModels
        let arrayWordObjectRealm = arrayWordObjectRealmForSection[indexPath.section].arrayWordObjectRealm
        if indexPath.row < arrayWordObjectRealm.count {
            let wordObjectRealm = arrayWordObjectRealmForSection[indexPath.section].arrayWordObjectRealm[indexPath.row]
            self.labelFirst.text = wordObjectRealm.word
            self.labelSecond.text = wordObjectRealm.mainMeaning
        } else {
            self.labelFirst.text = "==="
            self.labelSecond.text = "==="
        }

    }
}



