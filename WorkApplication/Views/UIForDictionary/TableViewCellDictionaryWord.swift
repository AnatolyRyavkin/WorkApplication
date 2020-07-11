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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
