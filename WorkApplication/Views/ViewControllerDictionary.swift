//
//  ViewControllerDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 23.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class ViewControllerDictionary: UIViewController {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init ViewControllerDictionary",self)
    }
    deinit {
        print("deinit ViewControllerDictionary",self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }
}
