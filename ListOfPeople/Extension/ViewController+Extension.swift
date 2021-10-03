//
//  ViewController+Extension.swift
//  ListOfPeople
//
//  Created by Arif Okuyucu on 3.10.2021.
//

import UIKit

extension UIViewController {
    func showToastMessage(message: String, time: Float = 3.0) {
        let toastView = UIView()
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.layer.cornerRadius = 20
        toastView.clipsToBounds = true
        toastView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        toastView.addSubview(messageLabel)
        view.addSubview(toastView)
        
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -15),
            messageLabel.topAnchor.constraint(equalTo: toastView.topAnchor, constant: 15),
            messageLabel.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: -15),
            
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
        ])
        
        UIView.animate(withDuration: TimeInterval(time)){
            toastView.alpha = 0.0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
}
