//
//  LoginViewController.swift
//  ColorIt
//
//  Created by Mobile Apps on 9/2/20.
//  Copyright © 2020 Mobile Apps. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoWidth: NSLayoutConstraint!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var linesStackView: UIView!
    @IBOutlet weak var buttonsStackView: UIView!
    @IBOutlet weak var linesStackViewWidth: NSLayoutConstraint!
    @IBOutlet weak var buttonsStackViewWidth: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    
    var email = ""
    var password = ""
    
    override func viewDidLoad() {
        
        emailTextField.delegate = self
        passwordTextfield.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        
        let screenWidth = self.view.frame.width
        if UIDevice.current.userInterfaceIdiom == .pad {
            linesStackViewWidth.constant = screenWidth - screenWidth / 3
            buttonsStackViewWidth.constant = screenWidth - screenWidth / 3
        } else {
            linesStackViewWidth.constant = screenWidth - 40
            buttonsStackViewWidth.constant = screenWidth - 40
        }
        
        if self.view.frame.height < 680 {
            logoTopConstraint.constant = 20
        }
        
        emailTextField.setUnderLine()
        passwordTextfiels.setUnderLine()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setUI()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUI() {
        
        logoImage.image = UIImage(named: Images.logo)
        logoImage.contentMode = .scaleAspectFit
        
        backgroundImage.image = UIImage(named: Images.Backgrounds.loginBack)
        backgroundImage.contentMode = .scaleAspectFill
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: Strings.LoginVC.email, attributes: Attributes.white17)
        emailTextField.defaultTextAttributes = Attributes.white17
        emailTextField.text = ""
        
        passwordTextfield.attributedPlaceholder = NSAttributedString(string: Strings.LoginVC.password, attributes: Attributes.white17)
        passwordTextfield.defaultTextAttributes = Attributes.white17
        passwordTextfield.text = ""
        
        loginButton.backgroundColor = Colors.white
        loginButton.setAttributedTitle(NSAttributedString(string: Strings.LoginVC.login, attributes: Attributes.black17), for: .normal)
        
        regButton.backgroundColor = Colors.black
        regButton.setAttributedTitle(NSAttributedString(string: Strings.LoginVC.creatAccount, attributes: Attributes.white17), for: .normal)
        
        forgotButton.backgroundColor = Colors.black
        forgotButton.setAttributedTitle(NSAttributedString(string: Strings.LoginVC.forgot, attributes: Attributes.white17), for: .normal)
        
        emailTextField.isExclusiveTouch = true
        passwordTextfiels.isExclusiveTouch = true
        loginButton.isExclusiveTouch = true
        regButton.isExclusiveTouch = true
        forgotButton.isExclusiveTouch = true
        
    }
    
    @IBAction func tapToLogin(_ sender: Any) {
        
        if emailTextField.text!.isEmpty || passwordTextfiels.text!.isEmpty{
            //alert empty fields
            Alertift.alert(message: Strings.Alerts.emptyLines).action(.default(Strings.Alerts.ok)){_, _, _ in
                return
            }.show(on: self)
        } else if !isValidEmail(emailTextField.text!){
            //alert wrong email
            Alertift.alert(message: Strings.Alerts.wrongEmail).action(.default(Strings.Alerts.ok)){_, _, _ in
                return
            }.show(on: self)
        } else {
            loginRequest(email: emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                         password: passwordTextfiels.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
    }
    
    @IBAction func tapToReg(_ sender: Any) {
        
        let accVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
        self.navigationController?.viewControllers = [accVC] as! [UIViewController]
        
    }
    
    @IBAction func tapToForgot(_ sender: Any) {
        
        let accVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotViewController") as? ForgotViewController
        self.navigationController?.viewControllers = [accVC] as! [UIViewController]
        
    }
    
    
    func loginRequest(email: String, password: String){
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        loginUser(email: email, password: password) { (isError, message, userID) in
            //isError should be false
            if !isError {
                        //login success
                        UserDefaults.standard.set(true, forKey: UserDefaultNames.isUserLoggedIn)
                        UserDefaults.standard.set(userID, forKey: UserDefaultNames.userID)
                        UserDefaults.standard.set(email, forKey: UserDefaultNames.email)
                        UserDefaults.standard.set(password, forKey: UserDefaultNames.password)
                        UIViewController.removeSpinner(spinner: sv)
                        print(email, password)
                        self.dismiss(animated: true)
            } else {
                        UserDefaults.standard.set(false, forKey: UserDefaultNames.isUserLoggedIn)
                        UIViewController.removeSpinner(spinner: sv)
                        Alertift.alert(message: Strings.Alerts.loginError).action(.default(Strings.Alerts.ok)){_, _, _ in
                            return
                        }.show(on: self)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text!.count > 30 {
                textField.deleteBackward()
        }
        return true
    }    
}

