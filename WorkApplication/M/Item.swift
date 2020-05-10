//
//  Item.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 07.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation

class SourceClass{
    func checkString(inputString: String?) -> String? {

        guard let inString = inputString
            else{ return nil }
        var array = inString.components(separatedBy: " ").filter { string in
            return (string != " ") && (string != "")
        }

        array = array.map{ string in
            if string == "тп" {
                //print(inString)
                return "т.п."
            }
             if string == "обыкн" || string == "обыкнов" {
                //print(inString)
                return "обычно"
            }
            if string == "неодобр" {
                //print(inString)
                return "неодобрительно"
            }
            if string.hasSuffix("-л"){
                //print(inString)
                let stringNew = string.dropLast(2).appending("-либо")
                return stringNew
            }
            return string
        }

        var stringOut: String? = nil
        for (i, st) in array.enumerated() {
            if i == 0 {
                stringOut = String()
                stringOut?.append(st)
            }else{
                stringOut?.append(String(" \(st)"))
            }
        }

        //print(stringOut ?? "nil")
        return stringOut
    }

    func checkArray(inputArray: Array<String?>?) -> Array<String>? {
        guard let arrayUnwr = inputArray else { return nil }
        var arrayOut: Array<String> = arrayUnwr
            .filter { string -> Bool in
                return string != nil && string != " " && string != ""
            } as! Array<String>

        arrayOut = arrayOut.map({ (string) in
            guard let stringOut = self.checkString(inputString: string)
                else{ print("fatal error") ; fatalError()}
            //print(stringOut)
            return stringOut
        })
        //print(arrayOut)
        return arrayOut
    }

    func printSt(st: String){
        print(" \(st.debugDescription) = \(st)")
    }
}

enum EnumKeysItem: String {

    case TypeObjectKey = "typeObject"

    case IndexPathGlobalKey = "indexPathGlobal"
    case IndexPathLocalKey = "indexPathLocal"
    case indexPathCountKey = "indexPathCount"

    case EngMeaningObjectKey = "engMeaningObject"
    case EngTranscriptKey = "engTranscript"
    case GrammaticTypeKey = "grammaticType"
    case GrammaticFormKey = "grammaticForm"
    case ArrayIdiomKey = "arrayIdiom"

    case ArrayRusMeaningKey = "arrayRusMeaning"

    case ArrayExampleRusMeaningKey = "arrayExampleRusMeaning"
    case ArrayMeaningRusMeaningKey = "arrayMeaningRusMeaning"
    case AccessoryRusMeaningKey = "accessoryRusMeaning"
    case DereviativeRusMeaningKey = "dereviativeRusMeaning"

    case MeaningExampleKey = "meaningExample"
    case AccessoryExampleKey = "accessoryExample"

}

//MARK- Structura IndexPath

struct IndexPathMeaning {
    var numberGlobalMeaning: Int?
    var numberLocalMeaning: Int?
    var countMeaningInObject: Int?

    init(dictionarySource: Dictionary<String, Any>){
        if let numberGlobalMeaning = dictionarySource[EnumKeysItem.IndexPathGlobalKey.rawValue]{
            self.numberGlobalMeaning = numberGlobalMeaning as? Int
        }
        if let numberLocalMeaning = dictionarySource[EnumKeysItem.IndexPathLocalKey.rawValue]{
            self.numberLocalMeaning = numberLocalMeaning as? Int
        }
        if let countMeaningInObject = dictionarySource[EnumKeysItem.indexPathCountKey.rawValue]{
            self.countMeaningInObject = countMeaningInObject as? Int
        }
    }

    func printSelf(){
        
        if let numberGlobalMeaning = self.numberGlobalMeaning{
            print("numberGlobalMeaning = \(numberGlobalMeaning)")
        }
        if let numberLocalMeaning = self.numberLocalMeaning{
            print("numberLocalMeaning = \(numberLocalMeaning)")
        }
        if let countMeaningInObject = self.countMeaningInObject{
            print("countMeaningInObject = \(countMeaningInObject)")
        }
    }

};

//MARK- Structura Example

class Example: SourceClass {
    var meaning: String?
    var accessory: String?

    init(dictionarySource: Dictionary<String, Any>){

        super.init()

        if let meaning = dictionarySource[EnumKeysItem.MeaningExampleKey.rawValue]{
            self.meaning = self.checkString(inputString: meaning as? String)
        }
        if let accessory = dictionarySource[EnumKeysItem.AccessoryExampleKey.rawValue]{
            self.accessory = self.checkString(inputString: accessory as? String)
        }
    }

    func printSelf(){
        if let meaning = self.meaning{
            print("exampleMeaning = \(meaning)")
        }
        if let accessory = self.accessory{
            print("accessory = \(accessory)")
        }
    }

}

//MARK- Structura RusMeaning

class RusMeaning: SourceClass {
    var arrayMeaning: Array<String>?
    var arrayAccessory: Array<String>?
    var derevative: String?
    var arrayExample: Array<Example>?

