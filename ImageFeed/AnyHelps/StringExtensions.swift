//
//  StringExtensions.swift
//  ImageFeed
//
//  Created by Jedi on 30.08.2023.
//

import Foundation

extension String {
    var dateTimeString: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: self)
    }
}