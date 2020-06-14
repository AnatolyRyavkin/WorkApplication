//
//  ExampleObjectForRusMeaning.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 13.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RealmSwift

class ExampleObjectForRusMeaning: Object {

    @ objc dynamic var meaningExample: String = ""
    @ objc dynamic var accessoryExample: String = ""

    let rusMeaningParent = LinkingObjects(fromType: RusMeaningObject.self, property: "listExampleForMeaning")

    convenience init(exampleSource: Example){
        self.init()
        if let meaning = exampleSource.meaning{
            self.meaningExample = meaning
        }
        if let accessory = exampleSource.accessory{
            self.accessoryExample = accessory
        }
    }


    func printSelf(){
        print("exampleMeaning = \(meaningExample)")
        print("accessory = \(accessoryExample)")
    }

}

