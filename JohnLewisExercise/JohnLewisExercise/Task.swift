//
//  Task.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import Foundation


protocol Task: class { //We conform to class so we can use identifier equality
    func cancel()
}


extension Operation: Task { }

extension Progress: Task { }

extension URLSessionTask: Task { }
