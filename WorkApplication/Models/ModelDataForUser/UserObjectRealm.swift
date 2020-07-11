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
    @objc var userName: String = ""
    var listDictionary: List<DictionaryObjectRealm> = List<DictionaryObjectRealm>()

    required init() {}

    init(userName: String, dictionaryObject: DictionaryObjectRealm?) {
        super.init()
        if let dictObj = dictionaryObject{
            self.listDictionary.append(dictObj)
        }
        self.userName = userName
        //print("init userObject",self)
    }

    deinit {
        //print("deinit userObject",self)
    }
    
}


