//
//  RealmUser.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUser{
     
    var realmUser: Realm!

    static let shared = RealmUser()


    private init() {
        var url: URL
        #if DEBUG
            url = URL.init(fileURLWithPath: "Users/ryavkinto/Documents/MyApplication/WorkApplication/WorkApplication/UsersBase.realm")
        #else
            url = Bundle.main.url(forResource: "UsersBase", withExtension: "realm")
        #endif
        let config = Realm.Configuration.init(fileURL: url, readOnly: false)
        do{
            self.realmUser = try Realm(configuration: config)
            
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
    
}

















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

