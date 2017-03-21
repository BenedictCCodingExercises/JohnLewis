//
//  ProductDetailsRequest.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import Foundation


struct ProductDetailsRequest: Request {

    typealias ResponseType = ProductDetailsResponse

    func urlRequest() throws -> URLRequest {
        fatalError()
    }
}


struct ProductDetailsResponse: Response {

    typealias RequestType = ProductDetailsRequest

    internal var request: RequestType


    init(request: RequestType, data: Data?, urlResponse: URLResponse?, error: Error?) throws {
        fatalError()
    }
}
