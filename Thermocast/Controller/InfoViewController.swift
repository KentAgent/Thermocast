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
    var actualTemp : Int?
    
    
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
        
        updateClothingAdvise(temp: actualTemp!, speed: Float(speed)!, weatherAsset: imageAsset!)
        
        clothingTextView.textContainerInset = UIEdgeInsetsMake(18,15,18,15)
        
        performAnimations()
        
//        let clothingTemp : Int = Int(temp)!
//        let clothingSpeed : Float = Float(speed)!

        
        
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
        
        if temp < 5 && (weatherAsset == #imageLiteral(resourceName: "light_rain") || weatherAsset == #imageLiteral(resourceName: "shower3")) {
            weatherAdvise = "Bring a jacked, an umbrella and a positive attitude. You'll need it in this dull weather..."
        }
        else if temp <= 5 && weatherAsset == #imageLiteral(resourceName: "sunny") {
            weatherAdvise = "Don't let the sun make a fool out you you. It's still cold  a mf. Bring a jacket, some thick socks and a beanie."
        }
        else if temp >= 5 && temp <= 15 && speed >= 3.0 && speed <= 7 && (weatherAsset == #imageLiteral(resourceName: "sunny") || weatherAsset == #imageLiteral(resourceName: "cloudy2")) {
            weatherAdvise = "There's that spring weather. Wear a sweater and be happy, u son of a bi*ch. "
        }
        else if temp > 15 && temp < 25 && speed >= 5 && (weatherAsset == #imageLiteral(resourceName: "sunny") || weatherAsset == #imageLiteral(resourceName: "cloudy2")) {
            weatherAdvise = "Now that's a comfy weather! Put a sweater in the bag just in case."
        }
        else if temp < -30 {
            weatherAdvise = "What are you even thinking!? Can't you see that shit through the window?? Lock the doors and pray that you got enough food to survive."
        }
        else if temp >= 50 && (weatherAsset == #imageLiteral(resourceName: "sunny") || weatherAsset == #imageLiteral(resourceName: "cloudy2")) {
            weatherAdvise = "If you're planning to leave the house, better leave your clothes as well.."
        }
        else if temp >= 26 && temp <= 35 && speed <= 6.0 && (weatherAsset == #imageLiteral(resourceName: "sunny") || weatherAsset == #imageLiteral(resourceName: "cloudy2")) {
            weatherAdvise = "Now that's what I'm talking about. Grab that swimwear and head to the beach."
        }
        else {
            weatherAdvise = "I dunno what you should wear tbh... Better stay indoors."
        }
        
        clothingTextView.text = weatherAdvise
    }
    
}
