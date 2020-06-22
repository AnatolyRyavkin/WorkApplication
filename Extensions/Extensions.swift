//
//  ExtensionUserDefaults.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 14.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit


extension Reactive where Base == UIViewController{

    private func controlEvent(for selector: Selector) -> ControlEvent<Void> {
        return ControlEvent(events: sentMessage(selector).map{ _ in})
    }

    public var viewWillAppear: ControlEvent<Void>{
        return controlEvent(for: #selector(UIViewController.viewWillAppear))
    }

    var viewDidAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidAppear))
    }

    var viewWillDisappear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillDisappear))
    }

    var viewDidDisappear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidDisappear))
    }


}

extension Reactive where Base == UITableView{
    var edit: Binder<Void>{ Binder.init(self.base) { (tableView, arg)  in
            tableView.setEditing(!tableView.isEditing, animated: true)
        }
    }
}

extension Reactive where Base == UITableView{
    var editAddItems: Binder<Void>{ Binder.init(self.base) { (tableView, arg)  in
            tableView.setEditing(!tableView.isEditing, animated: true)
        }
    }
}

extension UIView{
    func findCell() -> UITableViewCell?{
        if self.subviews.count > 0{
            for subView in self.subviews{
                if subView is UITableViewCell{
                    return subView as? UITableViewCell
                }else{
                    return subView.findCell()
                }
            }
        }
        return nil
    }
}

extension UserDefaults{

    func setLoggedIn(userName: String) {
        if(userName != ""){
            set(userName, forKey: userName)
            addUserInArrayUsers(userName: userName)
        }
    }

    func removeUser(userName: String) {
        removeObject(forKey: userName)
        if let array = readArrayUsers(){
            removeObject(forKey: "allUsers")
            set(array.map { $0 != userName }, forKey: "allUsers")
        }
    }

    func isLoggedIn(value: String) -> Bool {
        return bool(forKey: value)
    }

    func readLogged(forKey: String) -> String? {
        return string(forKey: forKey)
    }

    func getLastLoggedIn() -> String? {
        return string(forKey: "lastUser")
    }

    func setLastLoggedIn(userName: String){
        set(userName, forKey: "lastUser")
    }

    func readArrayUsers() -> Array<String>? {
        return stringArray(forKey: "allUsers")
    }

    func addUserInArrayUsers(userName: String) {
        var arrayUsers = Array<String>()
        if let array = readArrayUsers(){
            arrayUsers = array
        }
        arrayUsers.append(userName)
        removeObject(forKey: "allUsers")
        set(arrayUsers, forKey: "allUsers")
    }

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255

        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

}


