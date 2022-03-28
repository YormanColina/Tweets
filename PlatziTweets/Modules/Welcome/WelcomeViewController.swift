//
//  WelcomeViewController.swift
//  PlatziTweets
//
//  Created by Jyferson Colina on 27/01/22.
//

import UIKit

class WelcomeViewController: UIViewController {
//  MARK: - Outlets
    @IBOutlet weak var loginButtom: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        loginButtom.layer.cornerRadius = 25
    }
}
