//
//  ENLoginVC.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/9.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit

class ENLoginVC: ENBaseController, UITextFieldDelegate {
    
    lazy var phoneField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.keyboardType = .numberPad
        textField.placeholder = "手机号"
        textField.clearButtonMode = .whileEditing
//        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    lazy var passwordField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.isSecureTextEntry = true
        textField.placeholder = "密码"
        return textField
    }()
    
    lazy var loginBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.theme
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "手机号登录"
        
        phoneField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        self.view.addSubview(phoneField)
        self.view.addSubview(passwordField)
        phoneField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(navBarHeight + 60.0)
            make.leading.equalToSuperview().offset(15.0)
            make.trailing.equalToSuperview().offset(-15.0)
            make.height.equalTo(30)
        }
        
        passwordField.snp.makeConstraints { (make) in
            make.top.equalTo(phoneField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(15.0)
            make.trailing.equalToSuperview().offset(-15.0)
            make.height.equalTo(30)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: phoneField)
        
        
    }
    
    @objc func loginAction() {
        
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        if phoneField.text != nil && passwordField.text != nil {
            self.loginBtn.isEnabled = true
        }else {
            self.loginBtn.isEnabled = false
        }
    }

}
