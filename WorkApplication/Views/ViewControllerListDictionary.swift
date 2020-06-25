//
//  ViewControllerListDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 16.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class ViewControllerListDictionary: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var barButtonAddDictionary: UIBarButtonItem!
    //var barButtonCancel: UIBarButtonItem!
    var barButtonEdit: UIBarButtonItem!
    //var barButtonBackSistem: UIBarButtonItem!

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

        if self.navigationController != nil {

            self.barButtonAddDictionary = UIBarButtonItem.init(barButtonSystemItem: .add, target: nil, action: nil)
            //self.barButtonCancel = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: nil, action: nil)
            self.barButtonEdit = UIBarButtonItem.init(title: "Edit", style: .done, target: nil, action: nil)
            self.navigationItem.setRightBarButtonItems([self.barButtonAddDictionary, self.barButtonEdit], animated: false)
            self.navigationController?.navigationBar.barTintColor = ColorScheme.Shared.navigationBarBackgroundBlue
            self.navigationController?.navigationBar.tintColor = ColorScheme.Shared.navigationBarText
            
        }
        let headerLabel = HeaderForTableViewListDictionaries.init(frame: CGRect.zero)
        headerLabel.configure(text: "My Dictionaries", sizeForFont: 20, color: ColorScheme.Shared.colorBLCTextTitle)
        self.tableView.tableHeaderView = headerLabel
        self.tableView.tableHeaderView?.backgroundColor = ColorScheme.Shared.colorBLCBackgroundTitleTable
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = ColorScheme.Shared.navigationBarBackgroundBlue
        self.navigationController?.navigationBar.tintColor = ColorScheme.Shared.navigationBarText
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderViewHeight(for: tableView.tableHeaderView)
    }

    

    func updateHeaderViewHeight(for header: UIView?) {
        guard let header = header else { return }
        //header.frame.size.height = header.systemLayoutSizeFitting(CGSize(width: view.bounds.width - 32.0, height: 0)).height
        header.frame.size.height = 25
    }
}

