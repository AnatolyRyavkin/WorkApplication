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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonAddDictionary: UIButton!

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

        self.view.backgroundColor = myColor(arColor: ViewBackground1)

        //setGradient(gradientView: self.view, color1: myColor(arColor: ControlBackgroundActive2), color2: myColor(arColor: ViewBackground1))

        self.tableView.backgroundColor = myColor(arColor: ViewBackground1)

        self.tableView.allowsSelectionDuringEditing = true

        if let navigationController = self.navigationController {

            self.barButtonAddDictionary = UIBarButtonItem.init(barButtonSystemItem: .add, target: nil, action: nil)


            self.barButtonCancelProfile = UIBarButtonItem.init(title: "‹Profiles", style: .done, target: nil, action: nil)
            self.barButtonEdit = UIBarButtonItem.init(title: "Edit", style: .done, target: nil, action: nil)

            self.navigationItem.setRightBarButtonItems([self.barButtonAddDictionary, self.barButtonEdit], animated: false)
            self.navigationItem.setLeftBarButtonItems([self.barButtonCancelProfile, self.barButtonEdit], animated: false)
            self.navigationController?.navigationBar.barTintColor = myColor(arColor: NavigationBarBackground1)
            self.navigationController?.navigationBar.tintColor = myColor(arColor: NavigationBarBackground1)

            self.navigationBar = navigationController.navigationBar
            self.labelNavigationItem = UILabel(frame: CGRect(x: navigationBar.frame.width/2 - navigationBar.frame.width/4, y: 0, width:navigationBar.frame.width/2, height: navigationBar.frame.height))
            labelNavigationItem.textColor = myColor(arColor: NavigationBarTitle1)

        }


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = myColor(arColor: NavigationBarBackground1)
        self.navigationController?.navigationBar.tintColor = myColor(arColor: NavigationBarTitle1)

        //MARK- Header TableView Custom + Button

        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 1
        myShadow.shadowOffset = CGSize(width: 1, height: 1)
        myShadow.shadowColor = UIColor.gray

        let attribute = [ NSAttributedString.Key.foregroundColor: myColor(arColor: LabelTitle1) ,
                          NSAttributedString.Key.font: FontForTable.Shared,
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

        buttonAddDictionary.tintColor = myColor(arColor: ControlTitleActive1)
        buttonAddDictionary.backgroundColor = myColor(arColor: ControlBackgroundActive2)

        self.headerTableView.backgroundColor = myColor(arColor: ViewBackground1)


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

