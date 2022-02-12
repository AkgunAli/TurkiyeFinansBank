//
//  BaseModel.swift
//  TurkiyeFinansBank
//
//  Created by Ali Akgün on 5.02.2022.
//

import Foundation
import ObjectMapper

class BaseModel<S:Mappable>: Mappable{
    var resultCount: Int?
    var resultsObject: S?
    var resultsArray: [S]?
    
    init() {
        // Intentionally unimplemented
    }

    required init?(map: Map) {
        // Intentionally unimplemented
    }

    func mapping(map: Map) {
        resultCount <- map["resultCount"]
        resultsObject <- map["results"]
        resultsArray <- map["results"]
    }
}
