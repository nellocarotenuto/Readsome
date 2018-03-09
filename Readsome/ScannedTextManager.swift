//
//  ScannedTextManager.swift
//  Readsome
//
//  Created by Nello Carotenuto on 09/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ScannedTextManager {
    
    static let name = "ScannedText"
    static var nextIndex = loadAll().count
    
    static func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    static func add(title : String, text : String, image : UIImage) {
        let context = getContext()
        
        let scannedText = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! ScannedText
        
        scannedText.title = title
        scannedText.text = text
        scannedText.image = NSKeyedArchiver.archivedData(withRootObject: image) as NSData
        scannedText.position = nextIndex
        
        save()
        nextIndex += 1
    }
    
    static func loadAll() -> [ScannedText] {
        let context = getContext()
        
        var scannedTexts = [ScannedText]()
        let fetchRequest = NSFetchRequest<ScannedText>(entityName : name)
        
        do {
            scannedTexts = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error: \(error.code)")
        }
        
        return scannedTexts
    }
    
    static func load(by title : String) -> ScannedText {
        let context = getContext()
        
        var scannedTexts = [ScannedText]()
        
        let fetchRequest = NSFetchRequest<ScannedText>(entityName : name)
        fetchRequest.predicate = NSPredicate(format : "title = \(title)")
        
        do {
            scannedTexts = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error: \(error.code)")
        }
        
        return scannedTexts[0]
    }
    
    static func load(by index : Int) -> ScannedText {
        let context = getContext()
        
        var scannedTexts = [ScannedText]()
        
        let fetchRequest = NSFetchRequest<ScannedText>(entityName : name)
        fetchRequest.predicate = NSPredicate(format : "position = \(index)")
        
        do {
            scannedTexts = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error: \(error.code)")
        }
        
        return scannedTexts[0]
    }
    
    static func save() {
        let context = getContext()
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error :\(error.code)")
        }
    }
    
}
