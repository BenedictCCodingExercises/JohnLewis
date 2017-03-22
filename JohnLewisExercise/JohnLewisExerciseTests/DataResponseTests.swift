//
//  DataResponseTests.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import XCTest
@testable import JohnLewisExercise


class DataResponseTests: XCTestCase {
    
    //MARK: Factories

    func newData() -> Data {
        let text = "mumbo JUMBO!"
        return text.data(using: .utf8)!
    }

    func newHTTPURLResponse(url string: String, statusCode: Int = 200, httpVersion: String? = nil, headerFields: [String : String]? = nil) -> HTTPURLResponse {
        let url = URL(string: string)!
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: httpVersion, headerFields: headerFields)!
    }

    //MARK: Valid response tests

    func testValidResponse() throws {
        let urlString = "http://johnlewis.com"
        let url = URL(string: urlString)!
        let request = DataRequest(url: url)
        let data = newData()
        let urlResponse = newHTTPURLResponse(url: urlString)

        let actual = try DataResponse(request: request, data: data, urlResponse: urlResponse, error: nil)

        XCTAssertEqual(actual.request.url, request.url) //We could make request conform to Equatable but we'd only be doing that for the sake of the test. Turtles all the way down.
        XCTAssertEqual(actual.data, data)
    }


    func testNon200Response() {
        let urlString = "http://johnlewis.com"
        let url = URL(string: urlString)!
        let request = DataRequest(url: url)
        let data = newData()
        let urlResponse = newHTTPURLResponse(url: urlString, statusCode: 404)
        do {
            let _ = try DataResponse(request: request, data: data, urlResponse: urlResponse, error: nil)
            XCTFail()
        } catch let actual as ResponseError {
            let expected = ResponseError.unexpectedStatusCode
            XCTAssertEqual(actual, expected)
        } catch {
            XCTFail()
        }
    }


    func testErrorPropogation() {
        enum MockError: Error {
            case error
        }

        let urlString = "http://johnlewis.com"
        let url = URL(string: urlString)!
        let request = DataRequest(url: url)
        let expected = MockError.error
        do {
            let _ = try DataResponse(request: request, data: nil, urlResponse: nil, error: expected)
            XCTFail()
        } catch let actual as MockError {
            //This is a little hacky. We're only catching MockError because that's what we expect based on the test.
            XCTAssertEqual(expected, actual)
        } catch {
            XCTFail()
        }
    }
}
