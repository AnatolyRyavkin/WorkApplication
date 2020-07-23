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

enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case phone
    case pad
}

struct ScreenSize {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenMaxLength = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let screenMinLength = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

struct DeviceType {
    static let iPhone4OrLess  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength < 568.0
    static let iPhoneSE = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 568.0
    static let iPhone8 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 667.0
    static let iPhone8Plus = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 736.0
    static let iPhoneXrOr11 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 896.0
    static let iPhoneXs = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 812.0
    static let iPhoneXsMax = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 896.0
    static let iPhone11Pro = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 1125.0
    static let iPhone11ProMax = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 1242.0

    static let iPad = UIDevice.current.userInterfaceIdiom == .pad
}

public struct FontForTable {

    let a = 0

    static let fontUserCustom: UIFont? = nil

    static let fontFuturaLitle = UIFont.init(name: "Futura", size: 15)!
    static let fontFuturaMidle = UIFont.init(name: "Futura", size: 20)!
    static let fontFuturaBig = UIFont.init(name: "Futura", size: 25)!
    static let fontSistemLitle = UIFont.init(name: "Arial", size: 15)!
    static let fontSistemMidle = UIFont.init(name: "Arial", size: 20)!
    static let fontSistemBig = UIFont.init(name: "Arial", size: 25)!

    static var Shared: UIFont {
        if let fontUserCustom = fontUserCustom {
            return fontUserCustom
        } else {
            if DeviceType.iPad {
                return fontFuturaBig
            }
            if DeviceType.iPhone4OrLess {
                return fontSistemLitle
            }
        }
        return fontFuturaMidle
    }
}

public var FontForTables: UIFont!

enum TranslationDirection: String{
    case EnRu = "en-ru"
    case RuEn = "ru-en"
    case testError = "testError"

    init(typeString: String) {
        switch typeString {
        case "en-ru":
            self = .EnRu
        case "ru-en":
            self = .RuEn
        default:
            self = .testError
        }
    }
}

typealias Res = Result<(Data,HTTPURLResponse),Error>

public enum ErrorForGetRequestAPIYandex: Error, CaseIterable{

//MARK- Errors work with YandexAPI

    case ERR_OK
    case ERR_KEY_INVALID
    case ERR_KEY_BLOCKED
    case ERR_DAILY_REQ_LIMIT_EXCEEDED
    case ERR_TEXT_TOO_LONG
    case ERR_LANG_NOT_SUPPORTED

    case ERR_DONT_PARSING_WORD_OBJECT_REALM
    case ERR_DONT_GET_WORD_CODABLE_JSON
    case ERR_DONT_ADD_WORD_IN_DICTIONARY

    case ERR_SERVER_DONT_AVIALABLE
    case ERR_UNKNOWN

    case BAD_REQUEST
    case NOT_FOUND
    case DONT_INTERNET

//MARK- Internal Errors

    case AlREADY_EXIST_TO_BASE_SAME_DICTIONARY_FOR_THIS_USER

    var discript: (num: Int, nameError: String){
        switch self {
        case .ERR_OK :  return (200, "ERR_OK")
        case .ERR_KEY_INVALID : return (401, "ERR_KEY_INVALID")
        case .ERR_KEY_BLOCKED : return (402, "ERR_KEY_BLOCKED")
        case .ERR_DAILY_REQ_LIMIT_EXCEEDED : return (403, "ERR_DAILY_REQ_LIMIT_EXCEEDED")
        case .ERR_TEXT_TOO_LONG : return (413, "ERR_TEXT_TOO_LONG")
        case .ERR_LANG_NOT_SUPPORTED : return (501, "ERR_LANG_NOT_SUPPORTED")
        case .ERR_DONT_PARSING_WORD_OBJECT_REALM : return (001, "ERR_DONT_PARSING_WORD_OBJECT_REALM")
        case .ERR_DONT_GET_WORD_CODABLE_JSON : return (002, "ERR_DONT_GET_WORD_CODABLE_JSON")
        case .ERR_UNKNOWN : return (003, "ERR_UNKNOWN")
        case .ERR_SERVER_DONT_AVIALABLE : return (005, "ERR_SERVER_DONT_AVIALABLE")
        case .BAD_REQUEST : return (400, "BAD_REQUEST")
        case .NOT_FOUND : return (404, "NOT_FOUND")
        case .DONT_INTERNET : return (700, "DONT_INTERNET")
        case .ERR_DONT_ADD_WORD_IN_DICTIONARY : return (004, "ERR_DONT_ADD_WORD_IN_DICTIONARY")

        case .AlREADY_EXIST_TO_BASE_SAME_DICTIONARY_FOR_THIS_USER : return (006, "AlREADY_EXIST_TO_BASE_SAME_DICTIONARY_FOR_THIS_USER")

        }
    }

