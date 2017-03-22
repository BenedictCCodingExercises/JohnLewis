//
//  RootViewController.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 22/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import UIKit


class RootViewController: UINavigationController {

    //MARK: State

    lazy var service: Service = {
        let service = Service(delegate: self)
        return service
    }()


    //MARK: Instance life cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        //Pass the model to the masterVC.
        guard let masterViewController = childViewControllers.first as? MasterViewController else {
            fatalError("Unexpected ViewController hierarchy.")
        }
        masterViewController.dependancies = .objects(service: service)

    }
   
}


//MARK:- ServiceDelegate

extension RootViewController: ServiceDelegate {

    func serviceDidChangeNetworkActivityStatus(_ service: Service) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = service.isPerformingNetworkActivity
    }

}
