//
//  UIColor_EXT.swift
//
//  Created by Lucas Luu on 9/30/21.
//  Copyright © 2021 CB/I Digital .Inc
//  All rights reserved.
//

import UIKit

let kPrimaryColor           = UIColor.init(hexString: "14c1c2")!
let kDefaultTextColor       = UIColor.init(hexString: "424242")!
let kTitleTextColor         = UIColor.init(hexString: "2a2a2a")!
let kCustomTextColor        = UIColor.init(hexString: "888888")!
let kBackgroundColor        = UIColor.white
let kDisableColor           = UIColor.init(hexString: "D9D9D9")!
let kRedHightLightColor     = UIColor.init(hexString: "ff6d6e")!
let kPinkColor              = UIColor.init(hexString: "ffe2e2")!
let kGrayColor              = UIColor.init(hexString: "efefef")!
let kPurpleColor            = UIColor.init(hexString: "9facf1")!
let kCircleBackgroundColor  = UIColor.init(hexString: "2cc8c6")!
let kLightGrayColor         = UIColor.init(hexString: "d8d8d8")!
let kLoginTextColor         = UIColor.init(hexString: "52979a")!

extension UIColor {
    
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F", "F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIColor {

    func rgb() -> Int? {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)

            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}
