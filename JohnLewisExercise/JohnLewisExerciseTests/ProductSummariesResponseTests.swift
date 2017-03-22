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

    func newValidJSONData() -> Data {
        let json = "{\"products\": [{\"productId\":\"1913470\",\"type\":\"product\",\"title\":\"Bosch SMV53M40GB Fully Integrated Dishwasher\",\"code\":\"88701205\",\"averageRating\":4.5854,\"reviews\":123,\"price\":{\"was\":\"\",\"then1\":\"\",\"then2\":\"\",\"now\":\"449.00\",\"uom\":\"\",\"currency\":\"GBP\"},\"image\":\"//johnlewis.scene7.com/is/image/JohnLewis/234326372?\",\"additionalServices\":[\"2 year guarantee included\",\"5 years Added Care for your home appliance (includes guarantee period) Â£95.00\"],\"displaySpecialOffer\":\"\",\"promoMessages\":{\"priceMatched\":\"\",\"offer\":\"\",\"customPromotionalMessage\":\"\",\"bundleHeadline\":\"\",\"customSpecialOffer\":{}},\"colorSwatches\":[],\"colorSwatchSelected\":0,\"colorWheelMessage\":\"\",\"outOfStock\":false,\"emailMeWhenAvailable\":false,\"availabilityMessage\":\"\",\"compare\":true,\"fabric\":\"\"}] }"
        return json.data(using: .utf8)!
    }

    func newSummaries() -> [ProductSummary] {
        return [
            ProductSummary(productID: "1913470", price: (was: "", then1: "", then2: "", now: "449.00", uom: "", currency: "GBP"), title: "Bosch SMV53M40GB Fully Integrated Dishwasher", imageURL: URL(string: "http://johnlewis.scene7.com/is/image/JohnLewis/234326372?")!)
        ]
    }

    func newHTTPURLResponse(url string: String = "https://api.johnlewis.com/v1/products/search?q=dishwasher&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb&pageSize=20", statusCode: Int = 200, httpVersion: String? = nil, headerFields: [String : String]? = nil) -> HTTPURLResponse {
        let url = URL(string: string)!
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: httpVersion, headerFields: headerFields)!
    }


    //MARK: Valid response tests

    func testValidResponse() throws {
        let request = ProductSummariesRequest()
        let data = newValidJSONData()
        let urlResponse = newHTTPURLResponse()
        let actual = try ProductSummariesResponse(request: request, data: data, urlResponse: urlResponse, error: nil)
        let expectedSummaries = newSummaries()

        XCTAssertEqual(actual.summaries, expectedSummaries)
    }


    //MARK: Invalid responses tests

    func testInvalidJSON() {
        let request = ProductSummariesRequest()
        let data = "{}".data(using: .utf8)!
        let urlResponse = newHTTPURLResponse()
        do {
            let _ = try ProductSummariesResponse(request: request, data: data, urlResponse: urlResponse, error: nil)
            XCTFail()
        } catch let actual as ResponseError {
            let expected = ResponseError.invalidResponseBody
            XCTAssertEqual(actual, expected)
        } catch {
            XCTFail()
        }
    }


    func testNon200Response() {
        let request = ProductSummariesRequest()
        let data = newValidJSONData()
        let urlResponse = newHTTPURLResponse(statusCode: 404)
        do {
            let _ = try ProductSummariesResponse(request: request, data: data, urlResponse: urlResponse, error: nil)
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
