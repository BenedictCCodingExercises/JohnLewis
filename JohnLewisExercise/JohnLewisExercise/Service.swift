//
//  Service.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import Foundation


protocol ServiceDelegate: class {

    func serviceDidChangeNetworkActivityStatus(_ service: Service)
}


class Service {

    //MARK: State

    private(set) weak var delegate: ServiceDelegate?

    let session: URLSession

    var isPerformingNetworkActivity: Bool {
        return numberOfActiveNetworkTasks > 0
    }

    private var numberOfActiveNetworkTasks = 0 {
        didSet {
            if oldValue == 0 || numberOfActiveNetworkTasks == 0 {
                self.delegate?.serviceDidChangeNetworkActivityStatus(self)
            }
        }
    }


    //MARK: Instance life cycle

    init(delegate: ServiceDelegate?, sessionConfiguration: URLSessionConfiguration = .default) {
        self.delegate = delegate
        session = URLSession(configuration: sessionConfiguration)
    }


    //MARK: Request enqueuing

    func enqueue<T: Request>(request: T, completion: @escaping (Task, Result<T.ResponseType>) -> Void) -> Task where T.ResponseType.RequestType == T {
        //# Create the request
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

        //# Create the task
        //The Progress instance is a little strange. We need a Task object to pass to the completionHandler. Ideally
        //we'd use the dataTask object but we can't because the completionHandler is invoked from within the dataTask's
        //initializer which prevents us from referencing the dataTask, and hence why the Progress instance to needed.
        let progress = Progress()
        let task = session.dataTask(with: urlRequest) { data, urlResponse, error in
            self.numberOfActiveNetworkTasks -= 1

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
        //# Configure the progress so that it just passes on cancellation requests.
        progress.cancellationHandler = {
            task.cancel()
        }
        //# Fire the task
        task.resume()
        numberOfActiveNetworkTasks += 1
        
        return progress
    }
}
