//
//  RequestResponse.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import Foundation


protocol Request {
    associatedtype ResponseType: Response

    func urlRequest() throws -> URLRequest
}


protocol Response {
    associatedtype RequestType: Any
    var request: RequestType { get }

    init(request: RequestType, data: Data?, urlResponse: URLResponse?, error: Error?) throws
}
