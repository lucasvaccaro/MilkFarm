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

class MilkAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String!
    var subtitle: String!
    var image: UIImage!
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

class MapController: UIViewController, MKMapViewDelegate {
    
    //var addresses: [String] = []
    var farms: [Farm] = []
    //var points: [MKPlacemark] = []
    var points: [MilkAnnotation] = []
    
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
        
        for farm in farms {
            queue.addOperation {
                let request = MKLocalSearchRequest()
                request.naturalLanguageQuery = farm.address
                request.region = self.milkMap.region
                
                let search = MKLocalSearch(request: request)
                
                search.start { (response, error) in
                    if error == nil {
                        if let res = response {
                            for local in res.mapItems {
                                DispatchQueue.main.async {
                                    let point = MilkAnnotation(title: farm.name, subtitle: "Barrels: \(farm.numberOfBarrels)", coordinate: local.placemark.coordinate)
                                    //self.points.append(local.placemark)
                                    self.points.append(point)
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = self.milkMap.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "milkBarrel")
        return annotationView
    }
}

