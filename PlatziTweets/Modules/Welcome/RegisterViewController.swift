//
//  RegisterViewController.swift
//  PlatziTweets
//
//  Created by Jyferson Colina on 27/01/22.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD


class RegisterViewController: UIViewController {
    //  MARK: - Outlets
    @IBOutlet weak var registerButtom: UIButton!
    @IBOutlet weak var emailTextFileld: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    // MARK: - IBActions
    
    @IBAction func registerButtomAction() {
        view.endEditing(true)
        performRegister()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        registerButtom.layer.cornerRadius = 25
    }
    
    private func performRegister() {
        guard let email = emailTextFileld.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar un correo.", style: .warning).show()
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar una contraseña.", style: .warning).show()
            return
        }
        
        guard let names = nameTextField.text, !names.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Debes especificar tu nombre y apellido.", style: .warning).show()
            return
        }
        
        // Crear request
        let request = RegisterRequest(email: email, password: password, names: names)
        
        // Indicar la carga a usuario
        SVProgressHUD.show()
        
        // Llamar al servicio
        SN.post(endpoint: Endpoints.register,model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
            
            // Cerramos la carga al usuario
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

 
