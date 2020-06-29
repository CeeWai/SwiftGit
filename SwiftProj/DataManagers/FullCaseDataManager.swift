//
//  CaseDataManager.swift
//  ChongYong_Assignment
//
//  Created by Ong Chong Yong on 26/3/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class FullCaseDataManager: NSObject {
    class func loadCase (
        country: String,
        onComplete: ((_ : [Case]) -> Void)?
        )
    {
        //let q = subreddit.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://pomber.github.io/covid19/timeseries.json"
        // Queue an asynchronous task on the background thread,
        // so that viewDidLoad will end immediately, while the
        // task programmed inside the dispatch will run at a
        // later time.
        //
        HTTP.getJSON(url: url, onComplete:
            {
                json, response, error in
                if error != nil
                {
                    return
                }
                let articles = json!
                // Get the total number of articles loaded
                // from the JSON API
                //
                let count = articles.count
                // Clear all the news from our list first.
                //
                var caseList : [Case] = []
                // Loop through each article, create a new News
                // object for each article and add it to our
                // list.
                //
                var countryReports = articles[country].reversed()
                
                for var report in countryReports {
                    let cTmp = Case(country: country, date: String(describing:report.1["date"]), confirmed: Int(String(describing: report.1["confirmed"])) ?? 0, deaths: Int(String(describing: report.1["deaths"])) ?? 0, recovered: Int(String(describing: report.1["recovered"])) ?? 0 )
                    caseList.append(cTmp)
                    //print(report)
                }
                
                // Now we call the caller's onComplete method
                // so that the caller can process the data or
                // display it on the screen
                //
                
                caseList = caseList.sorted {
                    $0.confirmed > $1.confirmed
                }
                onComplete?(caseList)
                //return caseList
        })
    }
    
    static func stringify(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
          options = JSONSerialization.WritingOptions.prettyPrinted
        }

        do {
          let data = try JSONSerialization.data(withJSONObject: json, options: options)
          if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
          }
        } catch {
          print(error)
        }

        return ""
    }
}
