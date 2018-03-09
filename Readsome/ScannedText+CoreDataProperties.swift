//
//  ScannedText+CoreDataProperties.swift
//  Readsome
//
//  Created by Nello Carotenuto on 09/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//
//

import Foundation
import CoreData


extension ScannedText {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScannedText> {
        return NSFetchRequest<ScannedText>(entityName: "ScannedText")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var position: Int

}
