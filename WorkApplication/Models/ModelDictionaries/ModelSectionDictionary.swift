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

    var arrayWordObjectRealm: Array<WordObjectRealm>
    var nameSection: String = ""
    var typeTranslationDirectionSection: TranslationDirection = TranslationDirection.EnRu
    var arrayTitleWord: Array<String> = [String]()

    static var TranslationDirectionLast: TranslationDirection!

    init(nameSection: String, arrayWordObjectRealm: [WordObjectRealm], typeTranslationDirectionSection: TranslationDirection){
        self.nameSection = nameSection
        self.arrayWordObjectRealm = arrayWordObjectRealm
        self.typeTranslationDirectionSection = typeTranslationDirectionSection
        self.arrayTitleWord = arrayWordObjectRealm.map({ wordObjectRealm in
            return wordObjectRealm.def[0].text!
        })
    }


}

extension ModelSectionDictionary: AnimatableSectionModelType{

    typealias Identity = String
    typealias Item = String

    init(original: ModelSectionDictionary, items: [Item] = [""]) {
        self = original
        self.arrayTitleWord = items
    }

    init(original: ModelSectionDictionary, nameSection: String, arrayWordObjectRealm: [WordObjectRealm], typeTranslationDirectionSection: TranslationDirection) {
        self.init(original: original)
        self.nameSection = nameSection
        self.arrayWordObjectRealm = arrayWordObjectRealm
        self.typeTranslationDirectionSection = typeTranslationDirectionSection
    }

    var identity: String {
        nameSection
    }

    var items: [Item] {
        return self.arrayTitleWord
    }

}























//import Foundation
//import RxSwift
//import RxDataSources
//import RxCocoa
//import UIKit
//
//struct ModelSectionDictionary{
//
//    var arrayWordObjectRealm: Array<WordObjectRealm>
//    var nameSection: String = ""
//    var typeTranslationDirectionSection: TranslationDirection = TranslationDirection.EnRu
//    var arrayTitleWord: Array<String> = [String]()
//
//    static var TranslationDirectionLast: TranslationDirection!
//
//    init(nameSection: String, arrayWordObjectRealm: [WordObjectRealm], typeTranslationDirectionSection: TranslationDirection){
//        self.nameSection = nameSection
//        self.arrayWordObjectRealm = arrayWordObjectRealm
//        self.typeTranslationDirectionSection = typeTranslationDirectionSection
//        self.arrayTitleWord = arrayWordObjectRealm.map({ wordObjectRealm in
//            return wordObjectRealm.def[0].text!
//        })
//    }
//
//
//}
//
//extension ModelSectionDictionary: AnimatableSectionModelType{
//
//    typealias Identity = String
//    typealias Item = String
//
//    init(original: ModelSectionDictionary, items: [Item] = [""]) {
//        self = original
//        self.arrayTitleWord = items
//    }
//
//    init(original: ModelSectionDictionary, nameSection: String, arrayWordObjectRealm: [WordObjectRealm], typeTranslationDirectionSection: TranslationDirection) {
//        self.init(original: original)
//        self.nameSection = nameSection
//        self.arrayWordObjectRealm = arrayWordObjectRealm
//        self.typeTranslationDirectionSection = typeTranslationDirectionSection
//    }
//
//    var identity: String {
//        nameSection
//    }
//
//    var items: [Item] {
//        return self.arrayTitleWord
//    }
//
//}




