//
//  DataItems.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 07.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation

class DataItems {

    static var Shared = DataItems()
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
            if i == 40000{ return }
            guard let elementForItem = elementForItemOptional as? Dictionary<String, Any> else { fatalError("dictionary dont uwriping")}
            let item: Item = Item.init(dictionarySource: elementForItem)
            self.arrayItems.append(item)

            if ProcessInfo.processInfo.arguments.contains("PRINTDATA") {
                //print(" \n \n ===================== SOURCE ======================  \n ")
                //print(elementForItem)
                print(" \n \n ++++++++++++++++++++++ ITEM +++++++++++++++++++++++  \n ")
                item.printSelf()
            }
        }
    }
}
