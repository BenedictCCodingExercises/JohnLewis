//
//  ProductSummariesRequestTests.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import XCTest
@testable import JohnLewisExercise


class ProductSummariesRequestTests: XCTestCase {

    func testURLRequest() throws {
        let url = URL(string: "https://api.johnlewis.com/v1/products/search?q=dishwasher&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb&pageSize=20")!
        let expected = URLRequest(url: url)
        let actual = try ProductSummariesRequest().urlRequest()

        XCTAssertEqual(expected, actual)
    }
}
