//
//  ViewController.swift
//  Busan-AirQuality
//
//  Created by D7703_23 on 2018. 10. 15..
//  Copyright © 2018년 D7703_23. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate{
    
    var items = [AirQualityData]()
    var item = AirQualityData()
    var myPM10 = ""
    var myPM25 = ""
    var mysite = ""
    var myPm10cai = ""
    var myPm25cai = ""
    var currentElement = ""
    var currentTime = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = myTalbeView.dequeueReusableCell(withIdentifier: "Re", for: indexPath)
        let myItem = items[indexPath.row]
        
        let mysite = myCell.viewWithTag(1) as! UILabel
        let myPM10 = myCell.viewWithTag(2) as! UILabel
        let myPM10cai = myCell.viewWithTag(3) as! UILabel
        
        mysite.text = myItem.dsite
        myPM10.text = myItem.dPm10
        myPM10cai.text = myItem.dPm10cai
        
        return myCell
    }
    
    
    
    @IBOutlet weak var myTalbeView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTalbeView.delegate = self
        myTalbeView.dataSource = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @objc func myParse(){
        let key = "공공데이터 key"
        
        let strURL = "http://opendata.busan.go.kr/openapi/service/AirQualityInfoService/getAirQualityInfoClassifiedByStation?ServiceKey=\(key)&numOfRows=21"
        
        if let url = URL(string: strURL){
            if let parser = XMLParser(contentsOf: url){
                parser.delegate = self
                
                if(parser.parse()){
                    print("parsing success")
                    print("PM 10 in Busan")
                    
                    let date: Date = Date()
                    let dayTimePeriodForMatter = DateFormatter()
                    dayTimePeriodForMatter.dateFormat = "yyyy/mm/dd hh시"
                    currentTime = dayTimePeriodForMatter.string(from: date)
                    print(currentTime)
                    print("PM10")
                    for i in 0..<items.count {
                        switch items[i].dpm10cai {
                        case "1" : items[i].dPm10cai = "좋음"
                        case "2" : items[i].dPm10cai = "보통"
                        case "3" : items[i].dPm10cai = "좋음"
                        case "4" : items[i].dPm10cai = "매우좋음"
                        default : break
                    }
                        print("\(item[i].dSite):\(item[i].dPm25) \(item[i].dPm25cai)")
                }
                    print("-----------------")
                }else{
                    print("parsing fail")
                }
            }else{
                print("url error")
            }
    }


}
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if !data.isEmpty {
            
            switch currentElement {
            case "pm10" : myPM10 = data
            case "pm25" : myPM25 = data
            case "pm10Cai" : myPm10cai = data
            case "pm25Cai" : myPm25cai = data
            case "site" : mysite = data
            default : break
            }
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let myItem = AirQuailtyData()
            myItem.dPm10 = myPM10
            myItem.dPm25 = myPM25
            myItem.dPm10Cai = myPm10cai
            myItem.dPm25Cai = myPm25cai
            myItem.dSite = mysite
            items.append(myItem)
        }
    }
}
