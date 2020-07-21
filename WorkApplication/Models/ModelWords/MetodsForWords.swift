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

    var wordObjectRealm: WordObjectRealm!

    init(wordObjectRealm: WordObjectRealm){
        self.wordObjectRealm = wordObjectRealm
        self.behaviorSubjectWord = BehaviorSubject.init(value: self.wordObjectRealm)

        print("init MetodsForWord",self)
    }

    deinit {
        print("deinit MetodsForWord",self)
    }

    func emmitingBehaviorSubjectWord() {
        self.behaviorSubjectWord.onNext(self.wordObjectRealm)
    }

    
    func saveToRealm() {
        try! realmUser.write {
            realmUser.add(self.wordObjectRealm)
        }
    }

    func changeKeyMeaning(mainMeaning: String?) {
        guard let mainMeaning = mainMeaning else {
            return
        }
        do{
            try self.realmUser.write {
                self.wordObjectRealm.mainMeaning = mainMeaning
                self.emmitingBehaviorSubjectWord()
            }
        }catch let error as NSError{
            print(error.localizedDescription)
        }
    }

    func returnWordObjectRealmIfExistToBase() -> WordObjectRealm? {
        let resultsWords = realmUser.objects(WordObjectRealm.self)
        for wordObjectRealmFromResult in resultsWords {
            if self.wordObjectRealm.wordAddMainMeaning == wordObjectRealm.wordAddMainMeaning {
                return wordObjectRealmFromResult
            }
        }
        return nil
    }


    func returnWordObjectRealmIfExistToBase(mainMeaning: String) -> WordObjectRealm? {

        let result = realmUser.objects(WordObjectRealm.self).filter("word == %@ AND mainMeaning == %@",self.wordObjectRealm.word,mainMeaning)
        
        if result.count > 0 {
            return result[0]
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
