//
//  TableViewCellListDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class TableViewCellListDictionary: UITableViewCell {

    @IBOutlet weak var labelNameDictionary: UILabel!
    @IBOutlet weak var labelTypeDictionary: UILabel!
    @IBOutlet weak var labelCountItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

    }

}
