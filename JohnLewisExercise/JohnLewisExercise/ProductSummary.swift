//
//  ProductSummary.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import Foundation


struct ProductSummary: Equatable {

    let productID: String
    //It's strange that these are strings. I'd expect integers of pence/lowest denomination.
    //We could convert them but that wouldn't add value.
    let price: (was: String, then1: String, then2: String, now: String, uom: String, currency: String)
    let title: String
    let imageURL: URL


    static func ==(lhs: ProductSummary, rhs: ProductSummary) -> Bool {
        //Hmm. Not sure if this is wise. Should we compare all fields?
        return lhs.productID == rhs.productID
    }
}
