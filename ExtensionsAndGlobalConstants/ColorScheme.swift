//
//  Constants.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 20.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import UIKit

public enum ColorSchemeOption {
    case light, dark, alt
}

var schemaColor: ColorSchemeOption = ColorSchemeOption.dark

public typealias ARColorSet = (light: UIColor, dark: UIColor, alt: UIColor)

// light

public let purple1 =   UIColor.init(hexString: "7C10F5")    // фиолетовый dark
public let purple2 =   UIColor.init(hexString: "6666FF")    // фиолетовый light
public let purple3 = UIColor.init(hexString: "6666FF")      // фиолетовый midl
public let black1 =    UIColor.init(hexString: "000000")    // черный
public let white1 =    UIColor.init(hexString: "FFFFFF")    // белый
public let gray1 =     UIColor.init(hexString: "F2F2F2")    // серый light
public let gray2 =     UIColor.init(hexString: "D3D3D3")    // серый
public let gray3 =     UIColor.init(hexString: "A6B0BC")    // серый
public let gray4 =     UIColor.init(hexString: "778899")    // серый dark

public let indigo =     UIColor.init(hexString: "#4D54D8")   // indigo
public let indigo2 =     UIColor.init(hexString: "#100873")   // indigo


public let ControlBackgroundActive1 = (indigo,indigo,indigo)
//public let ControlBackgroundActive2 = (orange1,purple1,orange1)
//public let ControlBackgroundActive3 = (orange1,purple1,orange1)

public let ControlBackgroundDontActive1 = (gray4,gray4,gray4)
//public let ControlBackgroundDontActive2 = (gray1,gray2,gray2)
//public let ControlBackgroundDontActive3 = (gray1,gray2,gray2)

public let ControlTitleActive1 = (gray2,gray2,gray2)
//public let ControlTitleActive2 = (gray3,blue1,gray2)
//public let ControlTitleActive3 = (black1,white1,gray2)

public let ControlTitleDontActive1 = (gray3,gray3,gray3)
//public let ControlTitleDontActive2 = (black1,gray3,gray3)
//public let ControlTitleDontActive3 = (black1,gray3,gray3)

public let LabelBackground1 = (gray3,gray3,gray3)
//public let LabelBackground2 = (white1,blue1,gray2)
//public let LabelBackground3 = (white1,blue1,gray2)

public let LabelTitle1 = (black1,black1,black1)
public let LabelTitle2 = (indigo2,indigo2,indigo2)               // TitleLabel
//public let LabelTitle3 = (black1,white1,gray2)


public let TextFieldBackgroundActive1 = (gray2,gray2,gray2)
//public let TextFieldBackgroundActive2 = (white1,blue1,gray2)
//public let TextFieldBackgroundActive3 = (white1,blue1,gray2)

public let TextFieldBackgroundDontActive1 = (gray2,gray2,gray2)
//public let TextFieldBackgroundDontActive2 = (white1,blue1,gray2)
//public let TextFieldBackgroundDontActive3 = (white1,blue1,gray2)

public let TextFieldTitleActive1 = (black1,black1,black1)
//public let TextFieldTitleActive2 = (blue1,gray3,gray2)
//public let TextFieldTitleActive3 = (white1,blue1,gray2)

public let TextFieldTitleDontActive1 = (black1,black1,black1)
//public let TextFieldTitleDontActive2 = (white1,blue1,gray2)
//public let TextFieldTitleDontActive3 = (white1,blue1,gray2)

public let ViewBackground1 = (gray3,gray3,gray3)
public let ViewBackground2 = (gray3,gray3,gray3)   // launch View
//public let ViewBackground3 = (purple1,gray1,gray2)

public let NavigationBarBackground1 = (indigo,indigo,indigo)
//public let NavigationBarBackground2 = (orange1,gray1,gray2)
//public let NavigationBarBackground3 = (purple1,gray1,gray2)

public let NavigationBarTitle1 = (gray2,gray2,gray2)
//public let NavigationBarTitle2 = (purple1,purple2,gray2)
//public let NavigationBarTitle3 = (purple1,gray1,gray2)


public func myColor(arColor: ARColorSet) -> UIColor {
    switch schemaColor {
    case .light: return arColor.light
    case .dark: return arColor.dark
    case .alt: return arColor.alt
    }
}






