//
//  ProductsListRequest.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import Foundation


struct ProductsListRequest: Request {

    typealias ResponseType = ProductsListResponse

    func urlRequest() throws -> URLRequest {
        fatalError()
    }
}


struct ProductsListResponse: Response {

    typealias RequestType = ProductsListRequest

    internal var request: RequestType


    init(request: RequestType, data: Data?, urlResponse: URLResponse?, error: Error?) throws {
        fatalError()
    }
}
