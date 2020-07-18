//
//  MetodsForDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift
import RealmSwift

class MetodsForDictionary {

    var behaviorSubjectWordsToDictionary: BehaviorSubject<Array<Array<WordObjectRealm>>>!

    weak var dictionary: DictionaryObjectRealm!

    //var modelRealmMainBase: ModelRealmBase = ModelRealmBase.shared
    var disposeBag: DisposeBag! = DisposeBag()
    
    var realmUser: Realm {
        RealmUser.shared.realmUser
    }

    var arrayWordObjectRealm: Array<WordObjectRealm>? {
        Array<WordObjectRealm>(self.dictionary.listWordObjects)
    }

    var arrayArraysWordsAtAlphaBetta: Array<Array<WordObjectRealm>> {
        var arrayArraysWordsAtAlphaBetta = Array<Array<WordObjectRealm>>()
        var arrayWordObjectRealm: Array<WordObjectRealm>
        if let arrayW = self.arrayWordObjectRealm  {
            arrayWordObjectRealm = arrayW
        } else {
            arrayWordObjectRealm = Array<WordObjectRealm>()
        }
        var stringForNameSection: String {
            switch  self.dictionary.typeDictionary {
            case TranslationDirection.EnRu.rawValue: return AlphaBettaStringEng
            case TranslationDirection.RuEn.rawValue: return AlphaBettaStringRus
            default: return TranslationDirection.testError.rawValue
            }
        }
        
        for nameSectionChar in stringForNameSection{
            let arrayWordObjectRealmForOneSection = arrayWordObjectRealm.filter { wordObjectRealm in
                let def = wordObjectRealm.def
                let word = def[0].text
                if let firstCharacterWord = word?.first {
                    let bool: Bool = (nameSectionChar == firstCharacterWord) || (nameSectionChar.uppercased() == "\(String(describing: firstCharacterWord))")
                    return bool
                } else {
                    return false
                }
            }
            arrayArraysWordsAtAlphaBetta.append(arrayWordObjectRealmForOneSection)
        }
        
        return arrayArraysWordsAtAlphaBetta
    }

    init(dictionary: DictionaryObjectRealm){
        self.dictionary = dictionary
        self.behaviorSubjectWordsToDictionary = BehaviorSubject.init(value: self.arrayArraysWordsAtAlphaBetta)

        print("init MetodsForDictionary",self.dictionary.name)
    }

    deinit {

        print("deinit MetodsForDictionary")
        self.dictionary = nil
    }

    func clean() {
        self.behaviorSubjectWordsToDictionary = nil
        self.dictionary.metodsIn = nil
        self.dictionary = nil
        self.disposeBag = nil
    }


    func emmitingBehaviorSubjectWordsToDictionary() {
        self.behaviorSubjectWordsToDictionary.onNext(self.arrayArraysWordsAtAlphaBetta)
    }

    func deleteWordObjectRealmAtRowToTableViewRowFromDictionary(numberWordInTable: Int) {
        do{
            try self.realmUser.write {
                self.dictionary.listWordObjects.remove(at: numberWordInTable)
            }
            self.emmitingBehaviorSubjectWordsToDictionary()
        }catch{
            print("remove dictionary failed")
        }
    }

    func deleteWordObjectRealmFromDictionary(wordObjectRealm: WordObjectRealm) {
        for (index, wordObjectRealmSelf) in self.dictionary.listWordObjects.enumerated() {
            let s1 = "\(String(describing: wordObjectRealmSelf.value(forKey: "word")))" + "\(String(describing: wordObjectRealmSelf.value(forKey: "mainMeaning")))"
            let s2 = "\(String(describing: wordObjectRealm.value(forKey: "word")))" + "="  + "\(String(describing: wordObjectRealm.value(forKey: "mainMeaning")))"
            if s1 == s2 {
                self.deleteWordObjectRealmAtRowToTableViewRowFromDictionary(numberWordInTable: index)
            }
        }
    }

    func changeNameDictionary(newName: String) throws{
        do{
            try self.realmUser.write {
                dictionary.name = newName
            }
            self.emmitingBehaviorSubjectWordsToDictionary()
        }catch{
            print("remove dictionary failed")
        }

    }

    func appendWordObjectRealmToDictionaryAndRealm(wordObjectRealm: WordObjectRealm?) {
        self.appendWordObjectRealmToDictionaryAndRealmWithKeyWord(wordObjectRealm: wordObjectRealm, mainMeaning: nil)
    }

    func appendWordObjectRealmToDictionaryAndRealmWithKeyWord(wordObjectRealm: WordObjectRealm?, mainMeaning: String?) {
        guard let wordObjectRealm = wordObjectRealm else {
            print("wordObjectRealm = nil")
            return
        }
        do{
            try self.realmUser.write{
                wordObjectRealm.mainMeaning = mainMeaning ?? ""
                self.realmUser.add(wordObjectRealm)
                dictionary.listWordObjects.append(wordObjectRealm)
            }
            self.emmitingBehaviorSubjectWordsToDictionary()
        }catch let error as NSError{
            print("remove dictionary failed", error)
        }
    }

    func returnDictionaryObjectRealmIfExistToBaseSameUser(dictionaryObjectRealm: DictionaryObjectRealm) -> DictionaryObjectRealm? {
        let ownerUserName = dictionaryObjectRealm.owner.first?.userName
        let resultDictionaries = self.realmUser.objects(DictionaryObjectRealm.self)
        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", ownerUserName!)
        return  Array<DictionaryObjectRealm>(resultDictionaries.filter(predicate)).first
    }

    func createNewWordObjectRealmFromRequest( requestingString: String, type: TranslationDirection, observerSuccess:  ((WordObjectRealm) -> Void)? ) throws {
        RequestsAPIYandexDictionary.Shared.getObservableWord(requestWord: requestingString, translationDirection: type,
                        handlerError: { error in
                                        let myError = error as! ErrorForGetRequestAPIYandex
                                        print(myError.discript.nameError)
                                        throw myError
        })
        .subscribe(onNext: observerSuccess)
        .disposed(by: self.disposeBag)
    }

}