//public let gray2 = UIColor.init(hexString: "778899") // серый+
//public let blue2 = UIColor.init(hexString: "0000FF") // синий+
//public let gray1 = UIColor.init(hexString: "A6B0BC") // серый
//public let purple2 = UIColor.init(hexString: "D0D0FF") // фиолетовый +
//public let gray3 = UIColor.init(hexString: "D3D3D3") // серый ++
//public let blue1 = UIColor.init(hexString: "00007F") // синий
//public let orange1 = UIColor.init(hexString: "FFE69C") // оранжево-коричневый





//public let purple1 = UIColor.init(hexString: "6666FF") // фиолетовый
//public let gray2 = UIColor.init(hexString: "778899") // серый+
//public let white1 = UIColor.init(hexString: "FFFFFF") // белый
//public let blue2 = UIColor.init(hexString: "0000FF") // синий+
//public let gray1 = UIColor.init(hexString: "A6B0BC") // серый
//public let purple2 = UIColor.init(hexString: "D0D0FF") // фиолетовый +
//public let gray3 = UIColor.init(hexString: "D3D3D3") // серый ++
//public let black1 = UIColor.init(hexString: "000000") // черный
//public let blue1 = UIColor.init(hexString: "00007F") // синий
//public let orange1 = UIColor.init(hexString: "FFE69C") // оранжево-коричневый































//enum MyColor:  CaseIterable {
//
//    case ControlBackgroundActive1
//    case ControlBackgroundActive2
//    case ControlBackgroundActive3
//
//    case ControlBackgroundDontActive1
//    case ControlBackgroundDontActive2
//    case ControlBackgroundDontActive3
//
//    case ControlTitleActive1
//    case ControlTitleActive2
//    case ControlTitleActive3
//
//    case ControlTitle1DontActive1
//    case ControlTitleDontActive2
//    case ControlTitleDontActive3
//
//    case Label1
//    case Label2
//    case Label3
//
//    case TextFieldBackgroundActive1
//    case TextFieldBackgroundActive2
//    case TextFieldBackgroundActive3
//
//    case TextFieldBackgroundDontActive1
//    case TextFieldBackgroundDontActive2
//    case TextFieldBackgroundDontActive3
//
//    case ViewBackground1
//    case ViewBackground2
//    case ViewBackground3
//
//    case NavigationBarBackground1
//    case NavigationBarBackground2
//    case NavigationBarBackground3
//
//    case NavigationBarTitle1
//    case NavigationBarTitle2
//    case NavigationBarTitle3
//
//    var discript: (dark: UIColor, light: UIColor, alt: UIColor) {
//        let color = Color()
//    switch self {
//    case .ControlBackgroundActive1: return color.ControlBackgroundActive1
//    case .ControlBackgroundActive2: return color.ControlBackgroundActive2
//    case .ControlBackgroundActive3: return color.ControlBackgroundActive3
//
//    case .ControlBackgroundDontActive1: return color.co
//        case ControlBackgroundDontActive2: return color.
//        case ControlBackgroundDontActive3: return color.
//
//        case ControlTitleActive1: return color.
//        case ControlTitleActive2: return color.
//        case ControlTitleActive3: return color.
//
//        case ControlTitle1DontActive1: return color.
//        case ControlTitleDontActive2: return color.
//        case ControlTitleDontActive3: return color.
//
//        case Label1: return color.
//        case Label2: return color.
//        case Label3: return color.
//
//        case TextFieldBackgroundActive1: return color.
//        case TextFieldBackgroundActive2: return color.
//        case TextFieldBackgroundActive3: return color.
//
//        case TextFieldBackgroundDontActive1: return color.
//        case TextFieldBackgroundDontActive2: return color.
//        case TextFieldBackgroundDontActive3v
//
//        case ViewBackground1: return color.
//        case ViewBackground2: return color.
//        case ViewBackground3: return color.
//
//        case NavigationBarBackground1: return color.
//        case NavigationBarBackground2: return color.
//        case NavigationBarBackground3: return color.
//
//        case NavigationBarTitle1: return color.
//        case NavigationBarTitle2: return color.
//        case NavigationBarTitle3: return color.
//    }
//



