//
//  ProductSummariesResponseTests.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import XCTest
@testable import JohnLewisExercise




class ProductSummariesResponseTests: XCTestCase {

    //MARK: Factories

    func newJSONData() -> Data {
        let json = "{}"
        return json.data(using: .utf8)!
    }

    func newHTTPURLResponse(url string: String = "http://example.com", statusCode: Int = 200, httpVersion: String? = nil, headerFields: [String : String]? = nil) -> HTTPURLResponse {
        let url = URL(string: string)!
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: httpVersion, headerFields: headerFields)!
    }

    //MARK: Tests

    func testInvalidJSON() {
        XCTFail()
    }


    func testNon200Response() {
        let request = ProductSummariesRequest()
        let data = newJSONData()
        let urlResponse = newHTTPURLResponse(statusCode: 404)
        do {
            let _ = try ProductSummariesResponse(request: request, data: data, urlResponse: urlResponse, error: nil)
            XCTFail()
        } catch let actual as ProductSummariesResponseError {
            let expected = ProductSummariesResponseError.unexpectedStatusCode
            XCTAssertEqual(actual, expected)
        } catch {
            XCTFail()
        }
    }


    func testErrorPropogation() {
        enum MockError: Error {
            case error
        }

        let request = ProductSummariesRequest()
        let expected = MockError.error
        do {
            let _ = try ProductSummariesResponse(request: request, data: nil, urlResponse: nil, error: expected)
            XCTFail()
        } catch let actual as MockError {
            //This is a little hacky. We're only catching MockError because that's what we expect based on the test.
            XCTAssertEqual(expected, actual)
        } catch {
            XCTFail()
        }
    }

}
