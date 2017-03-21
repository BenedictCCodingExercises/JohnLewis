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
    guard let root = json as? [String: Any],
        let products = root["products"] as? [Any] else {
            throw ProductSummariesResponseError.invalidResponseBody
    }

    return try products.map({ try productSummary(from: $0) })
 }


 private func productSummary(from json: Any) throws -> ProductSummary {
    guard let root = json as? [String: Any],
        let productID = root["productId"] as? String,
        let price = root["price"] as? [String: String],
        let was = price["was"],
        let then1 = price["then1"],
        let then2 = price["then2"],
        let now = price["now"],
        let uom = price["uom"],
        let currency = price["currency"],
        let title = root["title"] as? String,
        let imageURLString = root["image"] as? String,
        let imageURL = URL(string: imageURLString)
        else {
            throw ProductSummariesResponseError.invalidResponseBody
    }
    let summary = ProductSummary(productID: productID, price: (was: was, then1: then1, then2: then2, now: now, uom: uom, currency: currency), title: title, imageURL: imageURL)
    return summary
 }
