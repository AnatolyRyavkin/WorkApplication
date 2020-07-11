//
//  MetodsForWords.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 10.07.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift
import RealmSwift

class MetodsForWords {

    static let Shared = MetodsForWords()
    let disposeBag = DisposeBag()
    var realmUser: Realm = RealmUser.shared.realmUser

    func deleteWord() {}


    //    func appendDictionary(title: String, type: DictionaryObjectRealm.EnumDictionaryType) throws {

    //        RequestsAPIYandexDictionary.Shared.getObservableWord(requestWord: "to  ewf ervf", translationDirection: .RuEn,
    //            handlerError: { error in
    //                            print((error as! ErrorForGetRequestAPIYandex).discript.nameError)
    //                            return Observable<WordObjectRealm>.error(error)
    //        })
    //            .subscribe( onNext: {wordObjectRealm in
    //                let newDictionary = DictionaryObjectRealm.init(name: title, typeDictionary: type.rawValue)
    //                self.appendWordObject(wordObject: wordObjectRealm, dictionaryObject: newDictionary)
    //                self.userObject.listDictionary.append(newDictionary)
    //                self.behaviorSubjectDictionary.onNext(self.getDictionariesForUserWithInsertFirstEmpty())
    //            }).disposed(by: self.disposeBag)


    //        do {
    //            try RequestsAPIYandexDictionary.Shared.getWord(requestWord: "i", translationDirection: .EnRu, handlerError: {error in
    //                print((error as! ErrorForGetRequestAPIYandex).discript.nameError)
    //                return Observable<WordObjectRealm>.error(error)
    //            }){wordObjectRealm in
    //                let newDictionary = DictionaryObjectRealm.init(name: title, typeDictionary: type.rawValue)
    //                self.appendWordObject(wordObject: wordObjectRealm, dictionaryObject: newDictionary)
    //                self.userObject.listDictionary.append(newDictionary)
    //                self.behaviorSubjectDictionary.onNext(self.getDictionariesForUserWithInsertFirstEmpty())
    //            }.disposed(by: self.disposeBag)
    //        } catch let error {
    //            print((error as! ErrorForGetRequestAPIYandex).discript.nameError)
    //        }

    //    }


//    func getWordsForDictionaryWithInsertFirstEmpty()-> Array<WordObjectRealm>{
//        let resultDictionaries = self.modelRealmUser.realmUser.objects(DictionaryObjectRealm.self)
//        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", userName)
//        var result: Array<DictionaryObjectRealm> = Array<DictionaryObjectRealm>(resultDictionaries.filter(predicate))
//        result.insert(DictionaryObjectRealm.init(name: "-", typeDictionary: "-"), at: 0) // filling first line
//        print(result.count)
//        return result
//    }

//    func getWordForUser()-> Array<DictionaryObjectRealm>{
//        let resultDictionaries = self.modelRealmUser.realmUser.objects(DictionaryObjectRealm.self)
//        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", userName)
//        let result: Array<DictionaryObjectRealm> = Array<DictionaryObjectRealm>(resultDictionaries.filter(predicate))
//        return result
//    }

    func getLastDictionaryForUser() -> WordObjectRealm? {
        return (self.realmUser.objects(WordObjectRealm.self)).last
    }

    func appendWordObject(wordObject: WordObjectRealm?, dictionaryObject: DictionaryObjectRealm) {
        guard let wordObject = wordObject else { return}
        do{
            try self.realmUser.write {
                dictionaryObject.listWordObjects.append(wordObject)
            }
        }catch{
            print("append Word in dictionary failed")
        }
    }
}
