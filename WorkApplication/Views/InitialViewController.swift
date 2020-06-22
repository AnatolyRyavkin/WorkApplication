//
//  ViewController.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 07.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit
import Foundation


class InitialViewController: UIViewController {

    deinit {
        print("deinit InitialViewController")
    }

    convenience init() {
        self.init(nibName:nil, bundle:nil)
        print("init InitialViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}

//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let sourceDataItems = DataItems.Shared.arrayItems
//
//        let modelRealm = RealmModel()
//        do{
//            try modelRealm.getBaseShared()
//        }catch{
//            print(error.localizedDescription)
//            return
//        }
//
//    }
//}

