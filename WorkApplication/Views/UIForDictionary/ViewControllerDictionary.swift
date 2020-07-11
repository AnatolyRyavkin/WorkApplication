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
    @IBOutlet weak var barButtonEdit: UIBarButtonItem!

      //var barButtonAddDictionary: UIBarButtonItem!
      //var barButtonCancel: UIBarButtonItem!
      //var barButtonEdit: UIBarButtonItem!
      //var barButtonBackSistem: UIBarButtonItem!

      required init?(coder: NSCoder) {
            super.init(coder: coder)
            print("init ViewControllerDictionary",self)
        }
        deinit {
            print("deinit ViewControllerDictionary",self)
        }

      override func viewDidLoad() {
          super.viewDidLoad()

          self.view.backgroundColor = ColorScheme.Shared.colorBLCBackgroundShared
          self.tableView.backgroundColor = ColorScheme.Shared.colorBLCBackgroundShared
          self.tableView.allowsSelectionDuringEditing = false

          if self.navigationController != nil {
              self.navigationItem.setRightBarButtonItems([ self.barButtonEdit], animated: false)
              self.navigationController?.navigationBar.barTintColor = ColorScheme.Shared.navigationBarBackgroundBlue
              self.navigationController?.navigationBar.tintColor = ColorScheme.Shared.navigationBarText

          }

          let headerLabel = HeaderForTableViewListDictionaries.init(frame: CGRect.zero)
          headerLabel.configure(text: "Dictionary", sizeForFont: 20, color: ColorScheme.Shared.colorBLCTextTitle)
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
