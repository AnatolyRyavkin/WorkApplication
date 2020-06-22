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
    @IBOutlet weak var labelYourNewDictionary: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var ladelType: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init MakeNewDictionaryViewController",self)
    }
    deinit {
        print("deinit MakeNewDictionaryViewController",self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorScheme.Shared.colorNDBackgroundShared

        self.labelName.textColor = ColorScheme.Shared.colorNDTitlesText
        self.ladelType.textColor = ColorScheme.Shared.colorNDTitlesText
        self.labelYourNewDictionary.textColor = ColorScheme.Shared.colorNDTitlesText

        self.textFieldImputTitle.backgroundColor = ColorScheme.Shared.colorNDBackgroundInputTitle
        self.textFieldImputTitle.textColor = ColorScheme.Shared.colorNDBInputTitle

        self.buttonContinue.backgroundColor = ColorScheme.Shared.colorNDButtonContinueDontActive
        self.buttonContinue.setTitleColor(ColorScheme.Shared.colorNDButtonContinueText, for: .disabled)
        self.buttonContinue.setTitleColor(ColorScheme.Shared.colorNDButtonContinueText, for: .normal)

        self.segmentTypeDictionary.tintColor = ColorScheme.Shared.colorNDSegmentText
        self.segmentTypeDictionary.selectedSegmentTintColor = ColorScheme.Shared.colorNDSegmentActive
        self.segmentTypeDictionary.backgroundColor = ColorScheme.Shared.colorNDSegmentBackground

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = ColorScheme.Shared.navigationBarBackgroundGray
        self.navigationController?.navigationBar.tintColor = ColorScheme.Shared.navigationBarText
    }
    
}
