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


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init ViewControllerLogin")
    }
    deinit {
        print("deinit ViewControllerLogin")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorScheme.Shared.colorLVCBackgroundShared

        self.textFieldUsername.textColor = ColorScheme.Shared.colorLVCTextFieldText
        self.textFieldUsername.backgroundColor = ColorScheme.Shared.colorLVCBackgroundTextField

        self.buttonNext.backgroundColor = ColorScheme.Shared.colorLVCButtonNextDontActive
        self.buttonNext.setTitleColor(ColorScheme.Shared.colorLVCButtonNextText, for: .disabled)
        self.buttonNext.setTitleColor(ColorScheme.Shared.colorLVCButtonNextText, for: .normal)

        self.buttonFindProfile.setTitleColor(ColorScheme.Shared.colorLVCButtonFindMyProfileText, for: .normal)

        self.pickerProfiles.tintColor = ColorScheme.Shared.colorLVCTextFieldText

        self.labelProfileUser.textColor = ColorScheme.Shared.colorLVCProfileUserLabelText

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

}
