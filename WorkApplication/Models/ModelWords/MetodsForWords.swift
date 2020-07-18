//
//  MetodsForWords.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 10.07.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift
import RealmSwift

class MetodsForWords {


    //var modelRealmMainBase: ModelRealmBase = ModelRealmBase.shared
    let disposeBag = DisposeBag()
    var realmUser: Realm {
        RealmUser.shared.realmUser
    }

    var behaviorSubjectWord: BehaviorSubject<WordObjectRealm>!

    var word: WordObjectRealm!

    init(word: WordObjectRealm){
        self.word = word
        self.behaviorSubjectWord = BehaviorSubject.init(value: self.word)

        print("init MetodsForWord",self)
    }

    deinit {
        print("deinit MetodsForWord",self)
    }

    func emmitingBehaviorSubjectWord() {
        self.behaviorSubjectWord.onNext(self.word)
    }

    
    func saveToRealm() {
        try! realmUser.write {
            realmUser.add(self.word)
        }
    }

    func changeKeyMeaning(mainMeaning: String?) {
        guard let mainMeaning = mainMeaning else {
            return
        }
        do{
            try self.realmUser.write {
                self.word.mainMeaning = mainMeaning
                self.emmitingBehaviorSubjectWord()
            }
        }catch let error as NSError{
            print(error.localizedDescription)
        }
    }

    func returnWordObjectRealmIfExistToBase(wordObjectRealm: WordObjectRealm) -> WordObjectRealm? {
        let resultsWords = realmUser.objects(WordObjectRealm.self)
        for word in resultsWords {
            let s1 = "\(String(describing: word.value(forKey: "word")))" + "\(String(describing: word.value(forKey: "mainMeaning")))"
            let s2 = "\(String(describing: wordObjectRealm.value(forKey: "word")))" + "="  + "\(String(describing: wordObjectRealm.value(forKey: "mainMeaning")))"
            if s1 == s2 {
                return word
            }
        }
        return nil
    }

    func stringFromAny(_ value:Any?) -> String {
        if let nonNil = value, !(nonNil is NSNull) {
            return String(describing: nonNil)
        }
        return ""
    }

}
