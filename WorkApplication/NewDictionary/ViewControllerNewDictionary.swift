//
//  ViewControllerNewDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 13.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class ViewControllerNewDictionary: UIViewController {

    @IBOutlet weak var textFieldImputNameDictionary: UITextField!
    @IBOutlet weak var segmentTypeDictionary: UISegmentedControl!
    @IBOutlet weak var buttonSaveBack: UIButton!
    @IBOutlet weak var buttonSaveNext: UIButton!
    @IBOutlet weak var labelYourNewDictionary: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var ladelType: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init ViewControllerNewDictionary",self)
    }
    deinit {
        print("deinit ViewControllerNewDictionary",self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorScheme.Shared.colorNDBackgroundShared

        self.labelName.textColor = ColorScheme.Shared.colorNDTitlesText
        self.ladelType.textColor = ColorScheme.Shared.colorNDTitlesText
        self.labelYourNewDictionary.textColor = ColorScheme.Shared.colorNDTitlesText

        self.textFieldImputNameDictionary.backgroundColor = ColorScheme.Shared.colorNDBackgroundInputTitle
        self.textFieldImputNameDictionary.textColor = ColorScheme.Shared.colorNDBInputTitle

        self.buttonSaveNext.backgroundColor = ColorScheme.Shared.colorNDButtonContinueDontActive
        self.buttonSaveNext.setTitleColor(ColorScheme.Shared.colorNDButtonContinueText, for: .disabled)
        self.buttonSaveNext.setTitleColor(ColorScheme.Shared.colorNDButtonContinueText, for: .normal)

        self.buttonSaveBack.backgroundColor = ColorScheme.Shared.colorNDButtonContinueDontActive
        self.buttonSaveBack.setTitleColor(ColorScheme.Shared.colorNDButtonContinueText, for: .disabled)
        self.buttonSaveBack.setTitleColor(ColorScheme.Shared.colorNDButtonContinueText, for: .normal)

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
