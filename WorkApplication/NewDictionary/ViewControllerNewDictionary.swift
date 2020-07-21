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

        self.view.backgroundColor = myColor(arColor: ViewBackground1)

        self.labelName.textColor = myColor(arColor: LabelTitle1)
        self.ladelType.textColor = myColor(arColor: LabelTitle1)
        self.labelYourNewDictionary.textColor = myColor(arColor: LabelTitle1)

        self.textFieldImputNameDictionary.backgroundColor = myColor(arColor: TextFieldBackgroundActive1)
        self.textFieldImputNameDictionary.textColor = myColor(arColor: TextFieldTitleActive1)

        self.buttonSaveNext.backgroundColor = myColor(arColor: ControlBackgroundDontActive1)
        self.buttonSaveNext.setTitleColor(myColor(arColor: ControlTitleDontActive1), for: .disabled)
        self.buttonSaveNext.setTitleColor(myColor(arColor: ControlTitleActive1), for: .normal)

        self.buttonSaveBack.backgroundColor = myColor(arColor: ControlBackgroundDontActive1)
        self.buttonSaveBack.setTitleColor(myColor(arColor: ControlTitleDontActive1), for: .disabled)
        self.buttonSaveBack.setTitleColor(myColor(arColor: ControlTitleActive1), for: .normal)

        self.segmentTypeDictionary.tintColor = myColor(arColor: TextFieldBackgroundActive1)
        self.segmentTypeDictionary.selectedSegmentTintColor = myColor(arColor: ControlBackgroundActive1)
        self.segmentTypeDictionary.backgroundColor = myColor(arColor: ControlBackgroundDontActive1)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = myColor(arColor: NavigationBarBackground1)
        self.navigationController?.navigationBar.tintColor = myColor(arColor: NavigationBarTitle1)
    }
    
}
