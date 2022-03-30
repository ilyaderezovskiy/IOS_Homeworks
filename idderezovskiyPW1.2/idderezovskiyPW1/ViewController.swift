//
//  ViewController.swift
//  idderezovskiyPW1
//
//  Created by Ilya Derezovskiy on 14.09.2021.
//
// Adapted for iPhone 11

import UIKit

class ViewController: UIViewController {
    @IBOutlet var views: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for view in views {
            view.backgroundColor = UIColor(hex: generateRandomHexString())
            view.layer.cornerRadius = 10
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeColorButtonPressed(_ sender: Any) {
        // Disabling the button during animation.
        let button = sender as? UIButton
        button?.isEnabled = false
        
        // Creating an animation.
        UIView.animate(withDuration: 2, animations: {
            for view in self.views {
                // Changing the button shape.
                view.layer.cornerRadius = 10
                // Changing the button color.
                view.backgroundColor = UIColor(hex: self.generateRandomHexString())
            }
        }) { completion in
            button?.isEnabled = true // Enabling the button after the animation ends.
        }
    }
    
    func generateRandomHexString() -> String{
        // Generating hex values for each color.
        let r = String(Int.random(in: 0...255), radix: 16)
        let g = String(Int.random(in: 0...255), radix: 16)
        let b = String(Int.random(in: 0...255), radix: 16)
        // Alpha should be maximum.
        return "#" + r + g + b
    }
}

extension UIColor {
    convenience init?(hex: String) {
        // Strips string from new lines and whitespaces.
        var hexParsed = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        // Removes first "#" symbol.
        hexParsed = hexParsed.replacingOccurrences(of: "#", with: "")
        // Will store the hexadecimal value as an unsigned integer.
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        //  Scans the string for a hexadecimal representation.
        guard Scanner(string: hexParsed).scanHexInt64(&rgb) else { return nil }
        // Extracts the red, green, and blue color components of the value stored in rgb.
        r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        b = CGFloat(rgb & 0x0000FF) / 255.0
        // Creating the UIColor instance.
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

