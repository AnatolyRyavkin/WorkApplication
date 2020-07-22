//
//  DataItems.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 07.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation

class DataItems {

    static var Shared: DataItems{
        if DataItems.SharedPrivate == nil{
            DataItems.SharedPrivate = DataItems()
        }
        return DataItems.SharedPrivate!
    }
    private static var SharedPrivate: DataItems? = nil

    var arrayItems = Array<Item>()

    private init(){

        guard let path = Bundle.main.path(forResource: "WorkVariant", ofType: "txt")
            else{
            fatalError("file not found")
        }
        guard let arrayBeginNS = NSArray.init(contentsOfFile: path) else{
            fatalError("array dont init")
        }
        var i = 0
        for elementForItemOptional in arrayBeginNS{
            i += 1
            guard let elementForItem = elementForItemOptional as? Dictionary<String, Any> else { fatalError("dictionary dont uwriping")}
            let item: Item = Item.init(dictionarySource: elementForItem)
            self.arrayItems.append(item)
        }
    }
}
