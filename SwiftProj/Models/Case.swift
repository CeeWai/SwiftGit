//
//  Case.swift
//  ChongYong_Assignment
//
//  Created by Ong Chong Yong on 26/3/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import Foundation

class Case {
    var country : String
    var date : String
    var confirmed : Int
    var deaths: Int
    var recovered : Int
    
    init(country: String, date: String, confirmed: Int, deaths: Int, recovered: Int)
    {
        self.country = country
        self.date = date
        self.confirmed = confirmed
        self.deaths = deaths
        self.recovered = recovered
    }
}
