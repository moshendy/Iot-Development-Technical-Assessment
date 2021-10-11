//
//  GalleryModel.swift
//  IoT-TechnicalAssessment
//
//  Created by Mohamed Shendy on 11/10/2021.
//

import Foundation
import ObjectMapper


class GalleryModel: Mappable,Encodable,Decodable {

    var imageURL: String?
    var author: String?
    
    
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        imageURL    <- map["download_url"]
        author         <- map["author"]
    }

}



