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

        //After Loading go to home
        
        MainController.pushViewController(identifier: "home", vc: self, timeSeconds: 3)

    }
    

    
}