    init(dictionarySource: Dictionary<String, Any>) {

        super.init()

        if let arrayMeaning = dictionarySource[EnumKeysItem.ArrayMeaningRusMeaningKey.rawValue]{
            self.arrayMeaning = self.checkArray(inputArray: arrayMeaning as? Array<String?>)
        }
        if let arrayAccessory = dictionarySource[EnumKeysItem.AccessoryRusMeaningKey.rawValue]{
            self.arrayAccessory = self.checkArray(inputArray: arrayAccessory as? Array<String?>)
        }
        if let derevative = dictionarySource[EnumKeysItem.DereviativeRusMeaningKey.rawValue]{
            self.derevative = self.checkString(inputString: derevative as? String)
        }
        if let arrayExampleAny = dictionarySource[EnumKeysItem.ArrayExampleRusMeaningKey.rawValue] as?
            Array<Dictionary<String, Any>> {
            self.arrayExample = Array<Example>()
            for arrayDictionaryExampleAny in arrayExampleAny{
                self.arrayExample?.append(Example.init(dictionarySource: arrayDictionaryExampleAny))
            }
        }
    }

    func printSelf(){
        if self.arrayMeaning?.count ?? 0 > 0{
            for meaningRusString in self.arrayMeaning!{
                print("meaningRusString = \(meaningRusString)")
            }
        }
        if self.arrayAccessory?.count ?? 0 > 0{
            for accessoryRusString in self.arrayAccessory!{
                print("accessoryRusString = \(accessoryRusString)")
            }
        }

        if self.arrayExample?.count ?? 0 > 0{
            for example in self.arrayExample!{
                example.printSelf()
            }
        }

        if let derevative = self.derevative{
            print("derevative = \(derevative)")
        }
    }

}

//MARK- Structura Item

class Item: SourceClass {
    var typeItem: String?
    var indexPathMeaning: IndexPathMeaning?
    var engMeaningItem: String?
    var engTranscript: String?
    var arrayGrammaticType: Array<String>?
    var arrayGrammaticForm: Array<String>?
    var arrayRusMeaning: Array<RusMeaning>?
    var arrayIdiom: Array<String>?

    override init() {
        super.init()
        print("Item init")
    }

//MARK- init from object from file SourceTextDictionary.txt

    init(dictionarySource: Dictionary<String, Any>){

        super.init()

        if let typeItem = dictionarySource[EnumKeysItem.TypeObjectKey.rawValue]{
            self.typeItem = self.checkString(inputString: typeItem as? String)
        }

        self.indexPathMeaning = IndexPathMeaning.init(dictionarySource: dictionarySource)

        if let engMeaningItem = dictionarySource[EnumKeysItem.EngMeaningObjectKey.rawValue]{
            self.engMeaningItem = self.checkString(inputString: engMeaningItem as? String)
        }

        if let engTranscript = dictionarySource[EnumKeysItem.EngTranscriptKey.rawValue]{
            self.engTranscript = self.checkString(inputString: engTranscript as? String)
        }

        if let arrayGrammaticType = dictionarySource[EnumKeysItem.GrammaticTypeKey.rawValue]{
            self.arrayGrammaticType = self.checkArray(inputArray: arrayGrammaticType as? Array<String?>)
        }

        if let arrayGrammaticForm = dictionarySource[EnumKeysItem.GrammaticFormKey.rawValue]{
            self.arrayGrammaticForm = self.checkArray(inputArray: arrayGrammaticForm as? Array<String?>)
        }

        if let arrayRusMeaningAny = dictionarySource[EnumKeysItem.ArrayRusMeaningKey.rawValue] as? Array<Any>{
            self.arrayRusMeaning = Array<RusMeaning>()
            for dictionaryRusMeaningAny in arrayRusMeaningAny{
                if let dictionaryRusMeaning = dictionaryRusMeaningAny as? Dictionary<String, Any>{
                    self.arrayRusMeaning?.append(RusMeaning.init(dictionarySource: dictionaryRusMeaning))
                }
            }
        }

        if let arrayIdiom = dictionarySource[EnumKeysItem.ArrayIdiomKey.rawValue]{
            self.arrayIdiom = self.checkArray(inputArray: arrayIdiom as? Array<String?>)
        }

    }

    func printSelf(){

        if let typeItem = self.typeItem{
            print("typeItem = \(typeItem)")
        }
        if let indexPathMeaning = self.indexPathMeaning {
            print("      IndexPath")
            indexPathMeaning.printSelf()
            print()
        }
        if let engMeaningItem = self.engMeaningItem{
            print("engMeaningItem = \(engMeaningItem)")
        }
        if let engTranscript = self.engTranscript{
            print("engTranscript = \(engTranscript)")
        }

        if self.arrayGrammaticType?.count ?? 0 > 0{
            for grammaticType in self.arrayGrammaticType!{
                print("grammaticType = \(grammaticType)")
            }
        }

        if self.arrayGrammaticForm?.count ?? 0 > 0{
            for grammaticForm in self.arrayGrammaticForm!{
                print("grammaticForm = \(grammaticForm)")
            }
        }

        if self.arrayRusMeaning?.count ?? 0 > 0{
            print("\n      Rus Meaning")
            for rusMeaningObject in self.arrayRusMeaning!{
                print("----------------------------")
                    rusMeaningObject.printSelf()
            }
            print()
        }

        if self.arrayIdiom?.count ?? 0 > 0{
            for idiom in self.arrayIdiom!{
                print("arrayIdiom = \(idiom)")
            }
        }
    }

}

