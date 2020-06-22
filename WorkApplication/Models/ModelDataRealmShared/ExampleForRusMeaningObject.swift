//
//  ExampleForRusMeaningObject.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
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
        print("init exampleForRusMeaningObject",self.description)
    }

    deinit {
        print("deinit exampleForRusMeaningObject",self.description)
    }



    func printSelf(){
        print("exampleMeaning = \(meaningExample)")
        print("accessory = \(accessoryExample)")
    }

}
