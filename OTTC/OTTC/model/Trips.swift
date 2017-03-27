/**
 
 Projeto OTTC - Operadora de Tecnologia de Transporte Compartilhado
 Copyright (C) <2017> Scipopulis Desenvolvimento e Análise de Dados Ltda
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 Authors: Roberto Speicys Cardoso
 Date: 2017-03-20
 */

import Foundation
import UIKit
import CoreData

class Trips{
    
    func listTrip(cpf:String) -> [Dictionary<String,AnyObject>] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
        
        request.returnsObjectsAsFaults = false
        
        let sectionSortDescriptor = NSSortDescriptor(key: "ts", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        
        var arr = [Dictionary<String,AnyObject>]()
        
        do{
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    
                    if cpf == result.value(forKey: "cpf") as? String{
                        
                        var arrayTrip:Dictionary<String,AnyObject> = [:]
                        
                        if let id = result.value(forKey: "id") as? String{
                            arrayTrip["id"] = id as AnyObject?
                        }
                        if let localEnd = result.value(forKey: "localEnd") as? String{
                            arrayTrip["localEnd"] = localEnd as AnyObject?
                        }
                        if let localStart = result.value(forKey: "localStart") as? String{
                            arrayTrip["localStart"] = localStart as AnyObject?
                        }
                        if let timeEnd = result.value(forKey: "timeEnd") as? String{
                            arrayTrip["timeEnd"] = timeEnd as AnyObject?
                        }
                        if let timeStart = result.value(forKey: "timeStart") as? String{
                            arrayTrip["timeStart"] = timeStart as AnyObject?
                        }
                        if let player = result.value(forKey: "player") as? String{
                            arrayTrip["player"] = player as AnyObject?
                        }
                        if let data = result.value(forKey: "data") as? String{
                            arrayTrip["data"] = data as AnyObject?
                        }
                        
                        arr.append(arrayTrip)
                    
                    }
                    
                }
            }
            
        } catch{
            // error
        }
        
        
        return arr
    }
    
    func saveTrip(id:String,localEnd:String,localStart:String,timeEnd:String,timeStart:String,data:String,player:String,cpf:String,ts:Date){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newTrip = NSEntityDescription.insertNewObject(forEntityName: "Trip", into: context)
        
        newTrip.setValue(id, forKey: "id")
        newTrip.setValue(localEnd, forKey: "localEnd")
        newTrip.setValue(localStart, forKey: "localStart")
        newTrip.setValue(timeEnd, forKey: "timeEnd")
        newTrip.setValue(timeStart, forKey: "timeStart")
        newTrip.setValue(data, forKey: "data")
        newTrip.setValue(player, forKey: "player")
        newTrip.setValue(cpf, forKey: "cpf")
        newTrip.setValue(ts, forKey: "ts")
        
        do{
            try context.save()
        }catch{
            //error
        }
    }
    
    func updateTrip(id:String,localEnd:String,timeEnd:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
        
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{

                    if id.compare( (result.value(forKey: "id") as? String)! ).rawValue.description == "0" {
                        
                        (result as AnyObject).setValue(localEnd, forKey: "localEnd")
                        (result as AnyObject).setValue(timeEnd, forKey: "timeEnd")
                        
                        do{
                            try result.managedObjectContext?.save()
                        }catch{
                            //error
                        }
                    }
                    
                }
                
            }
            
        } catch{
            // error
        }
    }
    
    
    
    func findTrip(id:String) -> NSManagedObject {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
        
        request.returnsObjectsAsFaults = false
        
        let sectionSortDescriptor = NSSortDescriptor(key: "timeStart", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        request.sortDescriptors = sortDescriptors
        
        do{
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    
                    if id == result.value(forKey: "id") as? String{
                        
                        return result
                        
                    }
                    
                }
            }
            
        } catch{
            // error
        }
        
        let temp:NSManagedObject? = nil
        return temp!
    }
    

    
}

