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
    @IBOutlet weak var clothingTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cityNameLabel.text = data
        weatherAssetImage.image = imageAsset
        tempLabel.text = temp
        windLabel.text = "\(speed) m/s"
        
        clothingTextView.textContainerInset = UIEdgeInsetsMake(18,15,18,15)
        
        performAnimations()
        
//        let clothingTemp = Int(temp)!
//        let clothingSpeed = Float(speed)!
//
//        updateClothingAdvise(temp: clothingTemp, speed: clothingSpeed, weatherAsset: imageAsset!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performAnimations() {
        weatherAssetImage.alpha = 0
        cityNameLabel.alpha = 0
        tempLabel.alpha = 0
        windLabel.alpha = 0
        
        let transformWeatherAsset = CATransform3DTranslate(CATransform3DIdentity, -250, 500, 0)
        weatherAssetImage.layer.transform = transformWeatherAsset
        
        let transformClothingTextView = CATransform3DTranslate(CATransform3DIdentity, 0, 400, 0)
        clothingTextView.layer.transform = transformClothingTextView
        
        let transformCityNameLabel = CATransform3DTranslate(CATransform3DIdentity, 0, -400, 0)
        cityNameLabel.layer.transform = transformCityNameLabel
        
        UIView.animate(withDuration: 1.0) {
            self.weatherAssetImage.alpha = 1.0
            self.weatherAssetImage.layer.transform = CATransform3DIdentity
            self.cityNameLabel.alpha = 1.0
            self.tempLabel.alpha = 1.0
            self.windLabel.alpha = 1.0
            self.clothingTextView.layer.transform = CATransform3DIdentity
            self.cityNameLabel.layer.transform = CATransform3DIdentity
        }
    }
    
    func updateClothingAdvise(temp: Int, speed: Float, weatherAsset: UIImage) {
        var weatherAdvise : String
        
        let tempAdviseHot = "It's hot like a mf."
        let tempAdviseCold = "It's cold like a mf."
        
        let windAdviseLow = " and the wind is almost standing still."
        let windAdviseHigh = " and the wind blows like a bi*ch."
        
        let rainAdviseLow = " No rain to be spotted tho. Good for you"
        let rainAdviseHigh = " Better grab an umbrella. You might get hit by a shower."
        
        if temp > 5 && speed > 3.0 && (weatherAsset == #imageLiteral(resourceName: "light_rain") || weatherAsset == #imageLiteral(resourceName: "shower3")) {
            weatherAdvise = tempAdviseCold + windAdviseLow + rainAdviseHigh
        }
        else {
            weatherAdvise = "I dunno what you should wear tbh... Better stay indoors."
        }
        
        clothingTextView.text = weatherAdvise
    }
    
}
