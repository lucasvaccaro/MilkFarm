//
//  FarmViewController.swift
//  MilkFarm
//
//  Created by Aluno on 24/05/2018.
//  Copyright © 2018 Lucas. All rights reserved.
//

import UIKit

class FarmViewController: UITableViewController {
    
    var farm: Farm?
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var numberBarrelsInput: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func nameEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func addressEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func barrelsEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func nameReturnPressed(_ sender: Any) {
        nameInput.resignFirstResponder()
    }
    
    @IBAction func addressReturnPressed(_ sender: Any) {
        addressInput.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let farm = farm {
            navigationItem.title = "Farm"
            nameInput.text = farm.name
            addressInput.text = farm.address
            datePicker.date = farm.productionTime
            numberBarrelsInput.text = String(farm.numberOfBarrels)
        }
        
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let name = nameInput.text ?? ""
        let address = addressInput.text ?? ""
        let numberOfBarrels = numberBarrelsInput.text ?? ""
        saveButton.isEnabled = !(name.isEmpty || address.isEmpty || numberOfBarrels.isEmpty)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let name = nameInput.text!
        let address = addressInput.text!
        let productionTime = datePicker.date
        let numberOfBarrels = Int(numberBarrelsInput.text!)!
        
        farm = Farm(name: name, address: address, productionTime: productionTime, numberOfBarrels: numberOfBarrels)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
