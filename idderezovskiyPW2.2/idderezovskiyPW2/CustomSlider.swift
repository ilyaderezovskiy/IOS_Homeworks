//
//  CustomSlider.swift
//  idderezovskiyPW2
//
//  Created by Ilya Derezovskiy on 06.03.2022.
//

import Foundation
import UIKit

@IBDesignable
class CustomSlider: UISlider {

    func setSlider() {
        self.setThumbImage(UIImage(named: "dinosaur")?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.minimumValue = 0
        self.maximumValue = 1
    }
    
    @IBInspectable var thumbImage: UIImage? {
        didSet{
            setThumbImage(thumbImage, for: .normal)
        }
    }
    @IBInspectable var thumbHighlitghedImage: UIImage? {
        didSet{
            setThumbImage(thumbHighlitghedImage, for: .highlighted)
        }
    }
}
