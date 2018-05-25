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

class ViewController: UIViewController {
    
    var addresses: [String] = []
    var points: [CLPlacemark] = []
    
    @IBOutlet weak var milkMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addresses.append("Av. SAP, 188, Cristo Rei, Sao Leopoldo, RS, Brasil")
        addresses.append("Rua Argemiro Ribeiro Moreira, 31, Nova Sapucaia, Sapucaia do Sul, RS, Brasil")
        addresses.append("Rua Natalicio Alves, 90, Parque da Matriz, Cachoeirinha, RS, Brasil")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func parseAdresses () {
        let geoCoder = CLGeocoder()
        for address in addresses {
            print(address)
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard
                    let placemarks = placemarks
                    else {
                        return
                }
                self.points.append(placemarks.first!)
                self.updateMilkMap()
            }
        }
    }
    
    
    @IBAction func test(_ sender: Any) {
        parseAdresses()
    }
    
    func updateMilkMap () {
        print(points)
    }
    
    func test () {
        let address = "Av. SAP, 188, Cristo Rei, Sao Leopoldo, RS, Brasil"
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    return
            }
            print(location)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            self.milkMap.addAnnotation(annotation)
        }
    }
}

