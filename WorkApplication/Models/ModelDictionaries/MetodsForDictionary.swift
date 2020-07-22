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

    func returnDictionaryObjectRealmIfExistToBaseSameUser(dictionaryObjectRealm: DictionaryObjectRealm) -> DictionaryObjectRealm? {
       let ownerUserName = dictionaryObjectRealm.owner.first?.userName
       let resultDictionaries = self.realmUser.objects(DictionaryObjectRealm.self)
       let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", ownerUserName!)
       return  Array<DictionaryObjectRealm>(resultDictionaries.filter(predicate)).first
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

    func appendWordObjectRealmToDictionary(wordObjectRealm: WordObjectRealm?) {
        guard let wordObjectRealm = wordObjectRealm else {
            print("wordObjectRealm = nil")
            return
        }
        do{
            try self.realmUser.write{
                dictionary.listWordObjects.append(wordObjectRealm)
            }
            self.emmitingBehaviorSubjectWordsToDictionary()
        }catch let error as NSError{
            print("remove dictionary failed", error)
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
        let newWordObjectRealm = WordObjectRealm.init(wordObjectRealm: wordObjectRealm, mainMeaning: mainMeaning!)
        do{
            try self.realmUser.write{
                dictionary.listWordObjects.append(newWordObjectRealm)
            }
            self.emmitingBehaviorSubjectWordsToDictionary()
        }catch let error as NSError{
            print("remove dictionary failed", error)
        }



//        do{
//            try self.realmUser.write{
//                WordObjectRealm.init
//                wordObjectRealm.mainMeaning = mainMeaning ?? ""
//                self.realmUser.add(wordObjectRealm)
//                dictionary.listWordObjects.append(wordObjectRealm)
//            }
//            self.emmitingBehaviorSubjectWordsToDictionary()
//        }catch let error as NSError{
//            print("remove dictionary failed", error)
//        }
    }



    func returnWordObjectRealmIfExistSameToRealmSameMainMeaning(wordAddMainMeaning: String) -> WordObjectRealm? {

        let resultWordObjectAll = Array<WordObjectRealm>(self.realmUser.objects(WordObjectRealm.self))
        let arrayWordObjectRealmOne = resultWordObjectAll.filter{ wordObjectRealm in
            return wordObjectRealm.wordAddMainMeaning == wordAddMainMeaning
        }
        return (arrayWordObjectRealmOne.count > 0) ? arrayWordObjectRealmOne[0] : nil
    }


    func returnWordObjectRealmIfExistSameToListSelfDictionarySameMainMeaning(wordAddMainMeaning: String) -> WordObjectRealm? {

        let arrayWordObjectRealmAll = Array<WordObjectRealm>(self.dictionary.listWordObjects)

        let arrayWordObjectRealm = arrayWordObjectRealmAll.filter{ wordObjectRealmToListDictionary in
            wordObjectRealmToListDictionary.wordAddMainMeaning == wordAddMainMeaning }

        return (arrayWordObjectRealm.count > 0) ? arrayWordObjectRealm[0] : nil
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

//    func createNewWordObjectRealmFromRequestOrFromRealm( requestingString: String, type: TranslationDirection, observerSuccess:  ((WordObjectRealm) -> Void)? ) throws {
//
//        let result = self.realmUser.objects(WordObjectRealm.self).filter("word == %@", requestingString.lowercased())
//        if result.count > 0 {
//            let wordObjectRealm = result[0]
//            Observable<WordObjectRealm>.of(wordObjectRealm)
//                .subscribe(onNext: observerSuccess)
//                .disposed(by: self.disposeBag)
//        } else {
//            guard let observerSuccess = observerSuccess else {return}
//
//            RequestsAPIYandexDictionary.Shared.getObservableWord(requestWord: requestingString, translationDirection: type,
//                                                                 handlerError: { error in
//                                                                    let myError = error as! ErrorForGetRequestAPIYandex
//                                                                    print(myError.discript.nameError)
//                                                                    throw myError
//            })
//                .do(onNext: observerSuccess,
//                    onError: { error in
//                        let myError = error as! ErrorForGetRequestAPIYandex
//                        print(myError.discript.nameError)
//                        throw myError
//                })
//                .subscribe()
//                .disposed(by: self.disposeBag)
//        }
//
//    }

    func createNewWordObjectRealmFromRequestOrFromRealm( requestingString: String, type: TranslationDirection, observerSuccess:  ((WordObjectRealm) -> Void)?, observerError: ((Error) -> Void)?  ) throws {

        let result = self.realmUser.objects(WordObjectRealm.self).filter("word == %@", requestingString.lowercased())
        if result.count > 0 {
            let wordObjectRealm = result[0]
            Observable<WordObjectRealm>.of(wordObjectRealm)
                .subscribe(onNext: observerSuccess)
                .disposed(by: self.disposeBag)
        } else {
            RequestsAPIYandexDictionary.Shared.getObservableWord(requestWord: requestingString, translationDirection: type,
                                                                 handlerError: { error in throw error})
            .subscribe(onNext: observerSuccess, onError: observerError)
            .disposed(by: self.disposeBag)
        }

    }



}
