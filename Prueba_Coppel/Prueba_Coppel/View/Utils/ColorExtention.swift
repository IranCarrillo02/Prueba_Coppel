//
//  ColorExtention.swift
//  Prueba_Coppel
//
//  Created by Iran Carrillo on 23/07/22.
//

import UIKit

extension UIColor{
    convenience init(hex: String){
        let scaner =  Scanner(string: hex)
        scaner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scaner.scanHexInt64(&rgbValue)
        let redColor = (rgbValue & 0xff0000) >> 16
        let greenColor = (rgbValue & 0xff00) >> 8
        let blueColor = (rgbValue & 0xff)
        self.init(red: CGFloat(redColor)/0xff, green: CGFloat(greenColor)/0xff, blue: CGFloat(blueColor)/0xff, alpha: 1)
    }
}
