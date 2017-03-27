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

class Users{
    
    func viewUser() -> Dictionary<String,AnyObject> {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        request.returnsObjectsAsFaults = false
        
        var arrayUser:Dictionary<String,AnyObject> = [:]
        
        do{
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if result.value(forKey: "logged") as? Bool == true{
                        
                        if let name = result.value(forKey: "name") as? String{
                            arrayUser["name"] = name as AnyObject?
                        }
                        if let gender = result.value(forKey: "gender") as? Int{
                            arrayUser["gender"] = gender as AnyObject?
                        }
                        if let cpf = result.value(forKey: "cpf") as? String{
                            arrayUser["cpf"] = cpf as AnyObject?
                        }
                        if let email = result.value(forKey: "email") as? String{
                            arrayUser["email"] = email as AnyObject?
                        }
                        if let password = result.value(forKey: "password") as? String{
                            arrayUser["password"] = password as AnyObject?
                        }
                        if let token = result.value(forKey: "token") as? String{
                            arrayUser["token"] = token as AnyObject?
                        }
                        
                        break
                        
                    }
                    
                }
            }
            
        } catch{
            // error
        }
        
        
        return arrayUser
    }
    
    
    func saveUser(name:String,cpf:String,gender:Int,terms:Bool,email:String,password:String,logged:Bool,token:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        
        newUser.setValue(name, forKey: "name")
        newUser.setValue(cpf, forKey: "cpf")
        newUser.setValue(gender, forKey: "gender")
        newUser.setValue(terms, forKey: "terms")
        newUser.setValue(email, forKey: "email")
        newUser.setValue(password, forKey: "password")
        newUser.setValue(logged, forKey: "logged")
        newUser.setValue(token, forKey: "token")

        do{
            try context.save()
        }catch{
            //error
        }
    }
    
    
    func updateUser(name:String,cpf:String,gender:Int,terms:Bool,email:String,password:String,token:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{

                    if cpf == result.value(forKey: "cpf") as? String{
                        (result as AnyObject).setValue(name, forKey: "name")
                        (result as AnyObject).setValue(gender, forKey: "gender")
                        (result as AnyObject).setValue(terms, forKey: "terms")
                        (result as AnyObject).setValue(email, forKey: "email")
                        (result as AnyObject).setValue(password, forKey: "password")
                        (result as AnyObject).setValue(token, forKey: "token")
                
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
    
    
    
    func loggedUser(email:String,password:String) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    
                    if email == result.value(forKey: "email") as? String && password == result.value(forKey: "password") as? String {
                            return true
                    }
                    
                }
                return false
                
            }
            
        } catch{
            // error
        }
        
        return false
    }
    
    
    
    func activeUser(cpf:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    
                    if cpf == result.value(forKey: "cpf") as? String{
                        (result as AnyObject).setValue(true, forKey: "logged")
                    }else{
                        (result as AnyObject).setValue(false, forKey: "logged")
                    }
                    
                    do{
                        try result.managedObjectContext?.save()
                    }catch{
                        //error
                    }
                    
                }
                
            }
            
        } catch{
            // error
        }
    }


    
    
}
