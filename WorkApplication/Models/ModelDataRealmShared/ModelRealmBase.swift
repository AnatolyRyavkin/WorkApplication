//
//  ModelRealmBase.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 12.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RealmSwift

class ModelRealmBase{

    var realmMain: Realm!

    static let shared = ModelRealmBase()

    private init() {
        print("init ModelRealmBase",self)
        let urlMainBase = Bundle.main.url(forResource: "MainBase", withExtension: "realm")
        let config = Realm.Configuration.init(fileURL: urlMainBase,
                                              readOnly: false,
                                              schemaVersion: 2)
        do{
            self.realmMain = try Realm(configuration: config)
        }catch let error{
            print("error = ", error)
        }
    }

    deinit {
        print("deinit ModelRealmBase",self)
    }
}
