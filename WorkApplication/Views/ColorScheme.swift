//
//  Constants.swift
//  WorkApplication
//
//  Created by Anatoly Ryavkin on 20.06.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import UIKit

enum ColorSchemeOption {
    case dark
    case light
}

struct ColorScheme{

    static let Shared = ColorScheme()

    var colorScheme = ColorSchemeOption.dark
    var isDark: Bool { colorScheme == colorScheme}

    let c6666FF = UIColor.init(hexString: "6666FF") // фиолетовый
    let c778899 = UIColor.init(hexString: "778899") // серый+
    let cFFFFFF = UIColor.init(hexString: "FFFFFF") // белый
    let c0000FF = UIColor.init(hexString: "0000FF") // синий+
    let c666F79 = UIColor.init(hexString: "A6B0BC") // серый
    let cD0D0FF = UIColor.init(hexString: "D0D0FF") // фиолетовый +
    let cD3D3D3 = UIColor.init(hexString: "D3D3D3") // серый ++
    let c000000 = UIColor.init(hexString: "000000") // черный
    let c00007F = UIColor.init(hexString: "00007F") // синий
    let cFFE69C = UIColor.init(hexString: "FFE69C") // оранжево-коричневый


    //MARK- navigationBar

    var navigationBarBackgroundBlue: UIColor{ isDark ? c6666FF : cFFE69C}
    var navigationBarBackgroundGray: UIColor{ isDark ? c778899 : cFFE69C}
    var navigationBarText: UIColor{ isDark ? cFFE69C : c0000FF}

    //MARK- LoginViewController

    var colorLVCButtonNextActive: UIColor { isDark ? c6666FF : c6666FF}
    var colorLVCButtonNextDontActive: UIColor { isDark ? c778899 : c778899}
    var colorLVCButtonNextText: UIColor { isDark ? cFFFFFF : cFFFFFF}
    var colorLVCBackgroundShared: UIColor { isDark ? c666F79 : c666F79}
    var colorLVCBackgroundTextField: UIColor { isDark ? cD3D3D3 : cD3D3D3}
    var colorLVCTextFieldText: UIColor { isDark ? c000000 : c000000}
    var colorLVCProfileUserLabelText: UIColor { isDark ? c0000FF : c0000FF}
    var colorLVCButtonFindMyProfileText: UIColor { isDark ? c0000FF : c0000FF}

    //MARK- BeginLaunchController

    var colorBLCBackgroundShared: UIColor { isDark ? cD0D0FF : cD0D0FF}
    var colorBLCBackgroundTitleTable: UIColor { isDark ? cD0D0FF : cD0D0FF}
    var colorBLCTextTitle: UIColor { isDark ? c00007F : c00007F}
    var colorBLCText: UIColor { isDark ? c0000FF : c0000FF}
    ////////////
    var colorBLCCellSelected: UIColor { isDark ? cFFE69C : cFFE69C}

    //MARK- NewDictionary

    var colorNDBackgroundShared: UIColor { isDark ? c666F79 : c666F79}
    var colorNDTitlesText: UIColor { isDark ? c0000FF : c0000FF}
    
    var colorNDSegmentActive: UIColor { isDark ? c6666FF : c6666FF}
    var colorNDSegmentText: UIColor { isDark ? c000000 : c000000}
    var colorNDSegmentBackground: UIColor { isDark ? c778899 : c778899}

    var colorNDBackgroundInputTitle: UIColor { isDark ? cD3D3D3 : cD3D3D3}
    var colorNDBInputTitle: UIColor { isDark ? c000000 : c000000}

    var colorNDButtonContinueActive: UIColor { isDark ? c6666FF : c6666FF}
    var colorNDButtonContinueDontActive: UIColor { isDark ? c778899 : c778899}
    var colorNDButtonContinueText: UIColor { isDark ? cFFFFFF : cFFFFFF}

}







