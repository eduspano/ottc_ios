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


class Plist {

    
    let headers = [
        "content-type": "application/json",
        "cache-control": "no-cache"
    ]
    
    
    func getHost() -> String {
        
        if let fileUrl = Bundle.main.url(forResource: "Config", withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! NSDictionary {
                return result.object(forKey: "Host") as! String
            }
        }
        
        return ""
    }
    
    func callApiPlayer() -> Void {
        
        do {
            
            let endpoint = getHost()+"/api/v1/provider"
            
            let request = NSMutableURLRequest(url: NSURL(string: endpoint)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                if (error != nil) {
                    print(error)
                } else {
                    
                    do {
                        let response = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Dictionary<String, AnyObject>
                        
                        if let msg = response["companies"] as? [[String: String]] {
                            
                            let logos : NSMutableDictionary = NSMutableDictionary();
                            
                            for mm in msg{
                                if let url = mm["logoUrl"]{
                                    let imageUrl:URL = URL(string: url)!
                                    let imageData:NSData = NSData(contentsOf: imageUrl)!
                                    logos.setValue(imageData, forKey: imageUrl.lastPathComponent)
                                }
                            }
                            
                            let defaults = UserDefaults(suiteName: "group.scipopulis.OTTC")
                            defaults?.setValue(logos, forKey: "logos")
                            defaults?.synchronize()

                        }
                    } catch {
                        // Do nothing
                    }
                    
                }
                
            })
            
            dataTask.resume()
            
        } catch {
            print("JSON serialization failed:  \(error)")
        }
    }
    
    
    func Verifyts(ts_server:String) -> Bool {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent("LocalData.plist")
        
        let fileManager = FileManager.default
        
        // Check if file exists
        if(!fileManager.fileExists(atPath: path))
        {
            do {
                
                let bundle = Bundle.main.path(forResource: "LocalData", ofType: "plist")
                try fileManager.copyItem(atPath: bundle!, toPath: path)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
            
        }
        
        
        var propertyListForamt =  PropertyListSerialization.PropertyListFormat.xml
        var plistData: [String: AnyObject] = [:] //Our data
        
        let plistXML = FileManager.default.contents(atPath: path)!
        
        do {//convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListForamt) as! [String:AnyObject]
            
            if let ts = plistData["ts"]{
                
                if ts.compare(ts_server).rawValue == -1 {
                    return true
                }else{
                    return false
                }
                
            }
            
            
        } catch {
            print("Error reading plist: \(error), format: \(propertyListForamt)")
        }
        
        return false
    }
    
    
    
    func saveImageDocumentDirectory(image:UIImage, name:String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    
    
}
