//
//  NewsResponseModel.swift
//  NewsApp
//
//  Created by 박경춘 on 2023/04/01.
//

import Foundation


struct NewsResponseModel: Decodable {
    
    var items: [News] = []
    
}

struct News: Decodable {
    
    let title: String
    let link: String
    let description: String
    let pubDate: String
    
}
