//
//  DataSourseForTableWords.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 12.07.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift
import RealmSwift

class DataSourseForTableWords {

    var behaviorSubjectModelsSectionDictionary: BehaviorSubject<[ModelSectionDictionary]>!
    var dictionaryObjectRealm: DictionaryObjectRealm! = nil
    var disposeBag: DisposeBag! = DisposeBag()
    public static var lastUseTypeDictionary: TranslationDirection!
    convenience init(dictionary: DictionaryObjectRealm) {
        self.init()
        self.dictionaryObjectRealm = dictionary
        self.dictionaryObjectRealm.metods.behaviorSubjectWordsToDictionary.subscribe(onNext:{arrayArraysWordsAtAlphaBetta in

            var arrayModelsSection = Array<ModelSectionDictionary>()

            var stringNamesSectionInChars: String {
                switch self.dictionaryObjectRealm.typeDictionary {
                case TranslationDirection.EnRu.rawValue :
                    return AlphaBettaStringEng
                case TranslationDirection.RuEn.rawValue :
                    return AlphaBettaStringRus
                default:
                    return ""
                }
            }

            for (index, nameSection) in stringNamesSectionInChars.enumerated() {
                let modelSection = ModelSectionDictionary.init(nameSection: "\(nameSection)",
                    arrayWordObjectRealm: arrayArraysWordsAtAlphaBetta[index],
                    typeTranslationDirectionSection: TranslationDirection.init(typeString: self.dictionaryObjectRealm.typeDictionary)
                )
                arrayModelsSection.append(modelSection)
            }

            if self.behaviorSubjectModelsSectionDictionary == nil {
                self.behaviorSubjectModelsSectionDictionary = BehaviorSubject.init(value: arrayModelsSection)
                DataSourseForTableWords.lastUseTypeDictionary = TranslationDirection.init(typeString: self.dictionaryObjectRealm.typeDictionary)
            } else {
                self.behaviorSubjectModelsSectionDictionary.onNext(arrayModelsSection)
                DataSourseForTableWords.lastUseTypeDictionary = TranslationDirection.init(typeString: self.dictionaryObjectRealm.typeDictionary)
            }

        }).disposed(by: self.disposeBag)
        
        print("init DataSourceForTableWords - --------------------------", dictionary.name)
    }

    deinit {
        self.disposeBag = nil
        self.dictionaryObjectRealm = nil
        ModelTableVeiwSectionDictionary.Clean()
        print("deinit DataSourceForTableWords - --------------------------")
    }
}





















//            arrayNameSection.forEach {nameSection in
//
//                ModelSectionDictionary.init(nameSection: String, arrayWordObjectRealm: [WordObjectRealm], typeTranslationDirectionSection: TranslationDirection
//            }
        //    var arraySectionModel = Array<ModelSectionDictionary>()


//                for nameSectionChar in "abcdefghijklmnopqrstuvwxyz"{
//                    let arrayWordsForSection: Array<WordObjectRealm> =
//                        arrayAllWordsToDictionary!
//                            .filter { word in
//                                let def = word.def
//                                let title = def[0].text
//                                let firstCharacterWord = title?.first!
//                                let bool: Bool = (nameSectionChar == firstCharacterWord) || (nameSectionChar.uppercased() == "\(String(describing: firstCharacterWord))")
//                                return bool
//                    }
//
//                    arraySectionModel.append(ModelSectionDictionary.init(nameSection: "\(nameSectionChar)",
//                        arrayWordObjectRealm: arrayWordsForSection, typeSection: TranslationDirection.init(typeString: dictionary.typeDictionary)))
//                }




