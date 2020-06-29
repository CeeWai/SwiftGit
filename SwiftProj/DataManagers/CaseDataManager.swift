//
//  CaseDataManager.swift
//  ChongYong_Assignment
//
//  Created by Ong Chong Yong on 26/3/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class CaseDataManager: NSObject {
    class func loadCase (
        //subreddit: String,
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
                

                for var key in articles
                {
//                    let article = articles["data"]["children"][i]
//                    let news = News(
//                        title: article["data"]["title"].string!,
//                        url: article["data"]["url"].string!)
//                    newsList.append(news)
                    //print("THIS IS THE KEY: \(key.0)")
                    //let article = articles[key]
                    //print(key.1.endIndex)
                    //var lastIdx = key.1
                    var lastValue = key.1.reversed().first
                    //print(lastValue!.1)
                    
                    var dateValue = lastValue!.1["date"]
                    //print(dateValue)
                    var confirmedValue = lastValue!.1["confirmed"]
//                    if (Int(String(describing: confirmedValue))! < 15) && (Int(String(describing: confirmedValue)) != nil){
//                        continue
//                    }
                    var deathValue = lastValue!.1["deaths"]
                    var recoveredValue = lastValue!.1["recovered"]
                    //print(key.0)

                    let cTmp = Case(country: key.0, date: String(describing: dateValue), confirmed: Int(String(describing: confirmedValue)) ?? 0, deaths: Int(String(describing: deathValue)) ?? 0, recovered: Int(String(describing: recoveredValue)) ?? 0 )
                    caseList.append(cTmp)
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
