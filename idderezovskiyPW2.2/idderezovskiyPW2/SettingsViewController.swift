//
//  SettingsViewController.swift
//  idderezovskiyPW2
//
//  Created by Ilya Derezovskiy on 23.09.2021.
//

import UIKit
import CoreLocation

final class SettingsViewController: UIViewController {

    private let settingsView = UIStackView()
    
    var isToggleOn: Bool = false
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingsView()
        view.backgroundColor = .lightGray
        setupLocationToggle()
        setupCloseButton()
        setupSliders()
    }
    
    var delegate: ViewControllerDelegate?

    private func setupSettingsView() {
        view.addSubview(settingsView)
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        settingsView.layer.cornerRadius = 10
        settingsView.backgroundColor = .red
        settingsView.heightAnchor.constraint(equalToConstant: 300
        ).isActive = true
        settingsView.centerXAnchor.constraint(
            equalTo: view.centerXAnchor
        ).isActive = true
        settingsView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 100
        ).isActive = true
        settingsView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
        constant: 20).isActive = true
            
        settingsView.alpha = 1
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
    
    private let sliders = [CustomSlider(), CustomSlider(), CustomSlider()]
    private let colors = ["Red", "Green", "Blue"]
    private func setupSliders() {
        sliders[0].value = Float(red)
        sliders[1].value = Float(green)
        sliders[2].value = Float(blue)
        var top = 80
        for i in 0..<sliders.count {
            let view = UIView()
            settingsView.addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraint(
                equalTo: settingsView.leadingAnchor,
                constant: 10
            ).isActive = true
            view.trailingAnchor.constraint(
                equalTo: settingsView.trailingAnchor,
                constant: -10
            ).isActive = true
            view.topAnchor.constraint(
                equalTo: settingsView.topAnchor,
                constant: CGFloat(top)
            ).isActive = true
            view.heightAnchor.constraint(
                equalToConstant: 30
            ).isActive = true
            top += 40
            let label = UILabel()
            view.addSubview(label)
            label.text = colors[i]
            label.translatesAutoresizingMaskIntoConstraints = false
            label.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 5
            ).isActive = true
            label.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ).isActive = true
            label.widthAnchor.constraint(
                equalToConstant: 50
            ).isActive = true
            let slider = sliders[i]
            slider.setSlider()
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.minimumValue = 0
            slider.maximumValue = 1
            slider.addTarget(self, action:
                                #selector(sliderChangedValue), for: .valueChanged)
            view.addSubview(slider)
            slider.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 5
            ).isActive = true
            slider.heightAnchor.constraint(
                equalToConstant: 20
            ).isActive = true
            slider.leadingAnchor.constraint(
                equalTo: label.trailingAnchor,
                constant: 10
            ).isActive = true
            slider.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ).isActive = true
        }
    }
    
    private func setupLocationToggle() {
        let locationToggle = LocationToggle().getLocationToggle()
        settingsView.addSubview(locationToggle)
        locationToggle.isOn = isToggleOn
        locationToggle.topAnchor.constraint(
            equalTo: settingsView.topAnchor,
            constant: 50
        ).isActive = true
        locationToggle.trailingAnchor.constraint(
            equalTo: settingsView.trailingAnchor,
            constant: -10
        ).isActive = true
        locationToggle.addTarget(
            self,
            action: #selector(locationToggleSwitched),
            for: .valueChanged
        )

        let locationLabel = LocationToggle().getLocationLabel()
        settingsView.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(
            equalTo: settingsView.topAnchor,
            constant: 55
        ).isActive = true
        locationLabel.leadingAnchor.constraint(
            equalTo: settingsView.leadingAnchor,
            constant: 10
        ).isActive = true
        locationLabel.trailingAnchor.constraint(
            equalTo: locationToggle.leadingAnchor,
            constant: -10
        ).isActive = true
    }
    
    func changeLocation(isTurnedOn:Bool){
        delegate?.updateLocation(isTurnedOn: isTurnedOn)
    }
        
    func changeColors(red:CGFloat, green:CGFloat, blue:CGFloat){
        delegate?.updateColors(red: red, green: green, blue: blue)
    }
    
    @objc
    private func closeScreen() {
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func locationToggleSwitched(_ sender: UISwitch) {
        changeLocation(isTurnedOn: sender.isOn)
    }
    
    @objc private func sliderChangedValue() {
        let red: CGFloat = CGFloat(sliders[0].value)
        let green: CGFloat = CGFloat(sliders[1].value)
        let blue: CGFloat = CGFloat(sliders[2].value)
        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
