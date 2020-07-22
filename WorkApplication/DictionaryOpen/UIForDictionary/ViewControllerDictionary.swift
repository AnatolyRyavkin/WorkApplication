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

    @IBOutlet weak var buttonReferensAPIYandex: UIButton!

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let attribute = [ NSAttributedString.Key.foregroundColor: myColor(arColor: LabelTitle2) ,
                          NSAttributedString.Key.font: FontForTable.Shared,
                          NSAttributedString.Key.underlineStyle : 1
            ] as [NSAttributedString.Key : Any]
        
        self.buttonReferensAPIYandex.titleLabel?.font = FontForTable.Shared
        self.buttonReferensAPIYandex.titleLabel?.lineBreakMode = .byWordWrapping
        let attributeString = NSAttributedString(string: "Реализовано с помощью сервиса «API «Яндекс.Словарь»",
                                                 attributes: attribute)
        self.buttonReferensAPIYandex.setAttributedTitle(attributeString, for: .normal)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLayoutSubviews()

        self.searchBar.returnKeyType = .search

        self.tableView?.backgroundView?.backgroundColor = myColor(arColor: ViewBackground1)
        self.view.backgroundColor = myColor(arColor: ViewBackground1)

        self.buttonVisual.backgroundColor = myColor(arColor: ControlBackgroundActive1)
        self.buttonVisual.setTitleColor(myColor(arColor: ControlTitleActive1), for: .normal)

        self.buttonWrite.backgroundColor = myColor(arColor: ControlBackgroundActive1)
        self.buttonWrite.setTitleColor(myColor(arColor: ControlTitleActive1), for: .normal)

        self.buttonVoice.backgroundColor = myColor(arColor: ControlBackgroundActive1)
        self.buttonVoice.setTitleColor(myColor(arColor: ControlTitleActive1), for: .normal)

        self.buttonPronons.backgroundColor = myColor(arColor: ControlBackgroundActive1)
        self.buttonPronons.setTitleColor(myColor(arColor: ControlTitleActive1), for: .normal)

        self.buttonAddWord.backgroundColor = myColor(arColor: ControlBackgroundActive1)
        self.buttonAddWord.setTitleColor(myColor(arColor: ControlTitleActive1), for: .normal)

        self.view.backgroundColor = myColor(arColor: ViewBackground1)
        self.tableView.backgroundColor = myColor(arColor: ViewBackground1)
        self.tableView.allowsSelectionDuringEditing = false

        self.navigationItem.setRightBarButtonItems([ self.barButtonEdit], animated: false)

        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = myColor(arColor: NavigationBarBackground1)
        self.navigationController?.navigationBar.tintColor = myColor(arColor: NavigationBarTitle1)

        if let navigationBar = self.navigationBar {
            let labelNavigationLabel = UILabel(frame: CGRect(x: navigationBar.frame.width/2 - navigationBar.frame.width/4, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height))
            labelNavigationLabel.textColor = myColor(arColor: NavigationBarTitle1)
            labelNavigationLabel.textAlignment = .center
            navigationBar.addSubview(labelNavigationLabel)
            self.labelNavigationLabel = labelNavigationLabel
        }
    }
}
