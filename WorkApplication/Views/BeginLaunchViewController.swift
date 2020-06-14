//
//  BeginLaunchViewController.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class BeginLaunchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var barButtonAddDictionary: UIBarButtonItem!
    var barButtonCancel: UIBarButtonItem!
    //var barButtonBackSistem: UIBarButtonItem!

   required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init BeginLaunchViewController")
    }
    deinit {
        print("deinit BeginLaunchViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.navigationController != nil {

            self.barButtonAddDictionary = UIBarButtonItem.init(barButtonSystemItem: .add, target: nil, action: nil)
            self.barButtonCancel = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: nil, action: nil)
            self.navigationItem.title = "My Dictionaries"
            self.navigationItem.setRightBarButtonItems([self.barButtonAddDictionary, self.barButtonCancel], animated: false)

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}
