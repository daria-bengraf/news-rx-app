//
//  ErrorHandling.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 05.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case forbidden             //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}
