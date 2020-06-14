//
//  ModelRealmBase.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 12.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RealmSwift

class ModelRealmBase{

    var realmMain: Realm!

    static let shared = ModelRealmBase()

    private init() {
        print("init ModelRealmBase")
        let urlMainBase = Bundle.main.url(forResource: "MainBase", withExtension: "realm")
        let config = Realm.Configuration.init(fileURL: urlMainBase,
                                              readOnly: false,
                                              schemaVersion: 2)
        //print(config)
        do{
            self.realmMain = try Realm(configuration: config)
            //print("realmShared = Success! ----------------------- ",realmMain!)
        }catch let error{
            print("error = ", error)
        }
    }

    deinit {
        print("deinit ModelRealmBase")
    }
}









//    init(string: String){
//        super.init()
//        let urlMainBase = Bundle.main.url(forResource: "MainBase", withExtension: "realm")
//        let config = Realm.Configuration.init(fileURL: urlMainBase,
//                                              readOnly: false,
//                                              schemaVersion: 2)
//        print(config)
//        do{
//            self.realmMain = try Realm(configuration: config)
//            print("realmShared = -----------------------",realmMain!)
//        }catch let error{
//            print("error = ", error)
//        }
//    }

//enum EnumTypeConfig {
//    case EnumTypeConfigSharedBase
//    case EnumTypeConfigDefaultBase
//}

//        realmMain = try! Realm()
//        print(realmMain.debugDescription)

//        var config = Realm.Configuration()
//        let oldPath = config.fileURL!
//        var newPath = oldPath.deletingLastPathComponent()
//        newPath = newPath.appendingPathComponent("MainBase.realm")
//        print(newPath)
//        config = Realm.Configuration.init(fileURL: newPath, readOnly: false, schemaVersion: 2, migrationBlock: { (migration, oldSchemaVersion) in
//            if oldSchemaVersion < 2 { }
//        })
//        do{
//        var realm1 = try! Realm(configuration: config)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//            print("error = ", error)
//            return
//        }

//        let realmTest = try! Realm()
//        print(realmTest.configuration.description)
//
//

/////////////////////////////////////////////////






//        } catch let error as NSError {
//            print(error.localizedDescription)
//            print("error = ", error)
//            return
        //}



//
//
//
//
//
//    let bundlePathRealm: URL! = nil
//    var sourceDataItems = DataItems.Shared.arrayItems
//    var pathBase: URL! = nil
//    var realm1: Realm! = nil
//
//
//    func getBaseShared() throws{
//
//        var count = 0
//        for item in sourceDataItems{
//            print("countRealmObject = ", count)
//            let realmObject = WordObject.init( itemSource: item)
//            do {
//                if let realm = getRealm(type: .EnumTypeConfigSharedBase){
//                    try realm.write{
//                        if count == 0{
//                            print(realm.configuration.fileURL!)
//                        }
//                        realm.add(realmObject)
//                    }
//                }
//            } catch let error as NSError {
//                print(error.localizedDescription)
//                print("error = ", error)
//                break
//            }
//            count += 1
//        }
////        getRealm(type: .EnumTypeConfigSharedBase)
////        signUp()
////        print(SyncUser.self)
////        let config = SyncUser.current?.configuration(realmURL: self.pathBase, fullSynchronization: true)
////
////        realm1 = try! Realm(configuration: config!)
////
////        getObjectsForRusMeaning(stringRusMeaning:"A major ля мажор")
//    }
//
////    var username: String? {
////        get {
////            return "username"
////        }
////    }
////
////    var password: String? {
////        get {
////            return "password"
////        }
////    }
////
////
//    func getRealm(type: EnumTypeConfig) -> Realm? {
//        var config = Realm.Configuration()
//        switch type{
//        case .EnumTypeConfigSharedBase:
//            let oldPath = config.fileURL!
//            var newPath = oldPath.deletingLastPathComponent()
//            newPath = newPath.appendingPathComponent("MainBase.realm")
//            self.pathBase = newPath
//            print(newPath)
//            config = Realm.Configuration.init(fileURL: newPath, readOnly: false, schemaVersion: 2, migrationBlock: { (migration, oldSchemaVersion) in
//                if oldSchemaVersion < 2 { }
//            })
//            config = Realm.Configuration.init(fileURL: newPath, readOnly: false, schemaVersion: 2, migrationBlock: { (migration, oldSchemaVersion) in
//                if oldSchemaVersion < 2 { }
//            })
//
//            var realm: Realm
//            do {
//                realm = try Realm(configuration: config)
//                return realm
//            } catch let error as NSError {
//                print(error.localizedDescription)
//                print("error = ", error)
//                return nil
//            }
//        case .EnumTypeConfigDefaultBase:
//            return try? Realm()
//        }
//    }


//    @objc func signIn() {
//        logIn(username: username!, password: password!, register: false)
//    }
//
//    @objc func signUp() {
//        logIn(username: username!, password: password!, register: true)
//
//    }

    // Log in with the username and password, optionally registering a user.
//    func logIn(username: String, password: String, register: Bool) {
//        print("Log in as user: \(username) with register: \(register)");
//        //////////////
//        if SyncUser.all.count > 0{
//            for u in SyncUser.all {
//                print(u.value)
//               u.value.logOut()
//            }
//        }
        ////////////////
//
//        let creds = SyncCredentials.usernamePassword(username: username, password: password, register: register);
//
//
//        SyncUser.logIn(with: creds, server: self.pathBase, onCompletion: { [weak self](user, err) in
//
//
//            //self!.setLoading(false);
//            if let error = err {
//                // Auth error: user already exists? Try logging in as that user.
//                print("Login failed: \(error)");
//                //self!.errorLabel.text = "Login failed: \(error.localizedDescription)"
//                print("Login failed: \(error.localizedDescription)")
//                return;
//            }
//            print("Login succeeded!");
//            //self!.navigationController!.pushViewController(ItemsViewController(), animated: true);
//        });
//        print(SyncUser.self)
//    }
//
//
//    func removeRealm1(realm: Realm) throws {
//        try realm.write{
//            realm.deleteAll()
//        }
//    }
//
//
//
//    func getObjectsForRusMeaning(stringRusMeaning: String){
//        if let realm = getRealm(type: .EnumTypeConfigSharedBase){
//            do{

//         1)
//                let rusObjects = try! realm.objects(ExampleForRusMeaningObject.self).filter("meaningExample CONTAINS %@", stringRusMeaning)
//                print(rusObjects)
//         2)

//                let predicate1 = NSPredicate(format:"SUBQUERY(wordObjectParent, $word, $word.engMeaningObject CONTAINS 'a') .@count > 0", argumentArray: nil)
//                let obs = try! realm.objects(RusMeaningObject.self).filter(predicate1)
//                print(obs)
//         3)
//                let o = try! realm.objects(RusMeaningObject.self)
//                let o1 = o.filter("derevativeForMeaning = '' AND listRusMeaning.@count > 0")
//         4)
//                let o1 = realm.objects(RusMeaningObject.self).filter("listExampleForMeaning.@count > 2")
//                print(o1)
//         5)
                //dont work:
//                let o2 = realm.objects(WordObject.self).filter("listRusMeaning.@count > 1")


//            }
//        }
//
//    }



//}
