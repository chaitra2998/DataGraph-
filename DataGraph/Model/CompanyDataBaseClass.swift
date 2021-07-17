//
//  CompanyDataBaseClass.swift
//  DataGraph
//
//  Created by Chaitrali chaudhari  on 17/07/21.
//

import Foundation
class CompanyDataBaseClass: Codable {
    //
    open var short : String?
    open var long : String?
    open var shortCovering : String?
    open var longUnwinding : String?
    
    
    enum CompanyDataBaseClassCodingKeys: String, CodingKey {
        case short = "s"
        case long = "l"
        case shortCovering = "sc"
        case longUnwinding = "lu"
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CompanyDataBaseClassCodingKeys.self)
        short = try container.decodeIfPresent(String.self, forKey: .short)
        long = try container.decodeIfPresent(String.self, forKey: .long)
        shortCovering = try container.decodeIfPresent(String.self, forKey: .shortCovering)
        longUnwinding = try container.decodeIfPresent(String.self, forKey: .longUnwinding)
        
    }
    func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CompanyDataBaseClassCodingKeys.self)
        try container.encodeIfPresent(short, forKey: .short)
        try container.encodeIfPresent(long, forKey: .long)
        try container.encodeIfPresent(shortCovering, forKey: .shortCovering)
        try container.encodeIfPresent(longUnwinding, forKey: .longUnwinding)
    }
    
    
    
}
