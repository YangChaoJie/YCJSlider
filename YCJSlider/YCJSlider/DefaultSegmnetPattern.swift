//
//  DefaultSegmnetPattern.swift
//  Konka
//
//  Created by 杨超杰 on 2017/3/17.
//  Copyright © 2017年 Heading. All rights reserved.
//

import Foundation
import UIKit

struct DefaultSegmentPattern {
    
    static let itemTextColor = UIColor.black
    static let itemSelectedTextColor = UIColor.red
    
    static let itemBackgroundColor = UIColor.white
    static let itemSelectedBackgroundColor = UIColor.white
    
    static let itemBorder : CGFloat = 20
    //MARK - Text font
    static let textFont = UIFont.systemFont(ofSize: 14)
    static let selectedTextFont = UIFont.systemFont(ofSize: 14)
    
    //MARK - slider
    static let sliderColor = UIColor.red
    static let sliderHeight : CGFloat = 2.0
    
    static let isAnimation: Bool = false
    
    //MARK - bridge
    static let bridgeColor = UIColor.red
    static let bridgeWidth : CGFloat = 7.0
    
    //MARK - inline func
//    @inline(__always) static func color(red:Float, green:Float, blue:Float, alpha:Float) -> UIColor {
//        return UIColor(colorLiteralRed: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
//    }
}
