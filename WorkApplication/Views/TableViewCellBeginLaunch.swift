//
//  TableViewCellBeginLaunch.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class TableViewCellBeginLaunch: UITableViewCell {

    @IBOutlet weak var labelNameDictionary: UILabel!
    @IBOutlet weak var labelTypeDictionary: UILabel!
    @IBOutlet weak var labelCountItem: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = ColorScheme.Shared.colorBLCBackgroundShared
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

    }

}
