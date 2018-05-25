//
//  MapController.swift
//  MilkFarm
//
//  Created by Aluno on 5/25/18.
//  Copyright © 2018 Lucas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController, MKMapViewDelegate {
    
    var addresses: [String] = []
    var points: [MKPlacemark] = []
    
    @IBOutlet weak var milkMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.milkMap.delegate = self
        addressesToPoints()
    }
    
    func updateMilkMap () {
        self.milkMap.showAnnotations(self.points, animated: true)
        for i in 0..<points.count-1 {
            requestDirections(source: points[i].coordinate, destination: points[(i+1)].coordinate)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addressesToPoints() {
        let queue = OperationQueue()
        queue.name = "Geocode queue"
        queue.maxConcurrentOperationCount = 1
        
        for address in addresses {
            queue.addOperation {
                let request = MKLocalSearchRequest()
                request.naturalLanguageQuery = address
                request.region = self.milkMap.region
                
                let search = MKLocalSearch(request: request)
                
                search.start { (response, error) in
                    if error == nil {
                        if let res = response {
                            for local in res.mapItems {
                                DispatchQueue.main.async {
                                    self.points.append(local.placemark)
                                    self.updateMilkMap()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func requestDirections(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate{ (response, error) in
            if error == nil {
                if let route = response?.routes.first {
                    self.milkMap.addOverlays([route.polyline])
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 1.0
        return renderer
    }
}

