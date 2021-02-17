//
//  StringDate+Extension.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 16.02.2021.
//  Copyright © 2021 Dariya Bengraf. All rights reserved.
//

import Foundation

extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension Date {

    func toString(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}
