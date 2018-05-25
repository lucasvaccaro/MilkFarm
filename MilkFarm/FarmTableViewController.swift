//
//  FarmTableViewController.swift
//  MilkFarm
//
//  Created by Aluno on 24/05/2018.
//  Copyright © 2018 Lucas. All rights reserved.
//

import UIKit

class FarmTableViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var farms = [Farm]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedFarms = Farm.load() {
            farms = savedFarms
        }
        updateAddButtonStatus()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return farms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: "FarmCellIdentifier") else {
                fatalError("Could not dequeue a cell")
        }
        
        let farm = farms[indexPath.row]
        cell.textLabel?.text = farm.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            farms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Farm.save(farms)
        }
    }
    
    func updateAddButtonStatus() {
        addButton.isEnabled = farms.count < 10 ? true : false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let farmViewController = segue.destination as! FarmViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selected = farms[indexPath.row]
            farmViewController.farm = selected
        } else if segue.identifier == "showMap" {
            // Sort farms by date and create array with addresses
            let sortedFarms = farms.sorted(by: { $0.productionTime < $1.productionTime })
//            var addresses = [String]()
//            for farm in sortedFarms {
//                addresses.append(farm.address)
//            }
            let mapController = segue.destination as! MapController
            mapController.farms = sortedFarms
        }
    }
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! FarmViewController
        
        if let farm = sourceViewController.farm {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                farms[selectedIndexPath.row] = farm
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: farms.count, section: 0)
                farms.append(farm)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        
        Farm.save(farms)
        updateAddButtonStatus()
    }

}
