//
//  LoginViewController.swift
//  PlatziTweets
//
//  Created by Jyferson Colina on 27/01/22.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

//  Crear nuestro prpio color que funcione con darkMode


extension UIColor {
    static var customGreen: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { trait in
                if trait.userInterfaceStyle == .dark {
                    // aqui estamos en dark mode
                    return .white
                } else {
                    // aqui estamos en lightMode
                    return .green
                }
            }
        } else {
            // Aqui es menor de ios 13
            return .green
        }
    }
}

class LoginViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var loginButtom: UIButton!
    @IBOutlet weak var emailTextFileld: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - IBActions
    
    @IBAction func loginButtomAction() {
        view.endEditing(true)
        performLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        loginButtom.layer.cornerRadius = 25
        
        loginButtom.backgroundColor = UIColor.customGreen
        
        if UIColor.customGreen == .white {
            loginButtom.setTitleColor(.black , for: .normal)
        }
        
        if #available(iOS 13.0, *) {
           // overrideUserInterfaceStyle = .light
        }
    }
    
    private func performLogin() {
        guard let email = emailTextFileld.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar un correo.", style: .warning).show()
            
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar una contraseña.", style: .warning).show()
            
            return
        }
        
        // Crear request
        let request = LoginRequest(email: email, password: password)
        
        // Iniciamos la carga
        SVProgressHUD.show()
        
        // Llamar a librería de red
        SN.post(endpoint: Endpoints.login,
                model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
                    
                    SVProgressHUD.dismiss()
                    
                    switch response {
                    case .success(let user):
                        self.performSegue(withIdentifier: "showHome", sender: nil)
                        
                        // Guardamos el correo en UserDefaults!
                        UserDefaults.standard.set(user.user.email, forKey: "email-saved")
                        
                        SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
                        
                    case .error(let error):
                        NotificationBanner(title: "Error",
                                           subtitle: error.localizedDescription,
                                           style: .danger).show()
                        
                    case .errorResult(let entity):
                        NotificationBanner(title: "Error",
                                           subtitle: entity.error,
                                           style: .warning).show()
                    }
            
        }
    }
}



