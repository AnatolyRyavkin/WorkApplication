//
//  MetodsForUser.swift
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

class MetodsForUser {


    //var modelRealmMainBase: ModelRealmBase = ModelRealmBase.shared

    let disposeBag = DisposeBag()


    var realmUser: Realm {
        RealmUser.shared.realmUser
    }
    var userObjectRealm: UserObjectRealm
    var userName: String  {
        return self.userObjectRealm.userName
    }

    var dictionaries: Array<DictionaryObjectRealm> {
        let resultDictionaries = self.realmUser.objects(DictionaryObjectRealm.self)
        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", userName)
        let result: Array<DictionaryObjectRealm> = Array<DictionaryObjectRealm>(resultDictionaries.filter(predicate))
        #if DEBUG
        if result.count != self.userObjectRealm.listDictionary.count {
            fatalError("if result.count != self.userObjectRealm.listDictionary.count ")
        }
        #endif
        return result 
    }

    var behaviorSubjectDictionaryToUser: BehaviorSubject <Array<DictionaryObjectRealm>>!
    
    init(userObjectRealm: UserObjectRealm) {
        self.userObjectRealm = userObjectRealm
        self.behaviorSubjectDictionaryToUser = BehaviorSubject.init(value: self.dictionaries )
        print("++++++++++++++++++++init MetodsForUser",self.userName)
    }

    deinit {
        print("--------------------deinit MetodsForUser",self.userName)
    }

    func emmitingBehaviorSubjectDictionaryToUser() {
        self.behaviorSubjectDictionaryToUser.onNext(self.dictionaries)
    }


    //MARK- TEST

    func appendDictionaryTest
        (title: String, type: TranslationDirection) throws -> DictionaryObjectRealm? {

        let newDictionary = DictionaryObjectRealm.init()
        newDictionary.name = title
        newDictionary.typeDictionary = type.rawValue
        guard !self.alreadyExistToBaseSameDictionaryObjectRealmForThisUser(dictionaryObjectRealm: newDictionary)
            else {
                throw ErrorForGetRequestAPIYandex.AlREADY_EXIST_TO_BASE_SAME_DICTIONARY_FOR_THIS_USER
        }
        do {
            try self.userObjectRealm.metods.appendDictionaryToListDictionaryThisUserAndRealm(dictionaryObjectRealm: newDictionary)
            try newDictionary.metods.createNewWordObjectRealmFromRequest(requestingString: "error", type: .EnRu){ wordObjectRealm in
                newDictionary.metods.appendWordObjectRealmToDictionaryAndRealm(wordObjectRealm: wordObjectRealm)
            }
        } catch let error {
            throw error as! ErrorForGetRequestAPIYandex
        }
        return newDictionary
    }

    //MARK- endTest



    func alreadyExistToBaseSameDictionaryObjectRealmForThisUser(dictionaryObjectRealm: DictionaryObjectRealm) -> Bool {
        let resultDictionaries = self.realmUser.objects(DictionaryObjectRealm.self)
        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", self.userName)
        let resDictionary = resultDictionaries.filter(predicate)
        for dictionary in resDictionary {
            if dictionary.name == dictionaryObjectRealm.name && dictionary.typeDictionary == dictionaryObjectRealm.typeDictionary {
                return true
            }
        }
        return false
    }

    func returnDictionaryIfAlreadyExistToBaseSameForThisUser(dictionaryObjectRealm: DictionaryObjectRealm) -> DictionaryObjectRealm? {
        let resultDictionaries = self.realmUser.objects(DictionaryObjectRealm.self)
        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", self.userName)
        let resDictionary = resultDictionaries.filter(predicate)
        for dictionary in resDictionary {
            if dictionary.name == dictionaryObjectRealm.name && dictionary.typeDictionary == dictionaryObjectRealm.typeDictionary {
                return dictionary
            }
        }
        return nil
    }

    func returnDictionaryIfAlreadyExistToBaseDictionaryWithSameParamsThisUser(title: String, type: TranslationDirection) -> DictionaryObjectRealm? {
        let resultDictionaries = self.realmUser.objects(DictionaryObjectRealm.self)
        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", self.userName)
        let resDictionary = resultDictionaries.filter(predicate)
        for dictionary in resDictionary {
            if dictionary.name == title && dictionary.typeDictionary == type.rawValue {
                return dictionary
            }
        }
        return nil
    }


    func returnNumberInListDictionaryIfExistForThisUser(dictionaryObjectRealm: DictionaryObjectRealm) -> Int? {
        let resultDictionaries = self.realmUser.objects(DictionaryObjectRealm.self)
        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", self.userName)
        let resDictionary = resultDictionaries.filter(predicate)
        for (index,dictionary) in resDictionary.enumerated(){
            if dictionary.name == dictionaryObjectRealm.name && dictionary.typeDictionary == dictionaryObjectRealm.typeDictionary {
                return index
            }
        }
        return nil
    }


