//
//  String+.swift
//  NewsApp
//
//  Created by 박경춘 on 2023/04/01.
//

import Foundation

extension String {
    var htmlToString: String {
        guard let data = self.data(using: .utf8) else { return "" }

        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            ).string
        } catch {
            return ""
        }
    }
}
