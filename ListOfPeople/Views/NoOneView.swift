//
//  NoOneView.swift
//  ListOfPeople
//
//  Created by Arif Okuyucu on 3.10.2021.
//

import UIKit

class NoOneView: UIView {
    lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No one here :)"
        label.textAlignment = .center
        return label
    }()
    
    lazy var retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTapRetryButton), for: .touchUpInside)
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(UIColor.blue.withAlphaComponent(0.5), for: .highlighted)
        return button
    }()
    
    var didTapRetry: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(noDataLabel)
        addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            noDataLabel.widthAnchor.constraint(equalToConstant: 200),
            
            retryButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 40),
            retryButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    
    }
    
    @objc func didTapRetryButton(_ sender: UIButton) {
        if let didTapRetry = self.didTapRetry {
            didTapRetry()
        }
    }
}
