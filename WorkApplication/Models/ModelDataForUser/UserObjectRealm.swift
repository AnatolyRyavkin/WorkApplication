//
//  File.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RealmSwift

class UserObjectRealm: Object{

    @objc dynamic var id = ""
    @objc dynamic var userName: String = ""
    var listDictionary: List<DictionaryObjectRealm> = List<DictionaryObjectRealm>()

    override public static func primaryKey() -> String? {
        return "userName"
    }

    required init() {
        super.init()
    }
    deinit {
    }

    private static var CurrentUserObjRealm: UserObjectRealm?

    static var CurrentUserObjectRealm: UserObjectRealm? {
        get{
            if UserObjectRealm.CurrentUserObjRealm == nil{
                UserObjectRealm.CurrentUserObjRealm = UserDefaults.standard.getCurrentUserName()
            }
            return UserObjectRealm.CurrentUserObjRealm
        }
        set{
            print("- - - - - -    currentUserOld = \(CurrentUserObjRealm?.userName ?? "empty")")
            UserObjectRealm.CurrentUserObjRealm?.metodsIn?.behaviorSubjectDictionaryToUser.dispose()
            UserObjectRealm.CurrentUserObjRealm?.metodsIn = nil
            UserDefaults.standard.setCurrentUserName(userObject: newValue)
            UserObjectRealm.CurrentUserObjRealm = newValue
            print("- - - - - -    currentUserNew = \(CurrentUserObjRealm?.userName ?? "empty")")
        }
    }

    static func CleanCurrentUser() {
        UserDefaults.standard.cleanUserDefault()
        UserObjectRealm.CurrentUserObjRealm = nil
    }

    private var  metodsIn: MetodsForUser?

    var metods: MetodsForUser{
        if metodsIn == nil {
            metodsIn = MetodsForUser.init(userObjectRealm: self)
        }
        return metodsIn!
    }

}

