//
//  CustomButton.swift
//  Navigation
//
//  Created by Кирилл Паничкин on 2/1/26.
//

import UIKit

final class CustomButton: UIButton {
    
    private var action: (() -> Void)?
    
    // MARK: - Init
    
    init(title: String,
         titleColor: UIColor = .white,
         backgroundColor: UIColor = .systemBlue,
         cornerRadius: CGFloat = LayoutConstants.cornerRadius,
         action: (() -> Void)? = nil) {
        
        self.action = action
        super.init(frame: .zero)
        
        setupButton(title: title,
                   titleColor: titleColor,
                   backgroundColor: backgroundColor,
                   cornerRadius: cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupButton(title: String,
                            titleColor: UIColor,
                            backgroundColor: UIColor,
                            cornerRadius: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped() {
        action?()
    }
    
    // MARK: - Public methods
    
    func setAction(_ action: @escaping () -> Void) {
        self.action = action
    }
}
