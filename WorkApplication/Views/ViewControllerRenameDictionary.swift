//
//  ViewControllerRenameDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 22.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class ViewControllerRenameDictionary: UIViewController {

    @IBOutlet weak var buttonSaveBack: UIButton!
    @IBOutlet weak var textFieldOldName: UITextField!
    @IBOutlet weak var textFieldNewName: UITextField!
    @IBOutlet weak var buttonSaveNext: UIButton!
    @IBOutlet weak var labelEditNameDictionary: UILabel!
    @IBOutlet weak var labelOldName: UILabel!
    @IBOutlet weak var ladelNewLabel: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init ViewControllerRenameDictionary",self)
    }
    deinit {
        print("deinit ViewControllerRenameDictionary",self)
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

        self.buttonSaveNext.backgroundColor = ColorScheme.Shared.colorNDButtonContinueDontActive
        self.buttonSaveNext.setTitleColor(ColorScheme.Shared.colorNDButtonContinueText, for: .disabled)
        self.buttonSaveNext.setTitleColor(ColorScheme.Shared.colorNDButtonContinueText, for: .normal)

        self.buttonSaveBack.backgroundColor = ColorScheme.Shared.colorNDButtonContinueDontActive
        self.buttonSaveBack.setTitleColor(ColorScheme.Shared.colorNDButtonContinueText, for: .disabled)
        self.buttonSaveBack.setTitleColor(ColorScheme.Shared.colorNDButtonContinueText, for: .normal)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = ColorScheme.Shared.navigationBarBackgroundGray
        self.navigationController?.navigationBar.tintColor = ColorScheme.Shared.navigationBarText
    }
}
