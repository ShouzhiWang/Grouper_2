//
//  People.swift
//  Grouper 2
//
//  Created by 王首之 on 1/14/24.
//


import CoreData
import SwiftUI

@objc(People)
class People: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var category: String
    @NSManaged var grade: String?
    @NSManaged var type: String?
    @NSManaged var personality: String?
    @NSManaged var myId: UUID
}

extension People: Identifiable {
    
}
