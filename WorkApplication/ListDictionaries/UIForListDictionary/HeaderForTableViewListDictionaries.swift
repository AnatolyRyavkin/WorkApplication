//
//  HeaderForTableViewListDictionaries.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 23.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class HeaderForTableViewListDictionaries: UIView {

    let labelName = UILabel(frame: .zero)
    let labelType = UILabel(frame: .zero)
    let labelCount = UILabel(frame: .zero)

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
        addSubview(labelType)
        labelType.translatesAutoresizingMaskIntoConstraints = false
        labelType.numberOfLines = 0
        labelType.textAlignment = .center
        NSLayoutConstraint.activate([
            labelType.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            labelType.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            labelType.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            labelType.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
        addSubview(labelCount)
        labelType.translatesAutoresizingMaskIntoConstraints = false
        labelType.numberOfLines = 0
        labelType.textAlignment = .center
        NSLayoutConstraint.activate([
            labelType.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            labelType.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            labelType.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            labelType.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }

    func configure(text: String, sizeForFont: CGFloat, color: UIColor) {


        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 2
        myShadow.shadowOffset = CGSize(width: 2, height: 2)
        myShadow.shadowColor = UIColor.gray

        let attribute = [ NSAttributedString.Key.foregroundColor: ColorScheme.Shared.colorBLCTextTitle ,
                          NSAttributedString.Key.font: UIFont(name: "Futura", size: 25.0)!,
                          NSAttributedString.Key.shadow: myShadow,
        ]


        var string = "Name"
        let attributeStringName = NSAttributedString(string: string, attributes: attribute)
        labelName.attributedText = attributeStringName

        string = "Type"
        let attributeStringType = NSAttributedString(string: string, attributes: attribute)
        labelType.attributedText = attributeStringType

        string = "Count"
        let attributeStringCount = NSAttributedString(string: string, attributes: attribute)
        labelCount.attributedText = attributeStringCount

        self.backgroundColor = ColorScheme.Shared.colorBLCBackgroundTitleTable

    }

}
