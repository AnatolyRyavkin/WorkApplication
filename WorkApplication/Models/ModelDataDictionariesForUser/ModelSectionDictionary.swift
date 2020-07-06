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

struct ModelSectionDictionary{
    var arrayWord: Array<String> = []
    var nameSection: String = ""
}

extension ModelSectionDictionary: AnimatableSectionModelType{

    typealias Item = String
    typealias Identity = String

    var items: [String] {
        return arrayWord
    }

    init(original: ModelSectionDictionary, items: [String]) {
        self = original
        self.arrayWord = items
    }

    var identity: String {
        return nameSection
    }

}