//    var color: UIColor {
//        var color: UIColor
//        for
//        MyColor.allCases.enumerated(){ myColor in
//            if myColor == ""{
//
//            }
//        }
//
//    }


//}







//
//
//struct ColorScheme{
//
//    static let Shared = ColorScheme()
//
//    var colorScheme = ColorSchemeOption.dark
//    var isDark: Bool { colorScheme == colorScheme}
//
//
//    let c6666FF = UIColor.init(hexString: "6666FF") // фиолетовый
//    let c778899 = UIColor.init(hexString: "778899") // серый+
//    let cFFFFFF = UIColor.init(hexString: "FFFFFF") // белый
//    let c0000FF = UIColor.init(hexString: "0000FF") // синий+
//    let c666F79 = UIColor.init(hexString: "A6B0BC") // серый
//    let cD0D0FF = UIColor.init(hexString: "D0D0FF") // фиолетовый +
//    let cD3D3D3 = UIColor.init(hexString: "D3D3D3") // серый ++
//    let c000000 = UIColor.init(hexString: "000000") // черный
//    let c00007F = UIColor.init(hexString: "00007F") // синий
//    let cFFE69C = UIColor.init(hexString: "FFE69C") // оранжево-коричневый
//
//    //MARK- navigationBar
//
//    var navigationBarBackgroundBlue: UIColor        { isDark ? c6666FF : cFFE69C}
//    var navigationBarBackgroundGray: UIColor        { isDark ? c778899 : cFFE69C}
//    var navigationBarText: UIColor                  { isDark ? cFFE69C : c0000FF}
//
//    //MARK- ViewControllerLogin
//
//    var colorLVCButtonNextActive: UIColor            { isDark ? c6666FF : c6666FF}
//    var colorLVCButtonNextDontActive: UIColor        { isDark ? c778899 : c778899}
//    var colorLVCButtonNextText: UIColor              { isDark ? cFFFFFF : cFFFFFF}
//    var colorLVCBackgroundShared: UIColor            { isDark ? c666F79 : c666F79}
//    var colorLVCBackgroundTextField: UIColor         { isDark ? cD3D3D3 : cD3D3D3}
//    var colorLVCTextFieldText: UIColor               { isDark ? c000000 : c000000}
//    var colorLVCProfileUserLabelText: UIColor        { isDark ? c0000FF : c0000FF}
//    var colorLVCButtonFindMyProfileText: UIColor     { isDark ? c0000FF : c0000FF}
//
//    //MARK- BeginLaunchController
//
//    var colorBLCBackgroundShared: UIColor            { isDark ? cD0D0FF : cD0D0FF}
//    var colorBLCBackgroundTitleTable: UIColor        { isDark ? cD0D0FF : cD0D0FF}
//    var colorBLCTextTitle: UIColor                   { isDark ? c00007F : c00007F}
//    var colorBLCText: UIColor                        { isDark ? c0000FF : c0000FF}
//    ////////////
//    var colorBLCCellSelected: UIColor                { isDark ? cFFE69C : cFFE69C}
//
//    //MARK- NewDictionary
//
//    var colorNDBackgroundShared: UIColor             { isDark ? c666F79 : c666F79}
//    var colorNDTitlesText: UIColor                   { isDark ? c0000FF : c0000FF}
//    
//    var colorNDSegmentActive: UIColor                { isDark ? c6666FF : c6666FF}
//    var colorNDSegmentText: UIColor                  { isDark ? c000000 : c000000}
//    var colorNDSegmentBackground: UIColor            { isDark ? c778899 : c778899}
//
//    var colorNDBackgroundInputTitle: UIColor         { isDark ? cD3D3D3 : cD3D3D3}
//    var colorNDBInputTitle: UIColor                  { isDark ? c000000 : c000000}
//
//    var colorNDButtonContinueActive: UIColor         { isDark ? c6666FF : c6666FF}
//    var colorNDButtonContinueDontActive: UIColor     { isDark ? c778899 : c778899}
//    var colorNDButtonContinueText: UIColor           { isDark ? cFFFFFF : cFFFFFF}
//
//}
//
//
//
//
//
//
//
