//
//  Service.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import Foundation


class Service {

    let session = URLSession()


    func enqueue<T: Request>(request: T, completion: @escaping (Task, Result<T.ResponseType>) -> Void) -> Task where T.ResponseType.RequestType == T {
        //Create the request
        let urlRequest: URLRequest
        do {
            urlRequest = try request.urlRequest()
        } catch {
            let task = Progress()
            DispatchQueue.main.async {
                completion(task, .failure(error))
            }
            return task
        }

        //Create the task
        //The progress object is a little strange. It exists to work around the fact that we can't use task within its own completion handler.
        //We need a Task instance to pass to the completion handler and as the return value.
        let progress = Progress()
        let task = session.dataTask(with: urlRequest) { data, urlResponse, error in
            do {
                let response = try T.ResponseType(request: request, data: data, urlResponse: urlResponse, error: error)
                DispatchQueue.main.async {
                    completion(progress, .success(response))
                }

            } catch {
                DispatchQueue.main.async {
                    completion(progress, .failure(error))
                }
            }
        }
        //Configure the progress so that it just passes on cancellation requests.
        progress.cancellationHandler = {
            task.cancel()
        }
        //Fire the task
        task.resume()

        return progress
    }

}
