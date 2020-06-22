//
//  CoordinatorOpenDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 22.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class CoordinatorChangeTitleDictionary: CoordinatorProtocol {

    var dictionaryChange: DictionaryObject

    init(dictionaryChange: DictionaryObject) {
        self.dictionaryChange = dictionaryChange
    }

    func start(from nc: UINavigationController) -> Observable<Void> {
        <#code#>
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from nc: UINavigationController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        <#code#>
    }


}
