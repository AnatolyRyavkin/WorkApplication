//
//  ElementWord.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 10.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RealmSwift


//MARK- ExampleObjectForRusMeaning

class ExampleObjectForRusMeaning: Object {

    dynamic var meaningExample: String = ""
    dynamic var accessoryExample: String = ""

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

//MARK- RusMeaningObject

class RusMeaningObject: Object {

    dynamic var listRusMeaning = List<String>()
    dynamic var listAccessoryForRusMeaning = List<String>()
    dynamic var derevativeForMeaning: String = ""
    dynamic var listExampleForMeaning = List<ExampleObjectForRusMeaning>()

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

//MARK- WordObject

class WordObject: Object {

    dynamic var numGlobalMeaning: Int = 0
    dynamic var numLocalMeaning: Int = 0
    dynamic var countMeaningAtAllSameEngMeaningObject: Int = 0
    dynamic var typeObject: String = ""
    dynamic var engMeaningObject: String = ""
    dynamic var engTranscriptObject: String = ""
    dynamic var listGrammaticType = List<String>()
    dynamic var listGrammaticForm = List<String>()
    dynamic var listRusMeaning = List<RusMeaningObject>()
    dynamic var listIdiom = Array<String>()

    required init() {
        super.init()
        print("WordObject init")
    }

    convenience init( itemSource: Item){

        self.init()

        self.typeObject = itemSource.typeItem ?? ""
        self.numGlobalMeaning = itemSource.indexPathMeaning?.numberGlobalMeaning ?? 0
        self.numLocalMeaning = itemSource.indexPathMeaning?.numberLocalMeaning ?? 0
        self.countMeaningAtAllSameEngMeaningObject = itemSource.indexPathMeaning?.countMeaningInObject ?? 0
        self.engMeaningObject = itemSource.engMeaningItem ?? ""
        self.engTranscriptObject = itemSource.engTranscript ?? ""

        if let arrayGrammaticType = itemSource.arrayGrammaticType{
            self.listGrammaticType.append(objectsIn: arrayGrammaticType)
        }

        if let arrayRusMeaning = itemSource.arrayRusMeaning{
            for rusMeaning in arrayRusMeaning{
                self.listRusMeaning.append(RusMeaningObject.init(rusMeaningSource: rusMeaning))
            }
        }
        if let arrayIdiom = itemSource.arrayIdiom{
            self.listIdiom.append(contentsOf: arrayIdiom)
        }
    }


    func printSelf(){

        print("typeItem = \(self.typeObject)")
        print("IndexPath = numG: \(self.numGlobalMeaning); numL: \(self.numLocalMeaning) numC: \(self.countMeaningAtAllSameEngMeaningObject)")
        print("engMeaningObject = \(engMeaningObject)")
        print("engTranscriptObject = \(engTranscriptObject)")

        if self.listGrammaticType.count > 0{
            for grammaticType in self.listGrammaticType{
                print("grammaticType = \(grammaticType)")
            }
        }

        if self.listGrammaticForm.count > 0{
            for grammaticForm in self.listGrammaticForm{
                print("grammaticForm = \(grammaticForm)")
            }
        }

        if self.listRusMeaning.count > 0{
            print("\n      Rus Meaning")
            for rusMeaningObject in self.listRusMeaning{
                print("----------------------------")
                    rusMeaningObject.printSelf()
            }
            print()
        }

        if self.listIdiom.count > 0{
            for idiom in self.listIdiom{
                print("Idiom = \(idiom)")
            }
        }
    }
}

