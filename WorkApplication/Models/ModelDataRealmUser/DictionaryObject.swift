//
//  DictionaryObject.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RealmSwift

enum EnumDictionaryType: String {
    case EnumDictionaryTypeEngRus = "typeDictionaryEngRus"
    case EnumDictionaryTypeRusEng = "typeDictionaryRusEng"
}

class DictionaryObject: Object{

    enum EnumDictionaryType: String {
        case typeDictionaryEngRus = "typeDictionaryEngRus"
        case typeDictionaryRusEng = "typeDictionaryRusEng"
    }

    let typeDictionaryEngRus = "typeDictionaryEngRus"
    let typeDictionaryRusEng = "typeDictionaryRusEng"

    @objc dynamic var name: String = ""
    @objc dynamic var typeDictionary: String = ""
    var listWordObjectsByID: List<Int> = List<Int>()
    var owner = LinkingObjects(fromType: UserObject.self, property: "listDictionary")

    convenience init(name: String, typeDictionary: String, listWordObjectsByID: Array<Int>? = []){
        self.init()
        self.name = name
        self.typeDictionary = typeDictionary
        if let arrayID =  listWordObjectsByID{
            self.listWordObjectsByID.append(objectsIn: arrayID)
        }
        print("init dictionaryObject",self)
    }

    deinit {
        print("deinit dictionaryObject",self)
    }

    func printSelf(){
        print("nameDictionary = \(self.name)")
        print("typeDictionary = \(self.typeDictionary)")
        print("ownre = ",owner)
        for number in self.listWordObjectsByID{
            print("IDWordObjectIncluded = \(number)")
        }
    }
}
