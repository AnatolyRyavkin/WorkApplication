//
//  MakeNewDictionaryViewController.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 13.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class MakeNewDictionaryViewController: UIViewController {


    @IBOutlet weak var textFieldImputTitle: UITextField!
    @IBOutlet weak var segmentTypeDictionary: UISegmentedControl!
    @IBOutlet weak var buttonContinue: UIButton!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init MakeNewDictionaryViewController")
    }
    deinit {
        print("deinit MakeNewDictionaryViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
}
