//
//  ModelSectionDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 27.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa
import UIKit

struct ModelSectionDictionary{
    var arrayWord: Array<WordObjectRealm>
    var arrayTitleWord: Array<String> = []
    var nameSection: String = ""

    init(nameSection: String, arrayWord: [WordObjectRealm]){
        self.nameSection = nameSection
        self.arrayWord = arrayWord
        self.arrayTitleWord = self.arrayWord.map{
            $0.def[0].text ?? "!!!!!!!!"
        }
    }
}

extension ModelSectionDictionary: AnimatableSectionModelType{

    typealias Identity = String
    typealias Item = String

    init(original: ModelSectionDictionary, items: [Item]) {
        self = original
        self.arrayTitleWord = items
    }

    var identity: String {
        nameSection
    }

    var items: [Item] {
        return self.arrayTitleWord
    }

}
