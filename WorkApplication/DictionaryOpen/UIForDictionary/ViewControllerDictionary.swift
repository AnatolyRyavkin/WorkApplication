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
    @IBOutlet weak var buttonAddWord: UIButton!
    
    @IBOutlet weak var barButtonEdit: UIBarButtonItem!
    @IBOutlet weak var barButtonSearch: UIBarButtonItem!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var buttonSearhVoice: UIButton!

    @IBOutlet weak var constraintEqualHeightButtonAddWithSearch: NSLayoutConstraint!
    @IBOutlet weak var constraintZeroHeightSearch: NSLayoutConstraint!


    var navigationBar: UINavigationBar? {
        return self.navigationController?.navigationBar
    }

    var labelNavigationLabel: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init ViewControllerDictionary",self)
    }
    deinit {
        print("deinit ViewControllerDictionary",self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBar.returnKeyType = .search

        self.view.backgroundColor = ColorScheme.Shared.colorBLCBackgroundShared
        self.tableView.backgroundColor = ColorScheme.Shared.colorBLCBackgroundShared
        self.tableView.allowsSelectionDuringEditing = false

        if self.navigationController != nil {
            self.navigationItem.setRightBarButtonItems([ self.barButtonEdit], animated: false)
            self.navigationController?.navigationBar.barTintColor = ColorScheme.Shared.navigationBarBackgroundBlue
            self.navigationController?.navigationBar.tintColor = ColorScheme.Shared.navigationBarText
        }

        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = ColorScheme.Shared.navigationBarBackgroundBlue
        self.navigationController?.navigationBar.tintColor = ColorScheme.Shared.navigationBarText

        if let navigationBar = self.navigationBar {
            let labelNavigationLabel = UILabel(frame: CGRect(x: navigationBar.frame.width/2 - navigationBar.frame.width/4, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height))
            labelNavigationLabel.textColor = ColorScheme.Shared.navigationBarText
            labelNavigationLabel.textAlignment = .center
            navigationBar.addSubview(labelNavigationLabel)
            self.labelNavigationLabel = labelNavigationLabel
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.labelNavigationLabel.removeFromSuperview()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.labelNavigationLabel.frame =  CGRect(x: size.width/2 - size.width/4, y: 0, width: size.width/2, height: self.navigationBar!.frame.height)
    }


    //MARK- Appear disAppear SearchBar

    func showSearchBarWithAnimation(durationAnimation: Float) {
        UIView.animate(withDuration: TimeInterval(durationAnimation)) {
            self.constraintZeroHeightSearch.priority = .defaultLow
            self.constraintEqualHeightButtonAddWithSearch.priority = .required
            self.searchBar.becomeFirstResponder()
            self.view.layoutIfNeeded()
        }
    }

    func showSearchBarWithoutAnimation() {
        self.showSearchBarWithAnimation(durationAnimation: 0)
    }

    func hiddenSearchBarWithAnimation(durationAnimation: Float) {
        UIView.animate(withDuration: TimeInterval(durationAnimation)) {
            self.constraintZeroHeightSearch.priority = .required
            self.constraintEqualHeightButtonAddWithSearch.priority = .defaultLow
            self.searchBar.resignFirstResponder()
            self.view.layoutIfNeeded()
        }
    }

    func hiddenSearchBarWithoutAnimation() {
        self.hiddenSearchBarWithAnimation(durationAnimation: 0)
    }

}
