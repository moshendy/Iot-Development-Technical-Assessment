//
//  HomeViewController.swift
//  IoT-TechnicalAssessment
//
//  Created by Mohamed Shendy on 11/10/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import DataCache
import ObjectMapper

class HomeViewController: UIViewController {
    
    @IBOutlet weak var listingTable: UITableView!
    
    let _headers : HTTPHeaders = ["Accept":"application/json"]
    var mainJSON :[GalleryModel]?
    var scroll = true
    
    var currentIndex = 0
    var page = 1
    var limit = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //if there is no internet app display the cached JSON else get new data from API.

        if MainController.isConnectedToInternet() == 1{
            loadData()
        }else{
            do {
                mainJSON = try DataCache.instance.readCodable(forKey: "CachedJSON")
            } catch {
                print("Read error \(error.localizedDescription)")
            }
            listingTable.register(UINib(nibName: "galleryTableViewCell", bundle: nil), forCellReuseIdentifier: "galleryTableViewCell")
            listingTable.delegate = self
            listingTable.dataSource = self
            listingTable.reloadData()
            //reload table

        }
    }
    
    func loadData(){
        MainController.showActivityIndicator(vc: self, nameGIF: "loading") //show loading gif

        
        // get first 15 row
        
        let api2 = "https://picsum.photos/v2/list?page=\(page)&limit=15"
        let paramsFilters2 : Parameters = [:]
        MainController.getRequest(apiURL: api2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, params: paramsFilters2, _headers3: _headers,vc: self){
            (response, message,statusCode) in
            
            
            
            self.mainJSON = Mapper<GalleryModel>().mapArray(JSONArray: response.rawValue as! [[String : Any]])
            //cache the first 15 rows to display so the app could work in offline mode.
            do {
                try DataCache.instance.write(codable: self.mainJSON, forKey: "CachedJSON")
            } catch {
                print("Write error \(error.localizedDescription)")
            }
            
            //reload table
            self.listingTable.register(UINib(nibName: "galleryTableViewCell", bundle: nil), forCellReuseIdentifier: "galleryTableViewCell")
            self.listingTable.delegate = self
            self.listingTable.dataSource = self
            self.listingTable.reloadData()
            
            MainController.hideActivityIndicator(vc: self,timeSeconds: 2) // hide loading gif

            
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass the image and author to the details screen
        if segue.identifier == "viewPost"{
            let destinationViewController = segue.destination as! PhotoViewController
            destinationViewController.photoURL = self.mainJSON![currentIndex].imageURL ?? ""
            destinationViewController.author = self.mainJSON![currentIndex].author ?? ""
            
        }
    }
    
    
}
extension HomeViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainJSON!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "galleryTableViewCell", for: indexPath) as! GalleryTableViewCell
        cell.mainImage.sd_setImage(with: URL(string:  "\(self.mainJSON![indexPath.row].imageURL ?? "")"), placeholderImage: UIImage(systemName: "photo.artframe"))
        
        // check to display add
        if (indexPath.row+1) % 5 != 0{
            cell.adView.isHidden = true
        }else{
            cell.adView.isHidden = false
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        MainController.gotoPage(identifier: "viewPost", vc: self, timeSeconds: 0)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.mainJSON!.count - 1

        if indexPath.row == lastElement { // check if last element in the tableview to load more data

            if MainController.isConnectedToInternet() == 1{

                if scroll {
                    page = page + 1
                    let api2 = "https://picsum.photos/v2/list?page=\(page)&limit=\(limit)"
                    let paramsFilters2 : Parameters = [:]
                    MainController.getRequest(apiURL: api2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, params: paramsFilters2, _headers3: _headers,vc: self){
                        (response, message,statusCode) in

                        let oldCount = self.mainJSON!.count // total rows before new request

                        // get new JSON and convert it to model object
                        let newMainJSON : [GalleryModel] = Mapper<GalleryModel>().mapArray(JSONArray: response.rawValue as! [[String : Any]])

                        self.mainJSON = self.mainJSON! + newMainJSON // merge the old data with new rows

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
            }else{
                // Display alert if there is no internet connection
                MainController.viewAlertDialog(vc: self, title: "No internet connection".localized, message: "App needs internet connection.".localized)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row+1) % 5 != 0{
            return 310 // height for cell without ad
        }else{
            return 450 // height for cell with ad
        }
    }
}
