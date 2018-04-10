//
//  ChartViewController.swift
//  Thermocast
//
//  Created by Georgios on 2018-04-07.
//  Copyright © 2018 Georgios. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    var customCellArray : [CustomTableViewCell]?

    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBAction func bottomBarCities(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
//    var dataEntry1 = PieChartDataEntry(value: 0)
//    var dataEntry2 = PieChartDataEntry(value: 0)
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        numberOfDownloadsDataEntries = convertCellsArrayToPieChartDataArray(cellArray: customCellArray!)
        
        pieChartView.chartDescription?.text = ""
        
//        dataEntry1.value = 20
//        dataEntry1.label = "Gothenburg"
//
//        dataEntry2.value = 30
//        dataEntry2.label = "Singapore"
//
//        numberOfDownloadsDataEntries = [dataEntry1, dataEntry2]
        
        updateChartData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateChartData() {
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.black, UIColor.green]
        chartDataSet.colors = colors
        
        pieChartView.data = chartData
    }
    
    //Function that converts the CustomTableViewCell array entries to scores and puts them in a PieChartDataEntry array
    func convertCellsArrayToPieChartDataArray(cellArray : [CustomTableViewCell]) -> [PieChartDataEntry] {
        var pieChartDataArray : [PieChartDataEntry]!
        print("cellArray contains \(cellArray.count) entries")
        
        for cell in cellArray {
            let weatherScore = cell.actualTemp - (Int(Float(cell.wind)!) * 2)
            print("weatherScore at index: \(cell) was: \(weatherScore)")
            
            let dataEntry = PieChartDataEntry(value: 0)
                
            dataEntry.label = cell.cityLabel.text
            dataEntry.value = Double(weatherScore)
            
            print("dataEntry.label: \(dataEntry.label!) dataEntry.value: \(dataEntry.value)")
                
            pieChartDataArray.append(dataEntry)
            
        }
        
        return pieChartDataArray
    }

}
