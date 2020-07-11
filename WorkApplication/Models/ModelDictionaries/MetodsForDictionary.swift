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

    static var objectMetodsDictionaryForSpecificUser: MetodsForDictionary?

    let disposeBag = DisposeBag()

    var modelRealmMainBase: ModelRealmBase = ModelRealmBase.shared

    var realmUser: Realm {
        RealmUser.shared.realmUser
    }

    var behaviorSubjectDictionary: BehaviorSubject<[DictionaryObjectRealm]>!

    var userName: String!

    var userObject: UserObjectRealm!

    //var disposedAppendDictionary: Disposable!

    //var behaviorSubjectModelSectionDictionary: BehaviorSubject<ModelSectionDictionary>

    init(){}

    convenience init(userName: String){
        self.init()
        self.userName = userName
        let resultUsers  = self.realmUser.objects(UserObjectRealm.self).filter("userName = %@",self.userName!)
        if resultUsers.count == 0{
            self.userObject = UserObjectRealm.init(userName: self.userName, dictionaryObject: nil)
            try! self.realmUser.write { () -> Void in
                realmUser.add(self.userObject)
            }
        }else{
            self.userObject = resultUsers.first!
        }

        self.behaviorSubjectDictionary = BehaviorSubject.init(value: self.getDictionariesForUserWithInsertFirstEmpty())
        MetodsForDictionary.objectMetodsDictionaryForSpecificUser = self
        //self.behaviorSubjectModelSectionDictionary = self.getArrayModelSectionDictionary()
        print("init MetodsForDictionary",self)
    }

    deinit {
        print("deinit MetodsForDictionary",self)
    }


    //MARK- TEST

    func appendDictionary(title: String, type: DictionaryObjectRealm.EnumDictionaryType) throws {

        RequestsAPIYandexDictionary.Shared.getObservableWord(requestWord: "to", translationDirection: .EnRu,
                                                             handlerError: { error in
                                                                print((error as! ErrorForGetRequestAPIYandex).discript.nameError)
                                                                return Observable<WordObjectRealm>.error(error)
        })
            .subscribe( onNext: {wordObjectRealm in
                let newDictionary = DictionaryObjectRealm.init(name: title, typeDictionary: type.rawValue)
                self.appendWordObject(wordObject: wordObjectRealm, dictionaryObject: newDictionary)
                self.userObject.listDictionary.append(newDictionary)
                self.behaviorSubjectDictionary.onNext(self.getDictionariesForUserWithInsertFirstEmpty())
            }).disposed(by: self.disposeBag)


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

    }
    
//    func appendDictionary(title: String, type: DictionaryObjectRealm.EnumDictionaryType) throws {
//        try self.realmUser.write{
//            let newDictionary = DictionaryObjectRealm.init(name: title, typeDictionary: type.rawValue)
//            self.userObject.listDictionary.append(newDictionary)
//            self.behaviorSubjectDictionary.onNext(self.getDictionariesForUserWithInsertFirstEmpty())
//        }
//
//    }

    func deleteDictionary(numberDictionary: Int) {
        do{
            try self.realmUser.write {
                self.userObject.listDictionary.remove(at: numberDictionary)
                self.behaviorSubjectDictionary.onNext(self.getDictionariesForUserWithInsertFirstEmpty())
            }
        }catch{
            print("remove dictionary failed")
        }
    }

    func changeNameDictionary(dictionaryObject: DictionaryObjectRealm, newName: String) throws{
        do{
            try self.realmUser.write {
                dictionaryObject.name = newName
                self.behaviorSubjectDictionary.onNext(self.getDictionariesForUserWithInsertFirstEmpty())
            }
        }catch{
            print("remove dictionary failed")
        }

    }

    func getDictionariesForUserWithInsertFirstEmpty()-> Array<DictionaryObjectRealm>{
        let resultDictionaries = self.realmUser.objects(DictionaryObjectRealm.self)
        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", userName)
        var result: Array<DictionaryObjectRealm> = Array<DictionaryObjectRealm>(resultDictionaries.filter(predicate))
        result.insert(DictionaryObjectRealm.init(name: "-", typeDictionary: "-"), at: 0) // filling first line
        print(result.count)
        return result
    }

    func getDictionariesForUser()-> Array<DictionaryObjectRealm>{
        let resultDictionaries = self.realmUser.objects(DictionaryObjectRealm.self)
        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", userName)
        let result: Array<DictionaryObjectRealm> = Array<DictionaryObjectRealm>(resultDictionaries.filter(predicate))
        return result
    }

    func getLastDictionaryForUser() -> DictionaryObjectRealm? {
        return (self.realmUser.objects(DictionaryObjectRealm.self)).last
    }

    func appendWordObject(wordObject: WordObjectRealm?, dictionaryObject: DictionaryObjectRealm) {
        guard let wordObject = wordObject else { return}
        dictionaryObject.listWordObjects.append(wordObject)
    }

}



























//        RequestsAPIYandexDictionary.Shared.requestGetTranslateStandardInEventWord(requestWord: "String", translationDirection: TranslationDirection.testError){event in
//            switch event{
//            case .next(let myResponse):
//                switch myResponse{
//                case .success(let wordObjectRealm):
//                    word = wordObjectRealm
//                case .failure(let error):
//                    switch error.discript.num {
//                    case 200:
//                        print(error.discript.nameError)
//                    case 401:
//                        print(error.discript.nameError)
//                    case 402:
//                        print(error.discript.nameError)
//                    case 403:
//                        print(error.discript.nameError)
//                    case 501:
//                        print(error.discript.nameError)
//                    case 001:
//                        print(error.discript.nameError)
//                    case 002:
//                        print(error.discript.nameError)
//                    case 003:
//                        print(error.discript.nameError)
//                    case 400:
//                        print(error.discript.nameError)
//                    case 404:
//                        print(error.discript.nameError)
//                    case 700:
//                        print(error.discript.nameError)
//                    default:
//                        print(ErrorForGetRequestAPIYandex.ERR_UNKNOWN.discript.nameError)
//                    }
//                }
//            case .error(_):
//                print(ErrorForGetRequestAPIYandex.ERR_UNKNOWN.discript.nameError)
//            case .completed:
//                return
//            }
//            try? self.realmUser.write {
//                let newDictionary = DictionaryObjectRealm.init(name: title, typeDictionary: type.rawValue)
//                self.appendWordObject(wordObject: word, dictionaryObject: newDictionary)
//                self.userObject.listDictionary.append(newDictionary)
//                self.behaviorSubjectDictionary.onNext(self.getDictionariesForUserWithInsertFirstEmpty())
//            }
//        }
//    }