    static func makeSelfAtCode(code: Int) -> ErrorForGetRequestAPIYandex {
        for meaning in ErrorForGetRequestAPIYandex.allCases{
            if meaning.discript.num == code{
                return meaning
            }
        }
        return .ERR_UNKNOWN
    }

}

enum MyResponse{
    case success(WordObjectRealm)
    case failure(ErrorForGetRequestAPIYandex)
}


//MARK- UITextField

public extension UITextField
{
    override var textInputMode: UITextInputMode?
    {
        let locale = Locale(identifier: "en_US") // your preferred locale

        return
            UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == locale.languageCode })
            ??
            super.textInputMode
    }
}

//MARK- UISearchBAr

public extension UISearchBar
{
    override var textInputMode: UITextInputMode?
    {
        let locale = Locale(identifier: "en_US") // your preferred locale

        return
            UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == locale.languageCode })
            ??
            super.textInputMode
    }
}

//extension UISearchBar {
//    var textField: UITextField? {
//        return subviews.map { $0.subviews.first(where: { $0 is UITextInputTraits}) as? UITextField }
//            .compactMap { $0 }
//            .first
//    }
//}

//MARK- RX

extension Reactive where Base == UITableView{
    public var isEdit: ControlEvent<Bool>{
        return ControlEvent.init(events: sentMessage(#selector(UITableView.setEditing))
            .map{arrayAnyNewMeaningAndOldMeaning in
                let arrayIntNewMeaningAndOldMeaning = arrayAnyNewMeaningAndOldMeaning as! Array<Int>
                return (arrayIntNewMeaningAndOldMeaning[0] == 0) ? false : true })
    }
}

extension Reactive where Base == UIViewController{

    private func controlEvent(for selector: Selector) -> ControlEvent<Void> {
        return ControlEvent(events: sentMessage(selector).map{ _ in})
    }

    public var viewDidLoad: ControlEvent<Void>{
        return controlEvent(for: #selector(UIViewController.viewDidLoad))
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

    var viewDidLayoutSubviews: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidLayoutSubviews))
    }
}

extension Reactive where Base == UITextField {
    public var bindText: Binder<String> {
        return Binder.init(self.base) { (textFieldSelf, string) in
            textFieldSelf.text = string
        }
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

//MARK- UIView

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


extension UIView{
    func findViewUITextField() -> UITextField? {
        if self.subviews.count > 0{
            for subView in self.subviews{
                if subView is UITextField{
                    return subView as? UITextField
                }else{
                    return subView.findViewUITextField()
                }
            }
        }
        return nil
    }
}


//MARK- UserDefaults

extension UserDefaults{

    func getCurrentUserName() -> UserObjectRealm? {
        let allUserObjects = RealmUser.shared.realmUser.objects(UserObjectRealm.self)
        if let userName = string(forKey: "lastUser") {
            let r = allUserObjects.filter("userName == %@", userName)
            let rw = r.first
            return rw
        }
        return nil
     }

    func setCurrentUserName(userObject: UserObjectRealm?) {
        if let userObject = userObject {
            set(userObject.userName, forKey: "lastUser")
        } else {
            removeObject(forKey: "lastUser")
        }

    }

    func cleanUserDefault(){
        removeObject(forKey: "lastUser")
    }
}

//
//
////MARK- token

extension UserDefaults{
    func setToken(token: String?) {
        set(token, forKey: "token")
    }

    func getToken() -> String?{
        return string(forKey: "token")
    }

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

//MARK- HTTPURLResponse

public extension HTTPURLResponse {
    func valueForHeaderField(_ headerField: String) -> String? {
        if #available(iOS 13.0, *) {
            return value(forHTTPHeaderField: headerField)
        } else {
            return (allHeaderFields as NSDictionary)[headerField] as? String
        }
    }
}

//MARK- URLSession




public enum Result<Success, Failure> where Failure : Error {
    case success(Success)
    case failure(Failure)
}



extension URLSession {

    public func dataTaskMy(with requestMy: URLRequest, completionHandlerMy: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> URLSessionDataTask {
        
        return dataTask(with: requestMy, completionHandler: { (data, urlResponse, error) in
            if let error = error {
                completionHandlerMy(.failure(error))
            } else if let data = data, let urlResponse = urlResponse as? HTTPURLResponse {
                completionHandlerMy(.success((data, urlResponse)))
            }
        })
    }

    public func dataTaskMy(with url: URL, completionHandlerMy: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> URLSessionDataTask {

        return dataTask(with: url, completionHandler: { (data, urlResponse, error) in
            if let error = error {
                completionHandlerMy(.failure(error))
            } else if let data = data, let urlResponse = urlResponse as? HTTPURLResponse {
                completionHandlerMy(.success((data, urlResponse)))
            }
        })
    }

}


//MARK- Error

extension Error {
    func myError() -> ErrorForGetRequestAPIYandex {
        guard let er = self as? ErrorForGetRequestAPIYandex else {
            return ErrorForGetRequestAPIYandex.ERR_UNKNOWN
        }
        return er
    }
}





