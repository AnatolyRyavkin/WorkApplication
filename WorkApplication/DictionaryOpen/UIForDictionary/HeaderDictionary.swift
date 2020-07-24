//
//  HeaderDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 24.07.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation

import UIKit

class HeaderDictionary: UIView {

    let labelName = UILabel(frame: .zero)


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(labelName)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.numberOfLines = 0
        labelName.textAlignment = .center
        NSLayoutConstraint.activate([
            labelName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            labelName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)  ,
            labelName.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            labelName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])

    }

    func configure(text: String, sizeForFont: CGFloat? = nil, color: UIColor? = nil ) {
        let attribute = [ NSAttributedString.Key.foregroundColor: myColor(arColor: LabelTitle3) ,
                          NSAttributedString.Key.font: FontForTable.fontSistemLitleLit,
        ]
        let attributeStringName = NSAttributedString(string: text, attributes: attribute)
        labelName.attributedText = attributeStringName
        self.backgroundColor = myColor(arColor: LabelBackground1)
    }

}
