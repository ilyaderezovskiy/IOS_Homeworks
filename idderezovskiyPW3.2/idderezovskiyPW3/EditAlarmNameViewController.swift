//
//  EditAlarmNameViewController.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 30.03.2022.
//

import UIKit

class EditAlarmNameViewController: UIViewController {
    private var textInput: UITextField!
    var interactor: AddAndEditAlarmInteractorLogic?
    var alarmName: String = "Alarm"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Alarm name"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneButtonPressed)
        )

        self.view.backgroundColor = .white
        
        setupInputField()
    }

    func setupInputField() {
        let input = UITextField()
        input.setHeight(to: 60)
        input.backgroundColor = .white
        input.setLeftPadding(15)
        input.clearButtonMode = .always
        view.addSubview(input)
        input.pinCenter(to: view)
        input.textColor = .black
        input.layer.borderColor = UIColor.gray.cgColor
        input.layer.borderWidth = 0.5
        input.widthAnchor.constraint(
            equalTo: view.widthAnchor,
            constant: 1
        ).isActive = true
        input.autocorrectionType = .no
        input.text = alarmName
        textInput = input
    }
    
    @objc
    func doneButtonPressed() {
        interactor?.updateCurrentAlarmName(textInput.text ?? alarmName)
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension UITextField {
    func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
