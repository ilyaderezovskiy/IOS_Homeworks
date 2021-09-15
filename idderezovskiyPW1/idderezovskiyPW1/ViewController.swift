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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeColorButtonPressed(_ sender: Any) {
    
        var set = Set<UIColor>()
        while set.count < views.count {
            set.insert(
                UIColor(
                    red: .random(in: 0...1),
                    green: .random(in: 0...1),
                    blue: .random(in: 0...1),
                    alpha: 1
                )
            )
        }
        
        // Disabling the button during animation.
        let button = sender as? UIButton
        button?.isEnabled = false
        
        // Creating an animation.
        UIView.animate(withDuration: 2, animations: {
            for view in self.views {
                // Changing the button shape.
                view.layer.cornerRadius = 10
                // Changing the button color.
                view.backgroundColor = set.popFirst()
            }
        }) { completion in
            button?.isEnabled = true // Enabling the button after the animation ends.
        }
    }
}

