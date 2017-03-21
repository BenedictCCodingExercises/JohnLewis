//
//  ImageCache.swift
//  JohnLewisExercise
//
//  Created by Benedict Cohen on 21/03/2017.
//  Copyright © 2017 Benedict Cohen. All rights reserved.
//

import UIKit


class ImageCache {

    let service: Service

    private static let sharedCache = NSCache<NSURL, UIImage>() //We share storage between all ImageCache instances. This would be a bad idea in a 'proper' app. It would be better to inject the cache storage at initialization.


    init(service: Service) {
        self.service = service
    }


    func cachedImage(for url: URL) -> UIImage? {
        let key = url as NSURL
        return ImageCache.sharedCache.object(forKey: key)
    }


    func fetchImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        let request = DataRequest(url: url)
        let _ = service.enqueue(request: request) { _, result in
            switch result {

            case .success(let response):
                //Create image
                guard let image = UIImage(data: response.data) else {
                    completion(nil)
                    return
                }
                //Store image
                let key = url as NSURL
                ImageCache.sharedCache.setObject(image, forKey: key)
                //Done!
                completion(image)

            case .failure:
                completion(nil)
            }
        }

    }
}
