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

class ForgetViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgetViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func send(){
        
        let textemail = self.email.text
        
        let parameters = [
            "email": String(format: "%@", textemail!),
        ]
        
        let api = API()
        let result = api.callAPI(parameters: parameters as AnyObject, endpoint: "/api/v1/user/resetpassword", notificationChannel: "forgetKey")
        if result {
            print("ok")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ForgetViewController.resultAPI), name: Notification.Name("forgetKey"), object: nil)
    
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func resultAPI(notification:Notification){
        if let info = notification.userInfo?["message"] {
            let alert = UIAlertController(title: "Informação", message:"\(info)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                
                if let navigation = self.navigationController {
                    navigation.popViewController(animated: true)
                }
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
