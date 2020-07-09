//
//  ViewControllerDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 23.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class ViewControllerDictionary: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonVisual: UIButton!
    @IBOutlet weak var buttonWrite: UIButton!
    @IBOutlet weak var buttonVoice: UIButton!
    @IBOutlet weak var buttonPronons: UIButton!
    @IBOutlet weak var barButtonSearch: UIBarButtonItem!
    @IBOutlet weak var barButtonAdd: UIBarButtonItem!
    @IBOutlet weak var barButtonEdit: UIBarButtonItem!


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init ViewControllerDictionary",self)
    }
    deinit {
        print("deinit ViewControllerDictionary",self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
}
