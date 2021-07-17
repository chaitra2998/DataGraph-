//
//  Short.swift
//  DataGraph
//
//  Created by Chaitrali chaudhari  on 17/07/21.
//

import Foundation
struct DetailedParams : Comparable{
    static func < (lhs: DetailedParams, rhs: DetailedParams) -> Bool {
        return lhs.priceChange < rhs.priceChange

    }
    
    var companyName: String
    var priceChange: Double
    var color : String
    var type : String
    
    
}
