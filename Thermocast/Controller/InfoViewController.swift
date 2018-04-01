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
    var temp = ""
    var imageAsset : UIImage?
    var speed = ""
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherAssetImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameLabel.text = data
        weatherAssetImage.image = imageAsset
        tempLabel.text = temp
        windLabel.text = "\(speed) m/s"
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateClothingAdvise() {
        
    }
    
}
