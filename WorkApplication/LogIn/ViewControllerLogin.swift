//
//  ViewControllerLogin.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 14.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class ViewControllerLogin: UIViewController {

    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonFindProfile: UIButton!
    @IBOutlet weak var pickerProfiles: UIPickerView!
    @IBOutlet weak var labelProfileUser: UILabel!
    @IBOutlet weak var buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist: UIButton!


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init ViewControllerLogin")
    }
    deinit {
        print("deinit ViewControllerLogin")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.backgroundColor = myColor(arColor: ViewBackground2)

        setGradient(gradientView: self.view, color1: myColor(arColor: ControlBackgroundActive2), color2: myColor(arColor: ViewBackground1))

        self.textFieldUsername.textColor = myColor(arColor: TextFieldTitleActive1)
        self.textFieldUsername.backgroundColor = myColor(arColor: TextFieldBackgroundActive1)

        self.buttonNext.backgroundColor = myColor(arColor: ControlBackgroundDontActive1)
        self.buttonNext.setTitleColor(myColor(arColor: ControlTitleDontActive1), for: .disabled)
        self.buttonNext.setTitleColor(myColor(arColor: ControlTitleActive1), for: .normal)

        self.buttonFindProfile.setTitleColor(myColor(arColor: LabelTitle2), for: .normal)

        self.pickerProfiles.tintColor = myColor(arColor: ControlTitleActive1)

        self.labelProfileUser.textColor = myColor(arColor: LabelTitle2)

        self.buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist.tintColor = myColor(arColor: LabelTitle2)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

}
