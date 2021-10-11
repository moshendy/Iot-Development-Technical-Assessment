//
//  SplashViewController.swift
//  IoT-TechnicalAssessment
//
//  Created by Mohamed Shendy on 11/10/2021.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if MainController.isConnectedToInternet() == 1{
            //After Loading go to home
            MainController.pushViewController(identifier: "home", vc: self, timeSeconds: 3)
        }else{
            MainController.viewAlertDialog(vc: self, title: "No internet connection".localized, message: "App needs internet connection.".localized)
        }
    }
    
}
