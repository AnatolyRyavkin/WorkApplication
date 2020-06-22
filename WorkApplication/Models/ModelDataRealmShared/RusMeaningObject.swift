//
//  RusMeaningObject.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RealmSwift

class RusMeaningObject: Object {

    var listRusMeaning = List<String>()
    var listAccessoryForRusMeaning = List<String>()
    @objc dynamic var derevativeForMeaning: String = ""
    var listExampleForMeaning = List<ExampleObjectForRusMeaning>()

    let wordObjectParent = LinkingObjects(fromType: WordObject.self, property: "listRusMeaning")

    convenience init(rusMeaningSource: RusMeaning) {

        self.init()

        if let arrayMeaning = rusMeaningSource.arrayMeaning{
            self.listRusMeaning.append(objectsIn: arrayMeaning)
        }
        if let arrayAccessory = rusMeaningSource.arrayAccessory{
            self.listAccessoryForRusMeaning.append(objectsIn: arrayAccessory)
        }
        if let derevative = rusMeaningSource.derevative{
            self.derevativeForMeaning = derevative
        }
        if let arrayExampleAny = rusMeaningSource.arrayExample {
            for example in arrayExampleAny{
                self.listExampleForMeaning.append(ExampleObjectForRusMeaning.init(exampleSource: example))
            }
        }
        print("init rusMeaningObject",self)
    }

    deinit {
        print("deinit rusMeaningObject",self)
    }

    func printSelf(){
        for meaningRusString in self.listRusMeaning{
            print("meaningRusString = \(meaningRusString)")
        }

        for accessoryRusString in self.listAccessoryForRusMeaning{
            print("accessoryRusString = \(accessoryRusString)")
        }

        for example in self.listExampleForMeaning{
            example.printSelf()
        }

        print("derevative = \(self.derevativeForMeaning)")

    }

}

