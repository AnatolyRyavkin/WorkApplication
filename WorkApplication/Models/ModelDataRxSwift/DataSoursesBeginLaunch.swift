//
//  DataSoursesBeginLaunch.swift
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

class DataSourceBeginLaunch {

    static var dataSourceBeginLaunchForUser: DataSourceBeginLaunch?

    var modelRealmMainBase: ModelRealmBase = ModelRealmBase.shared
    var modelRealmUser: ModelRealmUser = ModelRealmUser.shared
    var realmUser: Realm!

    var behaviorSubject: BehaviorSubject<[DictionaryObject]>!
    var userName: String!
    var userObject: UserObject!

    init(){}

    convenience init(userName: String){
        self.init()
        self.userName = userName
        self.realmUser = self.modelRealmUser.realmUser
        let resultUsers  = self.realmUser.objects(UserObject.self).filter("userName = %@",self.userName!)
        if resultUsers.count == 0{
            self.userObject = UserObject.init(userName: self.userName, dictionaryObject: nil)
            try! self.realmUser.write { () -> Void in
                realmUser.add(self.userObject)
            }
        }else{
            self.userObject = resultUsers.first!
        }

        self.behaviorSubject = BehaviorSubject.init(value: self.getDictionariesForUserWithInsertFirstEmpty())
        DataSourceBeginLaunch.dataSourceBeginLaunchForUser = self
        print("init DataSourceBeginLaunch",self)
    }

    deinit {
        print("deinit DataSourceBeginLaunch",self)
    }
    
    func appendDictionary(title: String, type: DictionaryObject.EnumDictionaryType) throws {
        let newDictionary = DictionaryObject.init(name: title, typeDictionary: type.rawValue)
        try self.realmUser.write {
            self.userObject.listDictionary.append(newDictionary)
        }
        self.behaviorSubject.onNext(self.getDictionariesForUserWithInsertFirstEmpty())
    }

    func deleteDictionary(numberDictionary: Int) {
        do{
            try self.realmUser.write {
                self.userObject.listDictionary.remove(at: numberDictionary)
                self.behaviorSubject.onNext(self.getDictionariesForUserWithInsertFirstEmpty())
            }
        }catch{
            print("remove dictionary failed")
        }
    }

    func changeNameDictionary(dictionaryObject: DictionaryObject, newName: String) throws{
        do{
            try self.realmUser.write {
                dictionaryObject.name = newName
                self.behaviorSubject.onNext(self.getDictionariesForUserWithInsertFirstEmpty())
            }
        }catch{
            print("remove dictionary failed")
        }

    }

    func getDictionariesForUserWithInsertFirstEmpty()-> Array<DictionaryObject>{
        let resultDictionaries = self.modelRealmUser.realmUser.objects(DictionaryObject.self)
        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", userName)
        var result: Array<DictionaryObject> = Array<DictionaryObject>(resultDictionaries.filter(predicate))
        result.insert(DictionaryObject.init(name: "-", typeDictionary: "-"), at: 0) // filling first line
        return result
    }

    func getDictionariesForUser()-> Array<DictionaryObject>{
        let resultDictionaries = self.modelRealmUser.realmUser.objects(DictionaryObject.self)
        let predicate = NSPredicate(format:"SUBQUERY(owner, $o, $o.userName = %@) .@count > 0", userName)
        let result: Array<DictionaryObject> = Array<DictionaryObject>(resultDictionaries.filter(predicate))
        return result
    }

}




