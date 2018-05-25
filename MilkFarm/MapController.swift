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

class MapController: UIViewController {
    
    var addresses: [String] = []
    var points: [MKPlacemark] = []
    
    @IBOutlet weak var milkMap: MKMapView!
    
    @IBAction func test(_ sender: Any) {
        updateMilkMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addresses.append("Av. SAP, 188, Cristo Rei, Sao Leopoldo, RS, Brasil")
        addresses.append("Rua Argemiro Ribeiro Moreira, 31, Nova Sapucaia, Sapucaia do Sul, RS, Brasil")
        addresses.append("Rua Natalicio Alves, 90, Parque da Matriz, Cachoeirinha, RS, Brasil")
        addressesToPoints()
    }
    
    func updateMilkMap () {
        self.milkMap.showAnnotations(self.points, animated: true)
        for i in 0..<points.count-1 {
            requestDirections(source: points[i].coordinate, destination: points[i+1].coordinate)
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
                                    //self.milkMap.addAnnotation(local.placemark)
                                    self.points.append(local.placemark)
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
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate{ (response, error) in
            if error == nil {
                if let routes = response?.routes {
                    for route in routes {
                        print(route.distance)
                        self.milkMap.addOverlays([route.polyline])
                    }
                }
            }
        }
    }
}

