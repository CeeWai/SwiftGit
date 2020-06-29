//
//  CountryDataManager.swift
//  ChongYong_Assignment
//
//  Created by Ong Chong Yong on 29/3/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class CountryDataManager: NSObject {
    class func loadCase (
            //subreddit: String,
            onComplete: ((_ : [String]) -> Void)?
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
                    var countryList : [String] = []
                    // Loop through each article, create a new News
                    // object for each article and add it to our
                    // list.
                    //
                    

                    for var key in articles
                    {
                        countryList.append(key.0)
                    }
                    // Now we call the caller's onComplete method
                    // so that the caller can process the data or
                    // display it on the screen
                    //
                    
                    onComplete?(countryList)
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
