//
//  ApplicationListPageVM.swift
//  TurkiyeFinansBank
//
//  Created by Ali Akgün on 31.01.2022.
//

import Foundation

class Documents {
    var documentName : String?
    var documentModelName = [String]()
    init(documentName:String,documentModelName:String) {
        self.documentName = documentName
        self.documentModelName.append(documentModelName)
    }
    init(documentName:String) {
        self.documentName = documentName
    }
    init(documentModelName:String) {
        self.documentModelName.append(documentModelName)
    }
}

class ApplicationListPageVM {
    let searchApi = SearchAPI()
    let title = "Component List Page"
    var documentsResponse = [Documents]()
    var selectedDocument: String?
    var filteredData: [Documents]!
    var dataCopy = [Documents]()
    var responseService : [ContentModel]?
    var limitCount: Int = 10
    var isLoadingList : Bool = false
    var wrapperTypeArray : [String]?
    init() {
    }
    
    func searchContent(term : String, completion: @escaping () -> ()){
        searchApi.searchContent(term : term, limit:limitCount, succeed: { [weak self] response in
            guard let data = response.resultsArray , data.count > 0 else { return }
            self?.responseService = data
            for item in data {
                self?.wrapperTypeArray?.appendIfNotContains(item.wrapperType ?? "")
                self?.responseService?.append(item)
            }
            for (index, element) in data.enumerated() {
                if index == 0 {
                    self?.documentsResponse.append(Documents(documentName: element.wrapperType ?? "",documentModelName: element.artistName ?? ""))
                } else {
                    for(itemIndex, item) in self!.documentsResponse.enumerated() {
                        if  item.documentName != element.wrapperType{
                            self?.documentsResponse.append(Documents(documentName: element.wrapperType ?? "",documentModelName: element.artistName ?? ""))
                        } else {
                            self?.documentsResponse[itemIndex].documentModelName.append(element.artistName ?? "")
                        }
                    }
                }
            }
            self?.filteredData = self?.documentsResponse
            completion()
        }, failed: { error in
            print("error")
        })

    }
}
