//
//  ViewController.swift
//  idderezovskiyPW6
//
//  Created by Ilya Derezovskiy on 21.11.2021.
//

import UIKit
import MyLogger1
import MyLogger2
import MyLogger3

class ViewController: UIViewController {

    lazy var buttonOne: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log (framework)", for: .normal)
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.addTarget(self, action: #selector(logFromFramework), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonTwo: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log (swift package)", for: .normal)
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.addTarget(self, action: #selector(logFromSwiftPackage), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonThree: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log (pod)", for: .normal)
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.addTarget(self, action: #selector(logFromPod), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonFour: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log (carthage)", for: .normal)
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupContraints()
    }

    func setupContraints() {
        let stack = UIStackView(arrangedSubviews: [buttonOne, buttonTwo, buttonThree, buttonFour])
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.widthAnchor.constraint(equalToConstant: 250).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -300).isActive = true
    }
    
    @IBAction func logFromFramework(_ sender: Any) {
        MyLogger1.log("hello, world")
    }
    
    @IBAction func logFromSwiftPackage(_ sender: Any) {
        MyLogger2.log("hello, world")
    }
    
    @IBAction func logFromPod(_ sender: Any) {
        MyLogger3.log("hello, world")
    }
}


