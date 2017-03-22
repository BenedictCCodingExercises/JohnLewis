//
//  ServiceTests.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import XCTest
@testable import JohnLewisExercise


class ServiceTests: XCTestCase {

    //MARK: Helpers

    enum MockError: Error {
        case requestError
        case responseError
    }

    struct MockRequest: Request {
        typealias ResponseType = MockResponse
        let requestShouldThrow: Bool
        let responseShouldThrow: Bool

        func urlRequest() throws -> URLRequest {
            if requestShouldThrow {
                throw MockError.requestError
            }
            let url = URL(string: "https://example.com")!
            return URLRequest(url: url)
        }
    }

    struct MockResponse: Response {
        typealias RequestType = MockRequest
        let request: RequestType

        init(request: RequestType, data: Data?, urlResponse: URLResponse?, error: Error?) throws {
            if let error = error {
                throw error
            }
            if request.responseShouldThrow {
                throw MockError.responseError
            }
            self.request = request
        }
    }


    typealias Step = Int
    typealias StepGenerator = UnfoldSequence<Step, (Step?, Bool)>
    func newStepGenerator() -> StepGenerator {
        return sequence(first: 1, next: {$0 + 1})
    }


    //MARK: Tests

    var task: Task?
    var service: Service!

    override func setUp() {
        task = nil
        service = Service(delegate: nil)
    }

    //In all casses:
    //- completionHandler is executed on the main *queue*
    //- completionHandler is executed async
    //- task === task

    func testInvalidRequest() {
        let request = MockRequest(requestShouldThrow: true, responseShouldThrow: false)
        var expectedSteps = newStepGenerator()

        let expectCompletionHandler = expectation(description: "")
        self.task = service.enqueue(request: request) { task, result in
            expectCompletionHandler.fulfill()
            XCTAssert(Thread.isMainThread) //This is technically incorrect as the mainThread is different from the mainQueue, but for our purposes it is fine.
            XCTAssertEqual(expectedSteps.next(), Step(2))
            XCTAssert(self.task === task)
            switch result {
            case .failure(let actualError):
                let expectedError = MockError.requestError
                XCTAssertEqual(actualError as? MockError, expectedError)
            default:
                XCTFail()
            }
        }
        XCTAssertEqual(expectedSteps.next(), Step(1))
        self.waitForExpectations(timeout: 5, handler: nil)
    }


    func testNetworkResponseFailure() {
        //Hmm. Setting up the conditions for this test is tricky. We need the requests to fail at a layer below HTTP.
        //The best I can think of is to create a URLSessionConfiguration that only accepts SSLv3 and then attempt to 
        //connect to a server which doesn't supprt SSLv3. The problem is that I can't find a server that's configured
        //like that.

//        let config = URLSessionConfiguration.default
//        config.tlsMinimumSupportedProtocol = .sslProtocol3
//        self.service = Service(delegate: nil, sessionConfiguration: config)
//
//        let request = MockRequest(requestShouldThrow: false, responseShouldThrow: false)
//        var expectedSteps = newStepGenerator()
//
//        let expectCompletionHandler = expectation(description: "")
//        self.task = service.enqueue(request: request) { task, result in
//            expectCompletionHandler.fulfill()
//            XCTAssert(Thread.isMainThread) //This is technically incorrect as the mainThread is different from the mainQueue, but for our purposes it is fine.
//            XCTAssertEqual(expectedSteps.next(), Step(2))
//            XCTAssert(self.task === task)
//            switch result {
//            case .failure(let actualError):
//                let expectedError = MockError.requestError
//                XCTAssertEqual(actualError as? MockError, expectedError)
//            default:
//                XCTFail()
//            }
//        }
//        XCTAssertEqual(expectedSteps.next(), Step(1))
//        self.waitForExpectations(timeout: 5, handler: nil)
    }


    func testResponseObjectFailure() {
        let request = MockRequest(requestShouldThrow: false, responseShouldThrow: true)
        var expectedSteps = newStepGenerator()

        let expectCompletionHandler = expectation(description: "")
        self.task = service.enqueue(request: request) { task, result in
            expectCompletionHandler.fulfill()
            XCTAssert(Thread.isMainThread) //This is technically incorrect as the mainThread is different from the mainQueue, but for our purposes it is fine.
            XCTAssertEqual(expectedSteps.next(), Step(2))
            XCTAssert(self.task === task)
            switch result {
            case .failure(let actualError):
                let expectedError = MockError.responseError
                XCTAssertEqual(actualError as? MockError, expectedError)
            default:
                XCTFail()
            }
        }
        XCTAssertEqual(expectedSteps.next(), Step(1))
        self.waitForExpectations(timeout: 5, handler: nil)
    }


    func testCancellation() {
        //This is test is a probably bunkum because cancellation is communicated as an error to the completionHandler
        //and it is the response objects responsibility to check and throw the error. Therefore check that a response 
        //throws when it is initialized with an error is actual all that's required.
        let request = MockRequest(requestShouldThrow: false, responseShouldThrow: false)
        var expectedSteps = newStepGenerator()

        let expectCompletionHandler = expectation(description: "")
        self.task = service.enqueue(request: request) { task, result in
            expectCompletionHandler.fulfill()
            XCTAssert(Thread.isMainThread) //This is technically incorrect as the mainThread is different from the mainQueue, but for our purposes it is fine.
            XCTAssertEqual(expectedSteps.next(), Step(2))
            XCTAssert(self.task === task)
            switch result {
            case .failure(let actualError as NSError):
                XCTAssertEqual(actualError.domain, NSURLErrorDomain)
                XCTAssertEqual(actualError.code, NSURLErrorCancelled)
            default:
                XCTFail()
            }
        }
        XCTAssertEqual(expectedSteps.next(), Step(1))
        self.task?.cancel()

        self.waitForExpectations(timeout: 5, handler: nil)
    }


    func testSuccess() {
        let request = MockRequest(requestShouldThrow: false, responseShouldThrow: false)
        var expectedSteps = newStepGenerator()

        let expectCompletionHandler = expectation(description: "")
        self.task = service.enqueue(request: request) { task, result in
            expectCompletionHandler.fulfill()
            XCTAssert(Thread.isMainThread) //This is technically incorrect as the mainThread is different from the mainQueue, but for our purposes it is fine.
            XCTAssertEqual(expectedSteps.next(), Step(2))
            XCTAssert(self.task === task)
            switch result {
            case .success:
                XCTAssert(true)
            default:
                XCTFail()
            }
        }
        XCTAssertEqual(expectedSteps.next(), Step(1))

        self.waitForExpectations(timeout: 5, handler: nil)

    }
}
