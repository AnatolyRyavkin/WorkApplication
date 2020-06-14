//
//  LoginViewController.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 14.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonFindProfile: UIButton!
    @IBOutlet weak var pickerProfiles: UIPickerView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init LoginViewController")
    }
    deinit {
        print("deinit LoginViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
