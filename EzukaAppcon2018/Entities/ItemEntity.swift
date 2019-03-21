//
//  AppEntity.swift
//  EzukaAppcon2018
//
//  Created by Atsushi KONISHI on 2018/11/06.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import Foundation


struct ItemEntity: Codable {
    var id: Int?
    var title: String?
    var description: String?
    var teamName: String?
    var squareImage: String?
    
    struct Image: Codable {
        var imageURL: String?
        
        enum CodingKeys: String, CodingKey {
            case imageURL = "image_url"
        }
    }
    var Images: [Image]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case teamName = "team_name"
        case Images = "images"
        case squareImage = "square_image"
    }
    
    
}
