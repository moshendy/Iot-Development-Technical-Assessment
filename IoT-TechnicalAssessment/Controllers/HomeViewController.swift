//
//  HomeViewController.swift
//  IoT-TechnicalAssessment
//
//  Created by Mohamed Shendy on 11/10/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {

    @IBOutlet weak var listingTable: UITableView!
    let _headers : HTTPHeaders = ["Accept":"application/json","Accept-Language":UserDefaults.standard.string(forKey: "lang") ?? "ar","Authorization":"Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")"]
    var mainJSON : JSON?
    var currentIndex = 0
    
    var currentPage = 1
    var limit = 10

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }
    func loadData(){
        MainController.showActivityIndicator(vc: self, nameGIF: "loading")
        
        let api2 = "https://picsum.photos/v2/list?page=\(currentPage)&limit=\(limit)"
        let paramsFilters2 : Parameters = [:]
        MainController.getRequest(apiURL: api2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, params: paramsFilters2, _headers3: _headers,vc: self){
            (response, message,statusCode) in
            MainController.hideActivityIndicator(vc: self,timeSeconds: 1)
            
                self.mainJSON = response
            
                self.listingTable.register(UINib(nibName: "galleryTableViewCell", bundle: nil), forCellReuseIdentifier: "galleryTableViewCell")
                self.listingTable.delegate = self
                self.listingTable.dataSource = self
                self.listingTable.reloadData()
                
                
        }
        
    }


}
extension HomeViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainJSON!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "galleryTableViewCell", for: indexPath) as! GalleryTableViewCell

        cell.mainImage.sd_setImage(with: URL(string:  "\(self.mainJSON![indexPath.row]["download_url"].string ?? "")"), placeholderImage: UIImage(systemName: "photo.artframe"))

        if (indexPath.row+1) % 4 == 0 {
            print(indexPath.row+1)
            cell.adView.isHidden = false

        }else{
            cell.adView.isHidden = true
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row+1) % 4 == 0 {
            return 450
        }else{
            return 310
        }
    }

}
