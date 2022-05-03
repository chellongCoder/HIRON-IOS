//
//  UIColor_EXT.swift
//
//  Created by Lucas Luu on 9/30/21.
//  Copyright © 2021 CB/I Digital .Inc
//  All rights reserved.
//

import UIKit

let kCyanTextColor          = UIColor.init(hexString: "14C1C2")
let kSpaceCadetColor        = UIColor.init(hexString: "172B4D")
let kPinkTextColor          = UIColor.init(hexString: "FA4169")
let kGrayTextColor          = UIColor.init(hexString: "ADB5C1")
let kLightGrayBorder        = UIColor.init(hexString: "E0E0E0")
let kLightGrayLine          = UIColor.init(hexString: "f6f6f6")
let kOrangeTextColor        = UIColor.init(hexString: "FE9870")
let kBlackCoralColor        = UIColor.init(hexString: "4D5766")
let kCadetBlueCrayola       = UIColor.init(hexString: "ADB5C1")
let kCarolinaBlueColor      = UIColor.init(hexString: "1DA1F2")
let kGoGreenColor           = UIColor.init(hexString: "0EAD69")
let kPinkOrangeColor        = UIColor.init(hexString: "FE9870")
let kNeutralColor           = UIColor.init(hexString: "fafafa")
let kEerieBlackColor        = UIColor.init(hexString: "101719")
let kIsabellineColor        = UIColor.init(hexString: "f0f0f0")
let kBackgroundColor        = UIColor.init(hexString: "f2f2f2")
let kNeonFuchsiaColor       = UIColor.init(hexString: "FA4169")
let kBlueBorderColor        = UIColor.init(hexString: "1DA1F2")
let kBlackTextColor         = UIColor.init(hexString: "1E1F20")
let kGrayBorderColor        = UIColor.init(hexString: "f3f3f3")
let kDarkGrayTextColor      = UIColor.init(hexString: "4D5766")
let kInnerBorderColor       = UIColor.init(hexString: "858C94")
let kNeutralBlackColor      = UIColor.init(hexString: "09101D")

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
