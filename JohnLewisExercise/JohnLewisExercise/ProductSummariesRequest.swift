//
//  ProductSummariesRequest.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import Foundation



struct ProductSummariesRequest: Request {

    typealias ResponseType = ProductSummariesResponse

    func urlRequest() throws -> URLRequest {
        guard let url = URL(string: "https://api.johnlewis.com/v1/products/search?q=dishwasher&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb&pageSize=20") else {
                fatalError()
        }
        return URLRequest(url: url)
    }
}


//TODO: It would make more sense to centralise the errors rather than having individual errors for each response type.
enum ProductSummariesResponseError: Error {
    case missingURLResponse
    case unexpectedStatusCode
    case missingData
    case invalidResponseBody
}


struct ProductSummariesResponse: Response {
    typealias RequestType = ProductSummariesRequest

    internal var request: RequestType
    let summaries: [ProductSummary]

    init(request: RequestType, data: Data?, urlResponse: URLResponse?, error: Error?) throws {
        //Check we're in good shape
        if let error = error {
            throw error
        }
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            throw ProductSummariesResponseError.missingURLResponse
        }
        guard urlResponse.statusCode == 200 else {
            throw ProductSummariesResponseError.unexpectedStatusCode
        }
        guard let data = data else {
            throw ProductSummariesResponseError.missingData
        }

        //Set the properties
        self.request = request
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        self.summaries = try productSummaries(from: json)
    }

}


private func productSummaries(from json: Any) throws -> [ProductSummary] {
    "TODO"
    return []
}
