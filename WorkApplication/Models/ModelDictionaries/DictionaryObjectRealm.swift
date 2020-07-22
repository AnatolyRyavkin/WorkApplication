//
//  DictionaryObjectRealm.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class DictionaryObjectRealm: Object{

    @objc dynamic var name: String = ""
    @objc dynamic var typeDictionary: String = ""
    var listWordObjects: List<WordObjectRealm> = List<WordObjectRealm>()
    var owner = LinkingObjects(fromType: UserObjectRealm.self, property: "listDictionary")
    
    var metodsIn: MetodsForDictionary?

    var metods: MetodsForDictionary{
        if metodsIn == nil {
            metodsIn = MetodsForDictionary.init(dictionary: self)
        }
        return metodsIn!
    }

    required init() {
        super.init()

    }
    deinit {
       
    }

}

