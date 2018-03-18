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

class TableViewController: UITableViewController, CLLocationManagerDelegate, UISearchResultsUpdating {
    
    var cellName = ""
    
    @IBOutlet weak var addButton: UIButton!
    
    var weatherDataDictionary : [String : [String : String]] = ["gothenburg" : ["cityName" : "Gothenburg", "weatherIcon" : "snow5", "degrees" : "-30"], "singapore" : ["cityName" : "Singapore", "weatherIcon" : "sunny", "degrees" : "32"], "athens" : ["cityName" : "Athens", "weatherIcon" : "tstorm1", "degrees" : "20"]]
    var keysArray = ["gothenburg", "singapore", "athens"]
    
    var searchResult : [String] = []
    
    var searchController : UISearchController!
    
    //API Stuff
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "8ecd8d52a8bb9ccdbef85e0cd12187f5"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "T H E R M O C A S T"
        
        definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //print("New Result: \(searchController.searchBar.text)")
        if let text = searchController.searchBar.text?.lowercased() {
            searchResult = keysArray.filter({ $0.lowercased().contains(text) })
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return weatherDataDictionary.count
        if shouldUseSearchResult {
            return searchResult.count
        } else {
            return keysArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as! CustomTableViewCell
        
        // Configure the cell...
        
        //cell.cityLabel.text = weatherData[keysArray[indexPath.row][0]]
        
        let array : [String]
        
        if shouldUseSearchResult {
            array = searchResult
        } else {
            array = keysArray
        }
        
        print(indexPath.row)
        cell.cityLabel.text = weatherDataDictionary[array[indexPath.row]]?["cityName"]
        cell.degreeLabel.text = "\(weatherDataDictionary[array[indexPath.row]]?["degrees"] ?? "")°"
        cell.weatherAsset.image = UIImage(named: (weatherDataDictionary[array[indexPath.row]]?["weatherIcon"]!)!)!
        
        //cellName = cell.cityLabel.text!
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addCityButton(_ sender: Any) {
        performSegue(withIdentifier: "addCity", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellName = (weatherDataDictionary[keysArray[indexPath.row]]?["cityName"])!
        performSegue(withIdentifier: "weatherInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weatherInfo" {
            let infoVC = segue.destination as! InfoViewController
            
            infoVC.data = cellName
            
        }
    }
    
}
