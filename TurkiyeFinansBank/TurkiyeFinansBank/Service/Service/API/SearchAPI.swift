//
//  SearchAPI.swift
//  TurkiyeFinansBank
//
//  Created by Ali Akgün on 5.02.2022.
//

import Foundation

class SearchAPI {
    func searchContent(term:String,limit:Int,
                   succeed: @escaping (BaseModel<ContentModel>) -> Void,
                   failed: @escaping (ErrorMessage) -> Void) {

        let params: [String : Any] = ["term": term,"limit": limit]
        API.shared.request(methotType: .get,
                               params: params,
                               urlPath: Endpoints.search,
                               succeed: succeed,
                               failed: failed)
    }
}
