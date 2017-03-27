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

import UIKit
import OneSignal

public class ViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        Plist().callApiPlayer() //update players
        
        let user = Users()
        let arr = user.viewUser()
        
        if arr.isEmpty {
            let newItem = LoginViewController()
            if let navigation = navigationController {
                navigation.pushViewController(newItem, animated: true)
            }
        } else{
            
            let textemail = arr["email"] as! String
            let textpassword = arr["password"] as! String
            var token = "";
            
            OneSignal.idsAvailable({(_ userId, _ pushToken) in
                token=userId!
                let parameters = [
                    "email": String(format: "%@", textemail),
                    "password": String(format: "%@", textpassword),
                    "push_token": String(format: "%@", token)
                ]
                
                let api = API()
                let result = api.callAPI(parameters: parameters as AnyObject, endpoint: "/api/v1/user/update", notificationChannel: "pushToken")
                if result {
                    print("token ok")
                }
            })
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let navigation = self.navigationController {
                let sendView = storyboard.instantiateViewController(withIdentifier: "tabControl")
                navigation.pushViewController(sendView, animated: true)
            }
        }
        

    }
    
    override public func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "OTTC"
        navigationItem.setHidesBackButton(true, animated: true)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

