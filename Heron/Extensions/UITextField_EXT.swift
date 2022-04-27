//
//  UITextField_EXT.swift
//
//  Created by Lucas Luu on 9/30/21.
//  Copyright © 2021 CB/I Digital .Inc
//  All rights reserved.
//

import UIKit

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 15)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class IconTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 10)
    let icon    = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        icon.image = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        icon.contentMode = .scaleAspectFill
        addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class SearchBarTxt: UITextField {

    let padding     = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 36)
    let icon        = UIImageView()
    let deleteBtn   = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        icon.image = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        icon.contentMode = .scaleAspectFill
        
        self.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = UIColor.black.cgColor //Any dark color
      
        addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(16)
        }

//        deleteBtn.setImage(UIImage(named: "delete_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        deleteBtn.addTarget(self, action: #selector(deleteText), for: .touchUpInside)
//        addSubview(deleteBtn)
//        deleteBtn.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().offset(-12)
//            make.width.height.equalTo(24)
//        }
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: self.frame.width - 36, y: self.frame.height / 2 - 10, width: 20, height: 20)
    }

//    @objc private func deleteText() {
//        self.text = ""
//        if let delegate = delegate {
//            delegate.textFieldDidEndEditing?(self)
//        }
//    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension UITextField {

    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
       return false
    }

    func isValidPassword() -> Bool {

        guard let text = self.text else {
            return false
        }

        if text.count  < 8 {
            return false
        }

        if text.count > 16 {
            return false
        }

        let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&.])(?=.*[A-Z]).{8,16}$")

        return password.evaluate(with: text)
    }
}

class TextFieldCanPaste: UITextField {

    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
       return true
    }
}

class TextFieldLimit: UITextField, UITextFieldDelegate {
    
    private var maxLength = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCharacterLimit(maxLength: Int) {
        self.maxLength = maxLength
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length > maxLength {return false}
        if string == "," {
            textField.text = textField.text! + "."
            return false
        }
        return true
    }
}

