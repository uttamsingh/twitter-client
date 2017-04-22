//
//  ColorUtils.swift
//  TwitterClient
//
//  Created by Singh, Uttam on 4/22/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit

class ColorUtils: NSObject {
    static func getColorByHex(rgbHexValue:UInt32, alpha:Double = 1.0) -> UIColor {
        let red = Double((rgbHexValue & 0xFF0000) >> 16) / 256.0
        let green = Double((rgbHexValue & 0xFF00) >> 8) / 256.0
        let blue = Double((rgbHexValue & 0xFF)) / 256.0
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
}
