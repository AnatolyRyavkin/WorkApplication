//
//  ViewControllerListDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class ViewControllerListDictionary: UIViewController {

    @IBOutlet weak var headerTableView: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var buttonAddDictionary: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var barButtonAddDictionary: UIBarButtonItem!
    var barButtonCancelProfile: UIBarButtonItem!
    var barButtonEdit: UIBarButtonItem!
    var labelNavigationItem: UILabel!

    var navigationBar: UINavigationBar!

   required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init ViewControllerListDictionary")
    }
    deinit {
        print("deinit ViewControllerListDictionary")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorScheme.Shared.colorBLCBackgroundShared
        self.tableView.backgroundColor = ColorScheme.Shared.colorBLCBackgroundShared
        self.tableView.allowsSelectionDuringEditing = true

        if let navigationController = self.navigationController {

            self.barButtonAddDictionary = UIBarButtonItem.init(barButtonSystemItem: .add, target: nil, action: nil)
            self.barButtonCancelProfile = UIBarButtonItem.init(title: "‹Profiles", style: .done, target: nil, action: nil)
            self.barButtonEdit = UIBarButtonItem.init(title: "Edit", style: .done, target: nil, action: nil)

            self.navigationItem.setRightBarButtonItems([self.barButtonAddDictionary, self.barButtonEdit], animated: false)
            self.navigationItem.setLeftBarButtonItems([self.barButtonCancelProfile, self.barButtonEdit], animated: false)
            self.navigationController?.navigationBar.barTintColor = ColorScheme.Shared.navigationBarBackgroundBlue
            self.navigationController?.navigationBar.tintColor = ColorScheme.Shared.navigationBarText

            self.navigationBar = navigationController.navigationBar
            self.labelNavigationItem = UILabel(frame: CGRect(x: navigationBar.frame.width/2 - navigationBar.frame.width/4, y: 0, width:navigationBar.frame.width/2, height: navigationBar.frame.height))
            labelNavigationItem.textColor = ColorScheme.Shared.navigationBarText

        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = ColorScheme.Shared.navigationBarBackgroundBlue
        self.navigationController?.navigationBar.tintColor = ColorScheme.Shared.navigationBarText

        //MARK- Header TableView Custom + Button

        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 2
        myShadow.shadowOffset = CGSize(width: 2, height: 2)
        myShadow.shadowColor = UIColor.gray

        let attribute = [ NSAttributedString.Key.foregroundColor: ColorScheme.Shared.colorBLCTextTitle ,
                          NSAttributedString.Key.font: UIFont(name: "Futura", size: 25.0)!,
                          NSAttributedString.Key.shadow: myShadow,
        ]

        var string = "Name"
        let attributeStringName = NSAttributedString(string: string, attributes: attribute)
        labelName.attributedText = attributeStringName

        string = "Type"
        let attributeStringType = NSAttributedString(string: string, attributes: attribute)
        labelType.attributedText = attributeStringType

        string = "Count"
        let attributeStringCount = NSAttributedString(string: string, attributes: attribute)
        labelCount.attributedText = attributeStringCount

        buttonAddDictionary.layer.cornerRadius = 18

        buttonAddDictionary.tintColor = ColorScheme.Shared.colorBLCCellSelected
        buttonAddDictionary.backgroundColor = ColorScheme.Shared.navigationBarBackgroundBlue

        self.headerTableView.backgroundColor = ColorScheme.Shared.colorBLCBackgroundTitleTable

        

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.labelNavigationItem.removeFromSuperview()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print(size)
        self.labelNavigationItem.frame =  CGRect(x: size.width/2 - size.width/4, y: 0, width: size.width/2, height: self.navigationBar.frame.height)
    }


}

