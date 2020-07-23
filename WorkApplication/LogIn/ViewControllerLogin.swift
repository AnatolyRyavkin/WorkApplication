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

    var gradientLayer = CAGradientLayer()


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


        self.textFieldUsername.textColor = myColor(arColor: TextFieldTitleActive1)
        self.textFieldUsername.backgroundColor = myColor(arColor: TextFieldBackgroundActive1)

        self.buttonNext.backgroundColor = myColor(arColor: ControlBackgroundDontActive1)
        self.buttonNext.setTitleColor(myColor(arColor: ControlTitleDontActive1), for: .disabled)
        self.buttonNext.setTitleColor(myColor(arColor: ControlTitleActive1), for: .normal)

        self.buttonFindProfile.setTitleColor(myColor(arColor: LabelTitle2), for: .normal)

        self.pickerProfiles.tintColor = myColor(arColor: ControlTitleActive1)

        self.labelProfileUser.textColor = myColor(arColor: LabelTitle2)

        self.buttonCleanTextFieldUserNameAndRemoveUserObjectRealmIfExist.tintColor = myColor(arColor: LabelTitle2)

        self.gradientLayer.colors = [myColor(arColor: ViewBackground2).cgColor, myColor(arColor: ViewBackground1).cgColor]
        self.gradientLayer.locations = [0.0 , 1.0]
        self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.view.layer.insertSublayer(gradientLayer, at: 0)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super .viewWillTransition(to: size, with: coordinator)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = self.view.bounds
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = self.view.bounds
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

}
