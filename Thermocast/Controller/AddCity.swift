//
//  AddCity.swift
//  Thermocast
//
//  Created by Georgios on 2018-03-12.
//  Copyright © 2018 Georgios. All rights reserved.
//

import UIKit

protocol RecieveArray {
    func arrayData(array: [String])
}

class AddCity: UIViewController, UITextFieldDelegate {
    
    var delegate : RecieveArray?
    
    var cityArrayData : [String]!

    @IBOutlet weak var cityTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.cityTextField.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addCityButton(_ sender: UIButton) {
        if cityTextField.text != nil {
            print("Appending \(cityTextField.text!) to cityArrayData")
            cityArrayData.append(cityTextField.text!)
        } else {
            print("You need to type a city")
        }
        print("cityArrayData now contains \(cityArrayData)")
        delegate?.arrayData(array: cityArrayData)
        //dismiss(animated: true, completion: nil)
        
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
