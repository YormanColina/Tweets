//
//  MapViewController.swift
//  PlatziTweets
//
//  Created by Jyferson Colina on 17/02/22.
//

import UIKit
import MapKit
class MapViewController: UIViewController {
    // MARK: IBOutlets
    
    @IBOutlet weak var containerView: UIView!
    
    // MARK: Properties
    
    var posts = [Post]()
    private var map: MKMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupMap()
    }
    
    private func setupMap() {
        map = MKMapView(frame: containerView.bounds)
        
        containerView.addSubview(map ?? UIView())
        
        setupMarkers()
    }
    
    private func setupMarkers() {
        posts.forEach { item in
            let marker = MKPointAnnotation()
            marker.coordinate = CLLocationCoordinate2D(latitude: item.location.latitude, longitude: item.location.longitude)
            
            marker.title = item.text
            marker.subtitle = item.author.names
            
            map?.addAnnotation(marker)
        }
        
        // Buscamos el último post del arreglo
        guard let lastPost = posts.last else {
            print(posts)
            return
        }
        
        let lastPostLocation = CLLocationCoordinate2D(latitude: lastPost.location.latitude,
                                                      longitude: lastPost.location.longitude)
        
        guard let heading = CLLocationDirection(exactly: 12) else {
            return
        }
        
        map?.camera = MKMapCamera(lookingAtCenter: lastPostLocation, fromDistance: 30, pitch: .zero, heading: heading)
    }
}
