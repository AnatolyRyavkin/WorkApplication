//
//  HeaderForTableViewMyDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 18.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class HeaderForTableViewMyDictionary: UIView {

    let label = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            ])
    }

    func configure(text: String, sizeForFont: CGFloat, color: UIColor) {
        let font = UIFont.init(name: "Futura", size: sizeForFont)//.systemFont(ofSize: sizeForFont)
        label.font = font
        label.text = text
        label.textColor = color
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
