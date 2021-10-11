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
    
    let _headers : HTTPHeaders = ["Accept":"application/json"]
    var mainJSON : JSON?
    var scroll = true

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
            MainController.hideActivityIndicator(vc: self,timeSeconds: 2)
            
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
        
        // check to display add
        if indexPath.row % 5 != 0 || indexPath.row == 0 {
            cell.adView.isHidden = true
        }else{
            cell.adView.isHidden = false
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.mainJSON!.count - 1
        
        if indexPath.row == lastElement {
            
            if scroll {
                currentPage = currentPage + 1
                let api2 = "https://picsum.photos/v2/list?page=\(currentPage)&limit=\(limit)"
                let paramsFilters2 : Parameters = [:]
                MainController.getRequest(apiURL: api2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, params: paramsFilters2, _headers3: _headers,vc: self){
                    (response, message,statusCode) in
                    
                    let oldCount = self.mainJSON!.count // total rows before new request
                    
                    self.mainJSON = try! self.mainJSON!.merged(with: response)
                    
                    let newCount = self.mainJSON!.count // total rows after new request
                    
                    // check if old count equals new count to stop sending request
                    if newCount == oldCount{
                        self.scroll = false
                    }
                    
                    self.listingTable.register(UINib(nibName: "galleryTableViewCell", bundle: nil), forCellReuseIdentifier: "galleryTableViewCell")
                    self.listingTable.delegate = self
                    self.listingTable.dataSource = self
                    self.listingTable.reloadData()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 5 != 0 || indexPath.row == 0 {
            return 310 // height for cell without ad
        }else{
            return 450 // height for cell with ad
        }
    }
}
