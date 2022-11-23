//
//  UIFont_EXT.swift
//
//  Created by Lucas Luu on 9/30/21.
//  Copyright © 2021 CB/I Digital .Inc
//  All rights reserved.
//

import UIKit

enum FontName: String {
    
    case extraLight     = "Mulish ExtraLight"
    case light          = "Mulish-Light"
    case regular        = "Mulish-Regular"
    case black          = "Mulish-Black"
    case medium         = "Mulish-Medium"
    case semiBold       = "Mulish-SemiBold"
    case bold           = "Mulish-Bold"
    case extraBold      = "Mulish-ExtraBold"
    
    // italic
    case extraLightItalic   = "Mulish-ExtraLightItalic"
    case lightItalic        = "Mulish-LightItalic"
    case italic             = "Mulish-Italic"
    case blackItalic        = "Mulish-BlackItalic"
    case mediumItalic       = "Mulish-MediumItalic"
    case semiBoldItalic     = "Mulish-SemiBoldItalic"
    case boldItalic         = "Mulish-BoldItalic"
    case extraBoldItalic    = "Mulish-ExtraBoldItalic"
}

func getCustomFont (size: CGFloat, name: FontName) -> UIFont {
    guard let customFont = UIFont(name: name.rawValue, size: size) else {
        fatalError("""
            Failed to load the \(name.rawValue) font.
            Make sure the font file is included in the project and the font name is spelled correctly.
            """
        )
    }
    return customFont
}

