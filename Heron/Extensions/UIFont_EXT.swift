//
//  UIFont_EXT.swift
//
//  Created by Lucas Luu on 9/30/21.
//  Copyright © 2021 CB/I Digital .Inc
//  All rights reserved.
//

import UIKit

enum FontWeight: String {
    case light          = "SFProText-Light"
    case regular        = "SFProText-Regular"
    case medium         = "SFProText-Medium"
    case semibold       = "SFProText-Semibold"
    case bold           = "SFProText-Bold"
    case heavy          = "SFProText-Heavy"

    case lightItalic    = "SFProText-LightItalic"
    case regularItalic  = "SFProText-RegularItalic"
    case mediumItalic   = "SFProText-MediumItalic"
    case semiboldItalic = "SFProText-SemiboldItalic"
    case boldItalic     = "SFProText-BoldItalic"
    case heavyItalic    = "SFProText-HeavyItalic"
}

func getFontSize (size: CGFloat, weight: FontWeight) -> UIFont {
    return UIFont.init(name: weight.rawValue, size: size)!
}
