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
    typealias Step = Int
    typealias StepGenerator = UnfoldSequence<Step, (Step?, Bool)>
    func newStepGenerator() -> StepGenerator {
        return sequence(first: 1, next: {$0 + 1})
    }

    //TODO:
    //- Thread
    //- Async on failure
    //- task === task


    //MARK: Tests

    func testInvalidRequest() {
        XCTFail()
    }


    func testNetworkResponseFailure() {
        XCTFail()
    }


    func testResponseObjectFailure() {
        XCTFail()
    }


    func testCancellation() {
        XCTFail()
    }


    func testSuccess() {
        XCTFail()
    }
}
