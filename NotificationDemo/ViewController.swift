//
//  ViewController.swift
//  NotificationDemo
//
//  Created by Mariano Battaglia on 17/01/2024.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.borderStyle = .roundedRect
        return textField
    }()
    let subtitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Subtitle"
        textField.borderStyle = .roundedRect
        return textField
    }()
    let pushNotificationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send Push Notification", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var titleText: String = "Titulo de prueba"
    lazy var subtitleText: String = "Subtitulo de prueba"
    
    
    // MARK: - Initializers
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Push Notification"
        
        setupUI()
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(titleTextField)
        view.addSubview(subtitleTextField)
        view.addSubview(pushNotificationButton)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        subtitleTextField.translatesAutoresizingMaskIntoConstraints = false
        pushNotificationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            subtitleTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            subtitleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            subtitleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            subtitleTextField.heightAnchor.constraint(equalToConstant: 40),
            pushNotificationButton.topAnchor.constraint(equalTo: subtitleTextField.bottomAnchor, constant: 20),
            pushNotificationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            pushNotificationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            pushNotificationButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        pushNotificationButton.addTarget(self, action: #selector(sendPushNotification), for: .touchUpInside)
    }
    // MARK: - Button Action
    
    @objc private func sendPushNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .authorized:
                self.createNotification(title: self.titleText, subtitle: self.subtitleText)
                case .denied:
                    return
                case .notDetermined:
                    notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { didAllow, error in
                        if didAllow {
                            self.createNotification(title: self.titleText, subtitle: self.subtitleText)
                        }
                    }
                default:
                    return
            }
        }
    }
    
    func createNotification(title: String?, subtitle: String?) {
        
        LocalPush.shared.start()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            
            let content = UNMutableNotificationContent()
            content.title = title ?? "Title example"
            content.subtitle = subtitle ?? "Subtitle example"
            content.sound = UNNotificationSound.default
            
            // show this notification five seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            // add our notification request
            UNUserNotificationCenter.current().add(request)
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if textField == titleTextField {
            self.titleText = text
        }
        
        if textField == subtitleTextField {
            self.subtitleText = text
        }
    }
}

