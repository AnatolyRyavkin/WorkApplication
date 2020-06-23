//
//  ChangeTitleDictionaryViewController.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 22.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class ChangeTitleDictionaryViewController: UIViewController {

    @IBOutlet weak var textFieldOldName: UITextField!
    @IBOutlet weak var textFieldNewName: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var labelEditNameDictionary: UILabel!
    @IBOutlet weak var labelOldName: UILabel!
    @IBOutlet weak var ladelNewLabel: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init ChangeTitleDictionaryViewController",self)
    }
    deinit {
        print("deinit ChangeTitleDictionaryViewController",self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorScheme.Shared.colorNDBackgroundShared

        self.labelEditNameDictionary.textColor = ColorScheme.Shared.colorNDTitlesText
        self.labelOldName.textColor = ColorScheme.Shared.colorNDTitlesText
        self.ladelNewLabel.textColor = ColorScheme.Shared.colorNDTitlesText

        self.textFieldOldName.backgroundColor = ColorScheme.Shared.colorNDBackgroundInputTitle
        self.textFieldOldName.textColor = ColorScheme.Shared.colorNDBInputTitle

        self.textFieldNewName.backgroundColor = ColorScheme.Shared.colorNDBackgroundInputTitle
        self.textFieldNewName.textColor = ColorScheme.Shared.colorNDBInputTitle

        self.buttonSave.backgroundColor = ColorScheme.Shared.colorNDButtonContinueDontActive
        self.buttonSave.setTitleColor(ColorScheme.Shared.colorNDButtonContinueText, for: .disabled)
        self.buttonSave.setTitleColor(ColorScheme.Shared.colorNDButtonContinueText, for: .normal)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = ColorScheme.Shared.navigationBarBackgroundGray
        self.navigationController?.navigationBar.tintColor = ColorScheme.Shared.navigationBarText
    }
}
