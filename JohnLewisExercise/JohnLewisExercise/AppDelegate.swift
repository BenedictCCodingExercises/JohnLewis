//
//  AppDelegate.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let service = Service()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Create the root of the model and pass it to the root VC
        guard let masterViewController = window?.rootViewController as? MasterViewController else {
            fatalError("Unexpected ViewController hierarchy.")
        }
        masterViewController.dependancies = .objects(service: service)
        
        return true
    }

}

