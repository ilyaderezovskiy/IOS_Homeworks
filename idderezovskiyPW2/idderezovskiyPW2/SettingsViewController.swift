//
//  SettingsViewController.swift
//  idderezovskiyPW2
//
//  Created by Ilya Derezovskiy on 23.09.2021.
//

import UIKit

final class SettingsViewController: UIViewController {

    private let settingsView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingsView()
        view.backgroundColor = .lightGray
        setupCloseButton()
    }
    
    var delegate: ((UIColor) -> ())?

    private func setupSettingsView() {
        settingsView.alpha = 0
    }
    
    private func setupCloseButton() {
        let button = UIButton(type: .close)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -10
        ).isActive = true
        button.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 10
        ).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(
            equalTo: button.heightAnchor
        ).isActive = true
        button.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
     }
    
    @objc
    private func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
}