    func appendDictionaryToListDictionaryThisUserAndRealm(dictionaryObjectRealm: DictionaryObjectRealm) throws {
        do {
            try self.realmUser.write{
                self.userObjectRealm.listDictionary.append(dictionaryObjectRealm)
            }
            emmitingBehaviorSubjectDictionaryToUser()
        } catch let error  {
            let myError = error.myError()
            print("appendDictionary", myError)
            throw myError
        }
    }


    func creatingDictionaryAndAddToListDictionaryThisUser
        (title: String, type: TranslationDirection) throws -> DictionaryObjectRealm? {

        let newDictionary = DictionaryObjectRealm.init()
        newDictionary.name = title
        newDictionary.typeDictionary = type.rawValue
        guard !self.alreadyExistToBaseSameDictionaryObjectRealmForThisUser(dictionaryObjectRealm: newDictionary)
            else {
                throw ErrorForGetRequestAPIYandex.AlREADY_EXIST_TO_BASE_SAME_DICTIONARY_FOR_THIS_USER
        }
        do {
            try self.userObjectRealm.metods.appendDictionaryToListDictionaryThisUserAndRealm(dictionaryObjectRealm: newDictionary)
            return newDictionary
        } catch let error {
            throw error.myError()
        }
    }

    func deleteDictionaryOnEverySideAtNumberInListDictionaryThisDictionary(numberDictionary: Int) {
        do{
            try self.realmUser.write {
                if numberDictionary < self.userObjectRealm.listDictionary.count {
                    let dictionary = self.userObjectRealm.listDictionary[numberDictionary]
                    self.realmUser.delete(dictionary)
                }
            }
            self.emmitingBehaviorSubjectDictionaryToUser()
        }catch{
            print("remove dictionary failed")
        }
    }

    func deleteDictionaryOnEverySide(deletingDictionary: DictionaryObjectRealm) {
        guard let num = self.returnNumberInListDictionaryIfExistForThisUser(dictionaryObjectRealm: deletingDictionary)
            else {
                return
        }
        self.deleteDictionaryOnEverySideAtNumberInListDictionaryThisDictionary(numberDictionary: num)
    }

    func renameDictionary(dictionaryObjectRealm: DictionaryObjectRealm, newName: String ) throws{
        do{
            try self.realmUser.write {
                dictionaryObjectRealm.name = newName
            }
            self.emmitingBehaviorSubjectDictionaryToUser()
        }catch{
            print("remove dictionary failed")
        }

    }


}



















//    func creatingDictionaryAndAddToListDictionaryThisUser(title: String, type: TranslationDirection) throws {
//        let newDictionary = DictionaryObjectRealm.init()
//        newDictionary.name = title
//        newDictionary.typeDictionary = type.rawValue
//        do {
//            try self.appendDictionaryToListDictionaryThisUserAndRealm(dictionaryObjectRealm: newDictionary)
//
//        } catch let error {
//            throw error.myError()
//        }
//    }








//    func alreadyExistToBaseSameDictionaryObjectRealmForThisUser(dictionaryObjectRealm: DictionaryObjectRealm) -> Bool {
//        let resultDictionaries = self.realmUser.objects(DictionaryObjectRealm.self)
//        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", self.userName)
//        return  Array<DictionaryObjectRealm>(resultDictionaries.filter(predicate)).first != nil
//    }



//        RequestsAPIYandexDictionary.Shared.getObservableWord(requestWord: "push", translationDirection: .EnRu,
//                                                             handlerError: { error in
//                                                                print((error as! ErrorForGetRequestAPIYandex).discript.nameError)
//                                                                return Observable<WordObjectRealm>.error(error)
//        })
//            .subscribe( onNext: {wordObjectRealm in
//                let newDictionary = DictionaryObjectRealm.init()
//                newDictionary.name = title
//                newDictionary.typeDictionary = type.rawValue
//                guard self.alreadyExistToBaseSameDictionaryObjectRealmForThisUser(dictionaryObjectRealm: newDictionary) == nil
//                    else {
//                        print(
//                        return
//
//                }
//
//                }
//                newDictionary.metods.appendWordObjectRealmToDictionaryAndRealm(wordObject: wordObjectRealm)
//                newDictionary.listWordObjects.append(wordObjectRealm)
//                self.userObjectRealm.metods.appendDictionary(dictionaryObjectRealm: newDictionary)
//                self.emmitingBehaviorSubjectDictionaryToUser()
//            }).disposed(by: self.disposeBag)


