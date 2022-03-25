//
//  ViewController.swift
//  idderezovskiyPW2
//
//  Created by Ilya Derezovskiy on 23.09.2021.
//

import UIKit
import CoreLocation

protocol SettingDataPass {
    func changeBackground(color : UIColor)
}

class ViewController: UIViewController {
    private let setView = UIStackView()
    private let locationTextView = UITextView()
    private let locationManager = CLLocationManager()
    private var locationToggle = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        setupLocationTextView()
        setupSettingsView()
        setupSettingsButton()
        setupLocationToggle()
        setupSliders()
        locationManager.requestWhenInUseAuthorization()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupSettingsButton() {
        let settingsButton = UIButton(type: .system)
        view.addSubview(settingsButton)
        settingsButton.setImage(
            UIImage(named: "turtle")?.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 15
        ).isActive = true
        settingsButton.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -15 ).isActive = true
        settingsButton.heightAnchor.constraint(
            equalToConstant: 30
        ).isActive = true
        settingsButton.widthAnchor.constraint(
            equalTo: settingsButton.heightAnchor
        ).isActive = true
        
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed),
        for: .touchUpInside)
    }
    
    private func setupSettingsView() {
       view.addSubview(setView)
       setView.translatesAutoresizingMaskIntoConstraints = false
       setView.backgroundColor = .systemGray4
       setView.alpha = 0
       setView.topAnchor.constraint(
       equalTo: view.safeAreaLayoutGuide.topAnchor,
       constant: 10
       ).isActive = true
       setView.trailingAnchor.constraint(
       equalTo: view.safeAreaLayoutGuide.trailingAnchor,
       constant: -10 ).isActive = true
       setView.heightAnchor.constraint(equalToConstant: 300).isActive =
       true
        setView.widthAnchor.constraint(
        equalTo: setView.heightAnchor,
        multiplier: 2/3
        ).isActive = true
       setView.axis = .vertical
    }
    
    private func setupLocationTextView() {
        view.addSubview(locationTextView)
        locationTextView.backgroundColor = .white
        locationTextView.layer.cornerRadius = 20
        locationTextView.translatesAutoresizingMaskIntoConstraints = false
        locationTextView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 60
        ).isActive = true
        locationTextView.centerXAnchor.constraint(
            equalTo: view.centerXAnchor
        ).isActive = true
        locationTextView.heightAnchor.constraint(
            equalToConstant: 300
        ).isActive = true
        locationTextView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 15
        ).isActive = true
        locationTextView.isUserInteractionEnabled = false
    }
    private func setupLocationToggle() {
        locationToggle = LocationToggle().getLocationToggle()
        locationToggle.addTarget(
            self,
            action: #selector(locationToggleSwitched),
            for: .valueChanged
        )
        setView.addArrangedSubview(LocationToggle().getLocationLabel())
        setView.addArrangedSubview(locationToggle)
    }
    
    private let sliders = [CustomSlider(), CustomSlider(), CustomSlider()]
    private let colors = ["Red", "Green", "Blue"]
    private func setupSliders() {
        var top = 80
        for i in 0..<sliders.count {
            let view = UIView()
            setView.addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraint(
                equalTo: setView.leadingAnchor,
                constant: 10
            ).isActive = true
            view.trailingAnchor.constraint(
                equalTo: setView.trailingAnchor,
                constant: -10
            ).isActive = true
            view.topAnchor.constraint(
                equalTo: setView.topAnchor,
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
    
    private var buttonCount = 0
    @objc private func settingsButtonPressed() {
        switch buttonCount {
        case 0, 1:
            UIView.animate(withDuration: 0.1, animations: {
                self.setView.alpha = 1 - self.setView.alpha
            })
        case 2:
            let vc = createSettingsViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = createSettingsViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            buttonCount = -1
        }
        buttonCount += 1
    }
    
    func createSettingsViewController() -> SettingsViewController {
        let settingsViewController = SettingsViewController()
        settingsViewController.isToggleOn = locationToggle.isOn
        settingsViewController.locationManager = locationManager
        settingsViewController.delegate = self
        settingsViewController.red = CGFloat(sliders[0].value)
        settingsViewController.green = CGFloat(sliders[1].value)
        settingsViewController.blue = CGFloat(sliders[2].value)
        return settingsViewController
    }

    @objc private func sliderChangedValue() {
        let red: CGFloat = CGFloat(sliders[0].value)
        let green: CGFloat = CGFloat(sliders[1].value)
        let blue: CGFloat = CGFloat(sliders[2].value)
        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    @objc
    func locationToggleSwitched(_ sender: UISwitch) {
        if sender.isOn {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy =
                    kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            } else {
                sender.setOn(false, animated: true)
            }
        } else {
            locationTextView.text = ""
            locationManager.stopUpdatingLocation()
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let coord: CLLocationCoordinate2D =
                manager.location?.coordinate else { return }
        locationTextView.text = "Coordinates = \(coord.latitude) \(coord.longitude)"
    }
}

protocol ViewControllerDelegate: AnyObject {
    func updateLocation(isTurnedOn:Bool)
    func updateColors(red:CGFloat, green:CGFloat, blue:CGFloat)
}

extension ViewController: ViewControllerDelegate{
    func updateColors(red: CGFloat, green: CGFloat, blue: CGFloat) {
        sliders[0].value = Float(red)
        sliders[1].value = Float(green)
        sliders[2].value = Float(blue)
        sliderChangedValue()
    }
    
    func updateLocation(isTurnedOn: Bool) {
        locationToggle.isOn = isTurnedOn
        locationToggleSwitched(locationToggle)
    }
}
