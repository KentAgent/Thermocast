//
//  InfoViewController.swift
//  Thermocast
//
//  Created by Georgios on 2018-03-15.
//  Copyright © 2018 Georgios. All rights reserved.
//

import UIKit

protocol CanRecieve {
    func dataRecieved(data : String)
}

class InfoViewController: UIViewController {
    
    var delegate : CanRecieve?
    
    var data = ""

    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameLabel.text = data

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
