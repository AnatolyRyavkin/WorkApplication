//
//  ViewControllerDictionary.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 23.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewControllerDictionary: UIViewController {

    var disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var barButtonAdd: UIBarButtonItem!
    @IBOutlet weak var buttonEdit: UIButton!

    @IBOutlet weak var buttonReferensAPIYandex: UIButton!

    @IBOutlet weak var buttonLearnWords: UIButton!


    @IBOutlet weak var buttonSearch: UIButton!

    @IBOutlet weak var viewForSearchBar: UIView!
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


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewForSearchBar.backgroundColor = myColor(arColor: ViewBackground2)
        searchBar.barTintColor = myColor(arColor: ViewBackground2)
        searchBar.tintColor = myColor(arColor: ViewBackground2)
        searchBar.searchTextField.backgroundColor = myColor(arColor: TextFieldBackgroundActive1)
        searchBar.searchTextField.tintColor = myColor(arColor: TextFieldTitleActive1)

        self.buttonSearhVoice.backgroundColor = myColor(arColor: ViewBackground2)
        self.buttonSearhVoice.tintColor = myColor(arColor: ControlTitleActive2)

        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.backgroundColor = myColor(arColor: ViewBackground2)
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.setTitleColor(myColor(arColor: ControlTitleActive3), for: .normal)
        }
        searchBar.searchTextField.layer.cornerRadius = 15
        self.buttonSearhVoice.setTitleColor(myColor(arColor: ControlTitleActive4), for: .normal)

        self.tableView.sectionHeaderHeight = 15

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBar.returnKeyType = .search

        self.tableView?.backgroundView?.backgroundColor = myColor(arColor: ViewBackground1)
        self.view.backgroundColor = myColor(arColor: ViewBackground1)


        self.view.backgroundColor = myColor(arColor: ViewBackground1)
        self.tableView.backgroundColor = myColor(arColor: ViewBackground1)
        self.tableView.allowsSelectionDuringEditing = false
        
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


        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 1
        myShadow.shadowOffset = CGSize(width: 1, height: 1)
        myShadow.shadowColor = UIColor.gray

        let attributeEdit = [ NSAttributedString.Key.foregroundColor: myColor(arColor: LabelTitle4) ,
                          NSAttributedString.Key.font: FontForTable.fontFuturaMidle,
                          NSAttributedString.Key.shadow: myShadow,
        ]

        var string = "Edit"
        let attributeStringEdit = NSAttributedString(string: string, attributes: attributeEdit)
        self.buttonEdit.setAttributedTitle(attributeStringEdit, for: .normal)

        let attributeMyWords = [ NSAttributedString.Key.foregroundColor: myColor(arColor: ControlTitleActive5) ,
                          NSAttributedString.Key.font: FontForTable.fontFuturaBig,
                          NSAttributedString.Key.shadow: myShadow,
        ]

        string = "Start!"
        let attributeStringMyWords = NSAttributedString(string: string, attributes: attributeMyWords)
        self.buttonLearnWords.setAttributedTitle(attributeStringMyWords, for: .normal)

        self.buttonReferensAPIYandex.titleLabel?.font = FontForTable.Shared
        self.buttonReferensAPIYandex.titleLabel?.lineBreakMode = .byWordWrapping
        let attributeButtonReferensAPIYandex = [ NSAttributedString.Key.foregroundColor: myColor(arColor: LabelTitle4) ,
                          NSAttributedString.Key.font: FontForTable.fontFuturaMidle,
        ]
        string = "Реализовано с помощью сервиса «API «Яндекс.Словарь»"
        let attributeStringButtonReferensAPIYandex = NSAttributedString(string: string, attributes: attributeButtonReferensAPIYandex)
        self.buttonReferensAPIYandex.setAttributedTitle(attributeStringButtonReferensAPIYandex, for: .normal)

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
