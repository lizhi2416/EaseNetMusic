//
//  ENLoginVC.swift
//  EaseNetMusic
//
//  Created by 蒋理智 on 2019/12/9.
//  Copyright © 2019 lizhi. All rights reserved.
//

import UIKit

class ENLoginVC: ENCustomNavController, UITextFieldDelegate {
    
    lazy var phoneField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.keyboardType = .numberPad
        textField.placeholder = "手机号"
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.systemFont(ofSize: 18)
        return textField
    }()
    
    lazy var passwordField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.isSecureTextEntry = true
        textField.placeholder = "密码"
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.systemFont(ofSize: 18)
        return textField
    }()
    
    lazy var loginBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setBackgroundImage(UIImage.init(color: UIColor.theme, size: CGSize(width: kScreenWidth-30, height: 40)), for: .normal)
        btn.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: "0xE5B2AE")!, size: CGSize(width: kScreenWidth-30, height: 40)), for: .disabled)
        btn.setTitle("登录", for: .normal)
        btn.layer.cornerRadius = 20.0
        btn.layer.masksToBounds = true
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
            make.top.equalToSuperview().offset(kNavgationHeight + 50.0)
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
        
        let sepline1 = UIView()
        sepline1.backgroundColor = UIColor.gray
        self.view.addSubview(sepline1)
        
        let sepline2 = UIView()
        sepline2.backgroundColor = UIColor.gray
        self.view.addSubview(sepline2)
        
        let pointHeight = 1.0 / UIScreen.main.scale
        sepline1.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(phoneField)
            make.height.equalTo(pointHeight)
        }
        
        sepline2.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(passwordField)
            make.height.equalTo(pointHeight)
        }
        
        self.view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passwordField.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(15.0)
            make.trailing.equalToSuperview().offset(-15.0)
            make.height.equalTo(40)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: phoneField)
        
        
    }
    
    @objc func loginAction() {
        ENProgressHud.showLoading()
        /// 因为菊花不可交互所以直接闭包强引用没关系
        ENHttpRuquest.loadData(target: ENApi.getServiceResponse(ENLoginApiPath, params: ["phone": (phoneField.text ?? ""), "password": (passwordField.text ?? "")]), Success: { (data) in
            if let userModel = try? JSONDecoder().decode(ENUserModel.self, from: data) {
                ENProgressHud.dismiss()
                if let code = userModel.code, code == 200 {
                    ENProgressHud.showToast("登录成功")
                    userModel.profile?.token = userModel.token
                    ENSaveUitil.saveUserModel(userModel.profile)
                    ENSaveUitil.saveLoginMark(true)
                    self.saveLoginCookies()
                    self.navigationController?.popViewController(animated: true)
                } else {
                    ENProgressHud.showToast(userModel.message ?? "登录异常")
                }
            } else {
                ENProgressHud.showToast("登录异常")
            }
        } , Failure: {
            ENProgressHud.dismiss()
            ENProgressHud.showToast($0.localizedDescription)
        })
    }
    
    func saveLoginCookies() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            let cookiesData = NSKeyedArchiver.archivedData(withRootObject: cookies)
            UserDefaults.standard.set(cookiesData, forKey: "loginCookiesData")
        }
        
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        if let phoneText = phoneField.text, let password = passwordField.text {
            if !phoneText.isEmpty && !password.isEmpty {
                self.loginBtn.isEnabled = true
                return
            }
        }
        self.loginBtn.isEnabled = false
    }

}
