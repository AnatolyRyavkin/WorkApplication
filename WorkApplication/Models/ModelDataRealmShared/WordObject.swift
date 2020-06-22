//
//  ElementWord.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 10.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RealmSwift

class WordObject: Object {

    @objc dynamic var numGlobalMeaning: Int = 0
    @objc dynamic var numLocalMeaning: Int = 0
    @objc dynamic var countMeaningAtAllSameEngMeaningObject: Int = 0
    @objc dynamic var typeObject: String = ""
    @objc dynamic var engMeaningObject: String = ""
    @objc dynamic var engTranscriptObject: String = ""
    var listGrammaticType = List<String>()
    var listGrammaticForm = List<String>()
    var listRusMeaning = List<RusMeaningObject>()
    var listIdiom = List<String>()

    static var ID = 0

    @objc dynamic var id = 0

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init( itemSource: Item){

        self.init()
        //print("WordObject init",self.debugDescription)
        id = WordObject.ID
        WordObject.ID += 1

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
            self.listIdiom.append(objectsIn: arrayIdiom)
        }
        print("init wordObject",self)
    }

    deinit {
        print("deinit wordObject",self)
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

