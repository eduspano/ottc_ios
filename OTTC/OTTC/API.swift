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

class API {
    
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
    
    func callAPI(parameters:AnyObject, endpoint:String, notificationChannel:String, token:String = "") -> Bool {
        
        let hostapi = getHost();
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options :[])
            
            let request = NSMutableURLRequest(url: NSURL(string: hostapi+endpoint)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            
            request.httpMethod = "POST"
            
            if(token.compare("").rawValue.description != "0"){
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            request.allHTTPHeaderFields = headers
            request.httpBody = postData
            
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                if (error != nil) {
                    print(error)
                } else {
                    
                    do {
                        let response = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Dictionary<String, AnyObject>
                        
                        if let msg = response["message"] {
                            print (msg)

                                OperationQueue.main.addOperation {
                                    NotificationCenter.default.post(name: Notification.Name(notificationChannel), object: self, userInfo:["message":msg] )
                                }
                    
                            
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
    
        return true
    }
    
}
