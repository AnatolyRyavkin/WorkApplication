//
//  WordObjectRealm.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 09.07.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RealmSwift

class WordObjectRealm: Object {

    var def = List<DictionaryEntryObject>()

    @objc dynamic var word: String = ""
    @objc dynamic var mainMeaning: String = ""
    var wordAddMainMeaning: String {
        (self.metods.stringFromAny(self.value(forKey: "word")) + self.metods.stringFromAny(self.value(forKey: "mainMeaning") ) )
    }
    
    private var metodsIn: MetodsForWords?

    var metods: MetodsForWords{
        if metodsIn == nil {
            metodsIn = MetodsForWords.init(word: self)
        }
        return metodsIn!
    }

    convenience init?(wordCodable: WordCodableJSON) {
        self.init()
        if wordCodable.def.count == 0 {
            return nil
        }
        for def in wordCodable.def{
            self.def.append(DictionaryEntryObject(def: def))
        }
        self.mainMeaning = {def[0].tr[0].text ?? "-"}()
        if let word = def[0].text{
            self.word = word
        } else {
            #if DEBUG
            fatalError("dont make wordObjectRealm - have not word !")
            #else
            self.word = "?"
            #endif
        }
    }

}

class DictionaryEntryObject: Object {

    @objc dynamic var text: String?
    @objc dynamic var pos: String?
    @objc dynamic var ts: String?
    var tr = List<TranslationObject>()
    @objc dynamic var gen: String?
    @objc dynamic var num: String?

    convenience init(def: DictionaryEntryCodable){
        self.init()
        self.text = def.text
        self.pos = def.pos
        self.ts = def.ts
        self.gen = def.gen
        self.num = def.num
        guard let arrayTr = def.tr else {return}
        for tr in arrayTr {
            self.tr.append(TranslationObject(tr: tr))
        }
    }
}

class TranslationObject: Object {
    @objc dynamic var text: String?
    @objc dynamic var pos: String?
    @objc dynamic var gen: String?
    var syn = List<SynonymObject>()
    var mean = List<MeanObject>()
    var ex = List<ExampleObject>()
    @objc dynamic var num: String?
    convenience init(tr: TranslationCodable){
        self.init()
        self.text = tr.text
        self.pos = tr.pos
        self.gen = tr.gen
        if let arraySyn = tr.syn {
            for syn in arraySyn {
                self.syn.append(SynonymObject(syn: syn))
            }
        }
        if let arrayMean = tr.mean {
            for mean in arrayMean {
                self.mean.append(MeanObject(mean: mean))
            }
        }
        if let arrayExample = tr.ex {
            for ex in arrayExample {
                self.ex.append(ExampleObject(ex: ex))
            }
        }
        self.num = tr.num
    }
}

class SynonymObject: Object {
    @objc dynamic var text: String?
    @objc dynamic var pos: String?
    @objc dynamic var gen: String?
    @objc dynamic var num: String?
    convenience init(syn: SynonymCodable) {
        self.init()
        self.text = syn.text
        self.pos = syn.pos
        self.gen = syn.gen
        self.num = syn.num
    }
}

class MeanObject: Object {
    @objc dynamic var text: String?
    @objc dynamic var pos: String?
    @objc dynamic var gen: String?
    @objc dynamic var num: String?
    convenience init(mean: MeanCodable) {
        self.init()
        self.text = mean.text
        self.pos = mean.pos
        self.gen = mean.gen
        self.num = mean.num

    }
}

class ExampleObject: Object {
    @objc dynamic var text: String?
    var tr = List<TranslationObject>()
    convenience init(ex: ExampleCodable) {
        self.init()
        self.text = ex.text
        guard let arrayTr = ex.tr else { return }
        for tr in arrayTr {
            self.tr.append(TranslationObject.init(tr: tr))
        }
    }
}
