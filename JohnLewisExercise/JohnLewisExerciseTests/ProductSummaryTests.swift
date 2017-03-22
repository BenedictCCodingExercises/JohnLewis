//
//  ProductSummaryTests.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import XCTest
@testable import JohnLewisExercise


class ProductSummaryTests: XCTestCase {
    
    func testEquality() {
        let id = "id"
        //Note that only the productIDs need be equal for summaries to be considered equal. Whether this is a sensible design choice is open to debate.
        let p1 = ProductSummary(productID: id, price: (was: "1", then1: "1", then2: "1", now: "1", uom: "1", currency: "1"), title: "1", imageURL: URL(string: "http://example.com/1")!)
        let p2 = ProductSummary(productID: id, price: (was: "2", then1: "2", then2: "2", now: "2", uom: "2", currency: "2"), title: "2", imageURL: URL(string: "http://example.com/2")!)
        XCTAssertEqual(p1, p2)
    }

    func testInequality() {
        let p1 = ProductSummary(productID: "id1", price: (was: "1", then1: "1", then2: "1", now: "1", uom: "1", currency: "1"), title: "1", imageURL: URL(string: "http://example.com/1")!)
        let p2 = ProductSummary(productID: "id2", price: (was: "1", then1: "1", then2: "1", now: "1", uom: "1", currency: "1"), title: "1", imageURL: URL(string: "http://example.com/1")!)
        XCTAssertNotEqual(p1, p2)
    }

}
