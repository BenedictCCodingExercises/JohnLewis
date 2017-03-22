//
//  DataRequestTests.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 22/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import XCTest
@testable import JohnLewisExercise


class DataRequestTests: XCTestCase {

    func testURLRequest() throws {
        let url = URL(string: "https://api.johnlewis.com/v1/products/search?q=dishwasher&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb&pageSize=20")!
        let request = DataRequest(url: url)

        let expected = URLRequest(url: url)
        let actual = try request.urlRequest()
        XCTAssertEqual(expected, actual)
    }

}
