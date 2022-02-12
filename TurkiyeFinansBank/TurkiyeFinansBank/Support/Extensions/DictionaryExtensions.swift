//
//  DictionaryExtensions.swift
//  TurkiyeFinansBank
//
//  Created by Ali Akgün on 5.02.2022.
//

import Foundation
extension Dictionary {

    func toJsonStr(option: JSONSerialization.WritingOptions = []) -> String {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: option) else { return "" }
        let theJSONText = String(data: theJSONData, encoding: .utf8)
        return theJSONText ?? ""
    }

    func toJsonText(option: JSONSerialization.WritingOptions = []) throws -> String? {
        let theJSONData = try JSONSerialization.data(withJSONObject: self, options: option)
        return String(data: theJSONData, encoding: .utf8)
    }

}

extension RangeReplaceableCollection where Element: Equatable {
    @discardableResult
    mutating func appendIfNotContains(_ element: Element) -> (appended: Bool, memberAfterAppend: Element) {
        if let index = firstIndex(of: element) {
            return (false, self[index])
        } else {
            append(element)
            return (true, element)
        }
    }
}
