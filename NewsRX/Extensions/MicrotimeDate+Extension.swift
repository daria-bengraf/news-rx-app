//
//  MicrotimeDate+Extension.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 17.02.2021.
//  Copyright © 2021 Dariya Bengraf. All rights reserved.
//

import Foundation


extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
