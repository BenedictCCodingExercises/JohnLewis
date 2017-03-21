//
//  Result.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import Foundation


enum Result<T> {
    case success(T)
    case failure(Error)
}
