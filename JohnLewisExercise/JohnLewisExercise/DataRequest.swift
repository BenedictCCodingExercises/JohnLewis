//
//  DataRequest.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import Foundation


struct DataRequest: Request {

    typealias ResponseType = DataResponse

    let url: URL

    init(url: URL) {
        self.url = url
    }

    func urlRequest() throws -> URLRequest {
        return URLRequest(url: url)
    }
}


struct DataResponse: Response {
    typealias RequestType = DataRequest

    internal var request: RequestType
    let data: Data

    init(request: RequestType, data: Data?, urlResponse: URLResponse?, error: Error?) throws {
        //Check we're in good shape
        if let error = error {
            throw error
        }
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            throw ResponseError.missingURLResponse
        }
        guard urlResponse.statusCode == 200 else {
            throw ResponseError.unexpectedStatusCode
        }
        guard let data = data else {
            throw ResponseError.missingData
        }

        //Set the properties
        self.request = request
        self.data = data
    }
}
