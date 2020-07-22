//
//  RealmUser.swift
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

class RealmUser{
    
    var realmUser: Realm!

    static let shared = RealmUser()
    static var RealmMy: Realm {
        RealmUser.shared.realmUser
    }

    private init() {
        #if DEBUG
        // if the project was downloaded from github you need to change it to yor own ( or make let config = Realm.Configuration.defaultConfiguration )
        let url = URL.init(fileURLWithPath: "Users/ryavkinto/Documents/MyDictionaries/WorkApplication/WorkApplication/UsersBase.realm")
        #else
        let url = Bundle.main.bundleURL.appendingPathComponent("UserBase.realm")
        #endif
        let config = Realm.Configuration.init(fileURL: url, readOnly: false)
        //let config = Realm.Configuration.defaultConfiguration

        do{
            self.realmUser = try Realm(configuration: config)
//MARK- Clean all base
//            try! realmUser.write {
//                realmUser.deleteAll()
//            }
        } catch let error as NSError {
            print(error.localizedDescription)
            print("error = ", error)
            return
        }
        print("init RealmUser",self)
    }

    deinit {
        print("deinit RealmUser",self)
    }

    func addUserObjectRealm(userObjectRealm: UserObjectRealm) {
        try! self.realmUser.write {
            self.realmUser.add(userObjectRealm)
        }
    }
    func updateUserObjectRealm(userObjectRealm: UserObjectRealm) {
        try! self.realmUser.write {
            self.realmUser.add(userObjectRealm, update: .modified)
        }
    }
    func removeUserObjectRealm(userObjectRealm: UserObjectRealm) {
        try! self.realmUser.write {
            userObjectRealm.listDictionary.forEach { (dictionaryObjectRealm) in
                self.realmUser.delete(dictionaryObjectRealm)
            }
            self.realmUser.delete(userObjectRealm)
        }
    }

    func findUserObjectRealmAtUserName(userName: String) -> UserObjectRealm? {
        self.realmUser.object(ofType: UserObjectRealm.self, forPrimaryKey: userName)
    }

    func removeUserObjectIfExistAtUserName(userName: String) {
        if let userObjectRealm = self.findUserObjectRealmAtUserName(userName: userName) {
            self.removeUserObjectRealm(userObjectRealm: userObjectRealm)
        }
    }

}






















        //(forResource: "UserBase", withExtension: "realm")

        //var url: URL

        //#if DEBUG
            //url = URL.init(fileURLWithPath: "Users/ryavkinto/Documents/MyApplication/WorkApplication/WorkApplication/UsersBase.realm")
        //#else
         //   url = Bundle.main.url(forResource: "UsersBase", withExtension: "realm")
        //#endif
//        let config = Realm.Configuration.init(fileURL: url, readOnly: false, schemaVersion: 1,
//            migrationBlock: { migration, oldSchemaVersion in
//                if (oldSchemaVersion < 1) {
//                    migration.enumerateObjects(ofType:UserObjectRealm.className()) { oldObject, newObject in
//                        let id = NSUUID().uuidString
//                        newObject!["userName"] = id
//                    }
//                }
//        })

//        let urlMainBase = Bundle.main.url(forResource: "MainBase", withExtension: "realm")



///Users/ryavkinto/Library/Developer/CoreSimulator/Devices/AD5B226C-D42F-4082-8F38-08DDBAB2C86F/data/Containers/Bundle/Application/94F57622-199C-48CC-997B-1E5EA896743B/WorkApplication.app/UserBase.realm




















//class RealmUser{
//
//    var realmUser: Realm!
//
//    static let shared = ModelRealmUser()
//
//    //var user: String
//
//    private init() { //userName: String) {
//        //self.user = userName
//        var url: URL! = nil
//        #if DEBUG
//            url = URL.init(fileURLWithPath: "Users/ryavkinto/Documents/MyApplication/WorkApplication/WorkApplication/UsersBase.realm")
//        #else
//            url = Bundle.main.url(forResource: "UsersBase", withExtension: "realm")
//        #endif
//        //print("url = ", url ?? "url empty")
//        let config = Realm.Configuration.init(fileURL: url, readOnly: false)
//        do{
//            self.realmUser = try Realm(configuration: config)
//
////            let dictionaryTest = DictionaryObject.init(name: "work", typeDictionary: EnumDictionaryType.EnumDictionaryTypeEngRus.rawValue, listWordObjectsByID: [0,1,2,3,4,5])
////            let user = UserObject.init(userName: "AlexanderRyavkin", dictionaryObject: dictionaryTest)
////
////            try realmUser.write { () -> Void in
////                realmUser.add(user)
////            }
//
//        } catch let error as NSError {
//            print(error.localizedDescription)
//            print("error = ", error)
//            return
//        }
//        print("init ModelRealmUser",self)
//    }
//
//    deinit {
//        print("deinit ModelRealmUser",self)
//    }
//
//}

