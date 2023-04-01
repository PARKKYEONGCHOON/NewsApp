//
//  NewsRequestModel.swift
//  NewsApp
//
//  Created by 박경춘 on 2023/04/01.
//

import Foundation

struct NewsRequestModel: Codable {
    
    let start: Int
    let display: Int
    let query: String
    
    
}
