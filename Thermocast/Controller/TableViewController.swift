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


class TableViewController: UITableViewController, CLLocationManagerDelegate, UISearchResultsUpdating, RecieveArray, UIGestureRecognizerDelegate {
    
    func arrayData(array: [String]) {
        cityArray = array
    }
    
    //Variables for prepareForSegue
    var cellName = ""
    var cellTemp = ""
    var cellWeatherAsset : UIImage?
    var cellWindSpeed = ""
    var cellActualTemp : Int?
    
    
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func bottomBarChart(_ sender: Any) {
        performSegue(withIdentifier: "chart", sender: self)
    }
    
    var cityArray : [String] = []
    
    var searchResult : [String] = []
    
    //Add longPressedRows to this array. Make a prepare for segue after two items has been longpressed.
    //Create Diagram with charts on new ViewController triggered by segue.
    var longPressedRows : [Int] = []
    var longPressedCells : [CustomTableViewCell] = []
    var markedCells : [CustomTableViewCell] = []
    
    var originalCellColor : UIColor?
    
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
        
        //Handle Longpress
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(TableViewController.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        
        tableView.refreshControl = refresher
        
    }
    
    //Longpress cells to add to list of cities that will have weather score statistics displayed
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint) {
                
                let pressedCell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
                print("Longpressed row at indexpath: \(indexPath.row)")
                
                if !pressedCell.isMarked {
                    longPressedRows.append(indexPath.row)
                    longPressedCells.append(pressedCell)
                    pressedCell.backgroundColor = UIColor.lightGray
                    longPressedRows.sort()
                    pressedCell.isMarked = true
                }
                else if pressedCell.isMarked {
                    let filterArray = longPressedRows.filter {$0 != indexPath.row}
                    longPressedRows = filterArray
                    pressedCell.backgroundColor = originalCellColor
                    pressedCell.isMarked = false
                }
                
                for item in longPressedCells {
                    print("longPressedCells now contain: \(item.cityLabel.text!)")
                }
                
                
                print("longPressedRows now contain: \(longPressedRows)")
            }
        }
    }
    
    //Returns the marked cells in the tableView
    
    //Ok Så min tanke med den här metoden var att den skulle ta alla celler som hade cell.isMarked == true och lägga dom i en array av
    //[CustomTableViewCell] för att sedan skicka vidare dessa med prepForSegue till ChartViewController.
    //Då cellerna skapas upp efter hand och endast de synliga cellerna går att få tag på får jag inte detta att fungera riiiktigt som jag tänkt mig..
    //Finns säkert nån bättre lösning. Några tips?
    
    func getMarkedCells() {
        print("Running getMarkedCells function")
        //let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as! CustomTableViewCell
        //var markedCells = [CustomTableViewCell]()
        
//        for _ in cityArray {
//            if cell.isMarked {
//                markedCells.append(cell)
//                print("Marked cells: \(markedCells)")
//            }
//        }
        
        //Loops through the cells and gets the marked ones to send to ChartViewController
        let sectionCount = 0
        
        //for section in 0 ..< sectionCount {
            let rowCount = tableView.numberOfRows(inSection: sectionCount)
            //var list = [CustomTableViewCell]()
            print("Number of rows in section \(sectionCount): \(rowCount)")
            
            for row in 0 ..< rowCount {
                let cell = tableView.cellForRow(at: IndexPath(row: row, section: sectionCount)) as! CustomTableViewCell
                if cell.isMarked {
                    markedCells.append(cell)
                }
                else {
                    print("Cell at row \(row) was not marked")
                }
            }
        //}
        
        //return markedCells
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
        
        originalCellColor = cell.backgroundColor
        
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
        cellActualTemp = currentCell.actualTemp
        performSegue(withIdentifier: "weatherInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weatherInfo" {
            let infoVC = segue.destination as! InfoViewController
            
            infoVC.data = cellName
            infoVC.temp = cellTemp
            infoVC.imageAsset = cellWeatherAsset
            infoVC.speed = cellWindSpeed
            infoVC.actualTemp = cellActualTemp
            
        }
        else if segue.identifier == "addCity" {
            let addCityVC = segue.destination as! AddCity
            
            addCityVC.cityArrayData = cityArray
            
            addCityVC.delegate = self
        }
        else if segue.identifier == "chart" {
            let chartVC = segue.destination as! ChartViewController
            
            getMarkedCells()
            
            chartVC.customCellArray = markedCells
            print("After segue, markedCells are now: \(markedCells.count)")
        }
    }
    
//    func getCellsFromIndexPath(indexPath: IndexPath, arrayWithIndex: [Int]) -> [CustomTableViewCell] {
//        let cells = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
//        var arrayOfCells : [CustomTableViewCell] = []
//
//        return arrayOfCells
//    }
    
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
                                cell.actualTemp = Int(weatherResponse.main.temp - 273.15)
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
    

