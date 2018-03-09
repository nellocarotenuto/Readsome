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
    
    static func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    static func add(title : String, text : String, image : UIImage) {
        let context = getContext()
        
        let scannedText = NSEntityDescription.insertNewObject(forEntityName : name, into : context) as! ScannedText
        
        scannedText.title = title
        scannedText.text = text
        scannedText.image =  UIImageJPEGRepresentation(image, CGFloat(0.25)) as NSData?
        scannedText.position = loadAll().count - 1
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
    
    static func delete(by index : Int) {
        let context = getContext()
        
        let scannedText = load(by : index)
        context.delete(scannedText)
        
        let fetchRequest = NSFetchRequest<ScannedText>(entityName : name)
        fetchRequest.predicate = NSPredicate(format : "position > \(index)")
        
        do {
            let items = try context.fetch(fetchRequest)
            
            for item in items {
                item.position -= 1
            }
            
        } catch let error as NSError {
            print("Error: \(error.code)")
        }
    }
    
    static func move(from : Int, to : Int) {
        let itemToMove = load(by : from)
        
        if from < to {
            for index in from...to {
                let item = load(by : index)
                
                item.position -= 1
            }
        } else if from > to {
            for index in to ..< from {
                let item = load(by : index)
                
                item.position += 1
            }
        }
        
        itemToMove.position = to
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
