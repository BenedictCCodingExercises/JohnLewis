//
//  MasterViewController.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import UIKit


class MasterViewController: UIViewController {

    //MARK: State

    enum Dependencies {
        case missing
        case objects(service: Service)
    }

    var dependancies = Dependencies.missing


    fileprivate enum State {
        case empty
        case fetching(Task)
        case loaded(ProductSummariesResponse)
        case failed(Error)
    }

    fileprivate var state = State.empty

    @IBOutlet private var collectionView: UICollectionView!
    

    //MARK: View life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSummaries() {
            self.refreshView()
        }
        refreshView()
    }

    
    private func refreshView() {
        guard isViewLoaded else {
            return
        }

        collectionView.reloadData()
    }


    //MARK: Data fetching

    private func fetchSummaries(completion: @escaping (Void) -> Void) {
        guard case .objects(let service) = dependancies else {
            fatalError("Dependancies must be set so that data can be fetched.")
        }

        switch state {
        //If we've already requested the data then bail
        case .fetching, .loaded: return
        //Go on...
        case .empty, .failed: break
        }

        //Request the data
        let request = ProductSummariesRequest()
        let task = service.enqueue(request: request) { task, result in
            //Ensure that the task is what we expect
            guard case .fetching(let activeTask) = self.state,
            task === activeTask else {
                fatalError("Invalid state")
            }

            //Update state
            switch result {
            case .success(let response):
                self.state = .loaded(response)

            case .failure(let error):
                self.state = .failed(error)
            }

            //Done! (We use a completion block so that this data fetching method doesn't need to know about the view)
            completion()
        }

        //Update state
        self.state = .fetching(task)
    }
}


extension MasterViewController: UICollectionViewDataSource, UICollectionViewDelegate  {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard case .loaded(let response) = state else {
            return 0
        }
        return response.summaries.count
    }


    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard case .loaded(let response) = state else {
            fatalError()
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductSummaryCell.reuseIdentifier, for: indexPath) as! ProductSummaryCell
        let summary = response.summaries[indexPath.item]
        configure(cell, with: summary)

        return cell
    }


    private func configure(_ cell: ProductSummaryCell, with summary: ProductSummary) {
        cell.titleLabel.text = summary.title
        "TODO:"
    }
}

