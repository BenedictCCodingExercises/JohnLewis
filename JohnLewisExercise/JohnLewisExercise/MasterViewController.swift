//
//  MasterViewController.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import UIKit


class MasterViewController: UIViewController {

    enum State {
        case waiting
        case loaded
        case failed
    }

    var state = State.waiting


    //MARK: View life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
    }

    
    private func refreshView() {

    }
}



extension MasterViewController: UICollectionViewDataSource, UICollectionViewDelegate  {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError()
    }


    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError()
    }

}

