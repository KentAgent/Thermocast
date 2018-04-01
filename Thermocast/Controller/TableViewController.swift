//
//  TableViewController.swift
//  Thermocast
//
//  Created by Georgios on 2018-03-12.
//  Copyright © 2018 Georgios. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

struct Root : Decodable {
    private enum CodingKeys : String, CodingKey {
        case main = "main"
        case weather = "weather"
        case wind = "wind"
    }
    
    let main : Main
    let weather : [Weather]
    let wind : Wind
}

struct Main : Decodable {
    private enum CodingKeys : String, CodingKey { case temp = "temp" }
    let temp : Float
}

struct Weather : Decodable {
    let id : Int?
}

struct Wind : Decodable {
    private enum CudingKeys : String, CodingKey { case speed = "speed" }
    let speed : Float
}


class TableViewController: UITableViewController, CLLocationManagerDelegate, UISearchResultsUpdating, RecieveArray {
    
    func arrayData(array: [String]) {
        cityArray = array
    }
    
    //Variables for prepareForSegue
    var cellName = ""
    var cellTemp = ""
    var cellWeatherAsset : UIImage?
    var cellWindSpeed = ""
    
    
    
    @IBOutlet weak var addButton: UIButton!
    
    
    var cityArray : [String] = []
    
    var searchResult : [String] = []
    
    var searchController : UISearchController!
    
    let weatherDataModel = WeatherData()
    
    lazy var refresher : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc
    func requestData() {
        print("Requesting data to update tableView")
        
        tableView.reloadData()
        
        let deadline = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    //API Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "8ecd8d52a8bb9ccdbef85e0cd12187f5"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "T H E R M O C A S T"
        
        definesPresentationContext = true
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        
        if UserDefaults.standard.stringArray(forKey: "cityArray") != nil {
            cityArray = UserDefaults.standard.stringArray(forKey: "cityArray")!
        }
        
        tableView.refreshControl = refresher
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
        //Save Data
        saveCityList()
    }
    
    func saveCityList() {
        UserDefaults.standard.set(cityArray, forKey: "cityArray")
    }
    
    //Dunno 'bout this...
    func setDesignProperties() {
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.8
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 12.0
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let text = searchController.searchBar.text?.lowercased() {
            searchResult = cityArray.filter({ $0.lowercased().contains(text) })
        } else {
            searchResult = []
        }
        
        tableView.reloadData()
    }
    
    var shouldUseSearchResult : Bool {
        if let text = searchController.searchBar.text {
            if text.isEmpty {
                return false
            } else {
                return searchController.isActive
            }
        } else {
            return false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        //TODO: Add second section with current location
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldUseSearchResult {
            return searchResult.count
        } else {
            return cityArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as! CustomTableViewCell
        
        // Configure the cell...
        
        let array : [String]
        
        if shouldUseSearchResult {
            array = searchResult
        } else {
            array = cityArray
        }
        
        cell.cityLabel.text = array[indexPath.row]
        
        updateWeather(cell: cell)
        
        cellTemp = cell.degreeLabel.text!
        cellWeatherAsset = cell.weatherAsset.image!
        
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
        cell.layer.transform = transform
        
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            cityArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            saveCityList()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = cityArray[sourceIndexPath.row]
        cityArray.remove(at: sourceIndexPath.row)
        cityArray.insert(movedObject, at: destinationIndexPath.row)
        
        saveCityList()
    }
 

    
    // MARK: - Navigation

 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        
        cellName = currentCell.cityLabel.text!
        cellTemp = currentCell.degreeLabel.text!
        cellWeatherAsset = currentCell.weatherAsset.image!
        cellWindSpeed = currentCell.wind
        performSegue(withIdentifier: "weatherInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weatherInfo" {
            let infoVC = segue.destination as! InfoViewController
            
            infoVC.data = cellName
            infoVC.temp = cellTemp
            infoVC.imageAsset = cellWeatherAsset
            infoVC.speed = cellWindSpeed
            
        }
        else if segue.identifier == "addCity" {
            let addCityVC = segue.destination as! AddCity
            
            addCityVC.cityArrayData = cityArray
            
            addCityVC.delegate = self
        }
    }
    
    //MARK: - Networking
    
    func updateWeather(cell: CustomTableViewCell) {
        if let safeString = cell.cityLabel.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(safeString)&appid=\(APP_ID)") {
            
            let request = URLRequest(url: url)
            print(request)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                if let actualError = error {
                    print(actualError)
                } else {
                    if let actualData = data {
                        
                        let decoder = JSONDecoder()
                        
                        do {
                            let weatherResponse = try decoder.decode(Root.self, from: actualData)
                            
                            DispatchQueue.main.async {
                                cell.degreeLabel.text = "\(Int(weatherResponse.main.temp - 273.15))°"
                                let assetNamed = self.weatherDataModel.updateWeatherIcon(condition: weatherResponse.weather[0].id!)
                                cell.weatherAsset.image = UIImage(named: assetNamed)
                                cell.wind = String(weatherResponse.wind.speed)
                            }
                            
                        } catch let e {
                            print("Error parsing JSON: \(e)")
                        }
                        
                    } else {
                        print("Data was nil : (")
                    }
                }
            })
            
            task.resume()
            print("Sending request")
            
        } else {
            print("Bad url string")
        }
        
    }
}
    

