//
//  LargeGroupsParser.swift
//
//
//  Created by 王首之 on 2/24/24.
//

import Foundation
import SwiftCSV
/// This file is reserved for future features 
class LargeGroupsParser: ObservableObject{
    func parseCSV() -> [String] {
        do {
            if let url = Bundle.main.url(forResource: "names to group.csv", withExtension: nil) {
                let csvFile: CSV = try CSV<Named>(url: url)
                return csvFile.header
            } else {
                return ["Can't find anything"]
            }
        } catch {
            // Catch errors from trying to load files
        }
        return ["Can't parse"]
    }
    
}
