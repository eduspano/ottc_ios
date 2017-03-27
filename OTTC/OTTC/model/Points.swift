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

class Points{
    
    func listPoint(tripcod:String) -> [Dictionary<String,String>] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Point")
        
        request.returnsObjectsAsFaults = false
        
        var arr = [Dictionary<String,String>]()
        
        do{
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if result.value(forKey: "tripcod") as? String == tripcod{
                        
                        var arrayTrip:Dictionary<String,String> = [:]

                        if let latitude = result.value(forKey: "latitude") as? String{
                            arrayTrip["latitude"] = latitude as String?
                        }
                        if let longitude = result.value(forKey: "longitude") as? String{
                            arrayTrip["longitude"] = longitude as String?
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
    
    
    func savePoint(tripcod:String,ts:Date,latitude:String,longitude:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPoint = NSEntityDescription.insertNewObject(forEntityName: "Point", into: context)
        
        newPoint.setValue(tripcod, forKey: "tripcod")
        newPoint.setValue(ts, forKey: "ts")
        newPoint.setValue(latitude, forKey: "latitude")
        newPoint.setValue(longitude, forKey: "longitude")
        
        do{
            try context.save()
        }catch{
            //error
        }
    }
    
}

