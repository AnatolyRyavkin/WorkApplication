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

enum EnumDictionaryType: String {
    case EnumDictionaryTypeEngRus = "typeDictionaryEngRus"
    case EnumDictionaryTypeRusEng = "typeDictionaryRusEng"
}

class DictionaryObjectRealm: Object{

    enum EnumDictionaryType: String {
        case typeDictionaryEngRus = "typeDictionaryEngRus"
        case typeDictionaryRusEng = "typeDictionaryRusEng"
    }

    let typeDictionaryEngRus = "typeDictionaryEngRus"
    let typeDictionaryRusEng = "typeDictionaryRusEng"

    @objc dynamic var name: String = ""
    @objc dynamic var typeDictionary: String = ""
    var listWordObjects: List<WordObjectRealm> = List<WordObjectRealm>() {
        didSet {
            if behaviorSubjectWordsToDictionary != nil {
                behaviorSubjectWordsToDictionary.onNext(listWordObjects)
            }
        }
    }
    var owner = LinkingObjects(fromType: UserObjectRealm.self, property: "listDictionary")

    var behaviorSubjectWordsToDictionary: BehaviorSubject<List<WordObjectRealm>>!
    var behaviorSubjectModelSectionDictionary: BehaviorSubject<[ModelSectionDictionary]>!

    var disposeBag = DisposeBag()

    convenience init(name: String, typeDictionary: String){
        self.init()
        self.name = name
        self.typeDictionary = typeDictionary
        self.behaviorSubjectWordsToDictionary = BehaviorSubject.init(value: listWordObjects)
        self.subscr()
    }

    func subscr()  {
        var arraySectionModel = [ModelSectionDictionary]()
        self.behaviorSubjectWordsToDictionary
        .subscribe(onNext:{listWordObjects in
            for ch in "ABCDEFGHIJKLMNOPQRSTUVWXYZ"{
                var sectionWord = Array<WordObjectRealm>()
                listWordObjects.map{wordObjectRealm in
                    let def = wordObjectRealm.def
                    let title = def[0].text
                    if title?.first == ch {
                        sectionWord.append(wordObjectRealm)
                    }
                }
                arraySectionModel.append(ModelSectionDictionary.init(nameSection: "\(ch)", arrayWord: sectionWord))
                if self.behaviorSubjectModelSectionDictionary != nil {
                    self.behaviorSubjectModelSectionDictionary.onNext(arraySectionModel)
                }
            }
        }).disposed(by: self.disposeBag)
    }

    deinit {
        //print("deinit dictionaryObject",self)
    }

    func printSelf(){
        print("nameDictionary = \(self.name)")
        print("typeDictionary = \(self.typeDictionary)")
        print("ownre = ",owner)
    }
}















//class DictionaryObjectRealm: Object{
//
//    enum EnumDictionaryType: String {
//        case typeDictionaryEngRus = "typeDictionaryEngRus"
//        case typeDictionaryRusEng = "typeDictionaryRusEng"
//    }
//
//    let typeDictionaryEngRus = "typeDictionaryEngRus"
//    let typeDictionaryRusEng = "typeDictionaryRusEng"
//
//    @objc dynamic var name: String = ""
//    @objc dynamic var typeDictionary: String = ""
//    //var listWordObjectsByID: List<Int> = List<Int>()
//    var listWordObjects: List<WordObjectRealm> = List<WordObjectRealm>()
//    var owner = LinkingObjects(fromType: UserObjectRealm.self, property: "listDictionary")
//
//    convenience init(name: String, typeDictionary: String, listWordObjectsByID: Array<Int>? = []){
//        self.init()
//        self.name = name
//        self.typeDictionary = typeDictionary
//        if let arrayID =  listWordObjectsByID{
//            self.listWordObjectsByID.append(objectsIn: arrayID)
//        }
//        //print("init dictionaryObject",self)
//    }
//
//    deinit {
//        //print("deinit dictionaryObject",self)
//    }
//
//    func printSelf(){
//        print("nameDictionary = \(self.name)")
//        print("typeDictionary = \(self.typeDictionary)")
//        print("ownre = ",owner)
//        for number in self.listWordObjectsByID{
//            print("IDWordObjectIncluded = \(number)")
//        }
//    }
//}

