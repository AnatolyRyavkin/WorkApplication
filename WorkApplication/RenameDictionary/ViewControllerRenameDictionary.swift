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

    var gradientLayer = CAGradientLayer()
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init ViewControllerRenameDictionary",self)
    }
    deinit {
        print("deinit ViewControllerRenameDictionary",self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = myColor(arColor: ViewBackground1)


        self.labelEditNameDictionary.textColor = myColor(arColor: LabelTitle1)
        self.labelOldName.textColor = myColor(arColor: LabelTitle1)
        self.ladelNewLabel.textColor = myColor(arColor: LabelTitle1)

        self.textFieldOldName.backgroundColor = myColor(arColor: TextFieldBackgroundActive1)
        self.textFieldOldName.textColor = myColor(arColor: TextFieldTitleActive1)

        self.textFieldNewName.backgroundColor = myColor(arColor: TextFieldBackgroundActive1)
        self.textFieldNewName.textColor = myColor(arColor: TextFieldTitleActive1)

        self.buttonSaveNext.backgroundColor = myColor(arColor: ControlBackgroundDontActive1)
        self.buttonSaveNext.setTitleColor(myColor(arColor: ControlTitleDontActive1), for: .disabled)
        self.buttonSaveNext.setTitleColor(myColor(arColor: ControlTitleActive1), for: .normal)

        self.buttonSaveBack.backgroundColor = myColor(arColor: ControlBackgroundDontActive1)
        self.buttonSaveBack.setTitleColor(myColor(arColor: ControlTitleDontActive1), for: .disabled)
        self.buttonSaveBack.setTitleColor(myColor(arColor: ControlTitleActive1), for: .normal)

        self.gradientLayer.colors = [myColor(arColor: ControlBackgroundActive2).cgColor, myColor(arColor: ViewBackground1).cgColor]
        self.gradientLayer.locations = [0.0 , 1.0]
        self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.view.layer.insertSublayer(gradientLayer, at: 0)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = myColor(arColor: NavigationBarBackground1)
        self.navigationController?.navigationBar.tintColor = myColor(arColor: NavigationBarTitle1)
    }

    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           gradientLayer.frame = self.view.bounds
       }

       override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()
           gradientLayer.frame = self.view.bounds
       }

}
