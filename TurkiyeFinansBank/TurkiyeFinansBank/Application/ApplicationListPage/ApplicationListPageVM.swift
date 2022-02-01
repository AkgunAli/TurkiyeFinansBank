//
//  ApplicationListPageVM.swift
//  TurkiyeFinansBank
//
//  Created by Ali Akgün on 31.01.2022.
//

import Foundation

class ApplicationListPageVM {
    var documentsResponse = [Documents]()
    var selectedDocument: String?
    var filteredData: [Documents]!
    var dataCopy = [Documents]()
}

class Documents {
    var documentName : String?
    var documentModelName:[String]?
    var documentAllItem : String?
    init(documentName:String,documentModelName:[String]) {
        self.documentName = documentName
        self.documentModelName = documentModelName
    }
}
