//
//  PhotoViewController.swift
//  IoT-TechnicalAssessment
//
//  Created by Mohamed Shendy on 11/10/2021.
//

import UIKit
import UIImageColors

class PhotoViewController: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var authorText: UILabel!
    
    var photoURL = ""
    var author = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        authorText.text = author
        mainImage.sd_setImage(with: URL(string:  photoURL), placeholderImage: UIImage(systemName: "photo.artframe"))
        let colors = mainImage.image!.getColors()
        self.view.backgroundColor = colors?.secondary

        authorText.textColor = colors?.primary
    }
    

    @IBAction func openImageAction(_ sender: UIButton) {
        let newImageView = UIImageView(image: mainImage.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true

    }
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }

}
