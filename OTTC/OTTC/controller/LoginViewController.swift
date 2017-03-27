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

class LoginViewController: UIViewController {

    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        buttonSend.layer.cornerRadius = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.resultAPI), name: Notification.Name("loginKey"), object: nil)
    }
    
    
    @IBAction func forget(){
        let forgetView = ForgetViewController()
        if let navigation = navigationController {
            navigation.pushViewController(forgetView, animated: true)
        }
    }
    
    @IBAction func send(){
        
        let textemail = self.email.text
        let textpassword = self.password.text
        
        let parameters = [
            "email": String(format: "%@", textemail!),
            "password": String(format: "%@", textpassword!)
        ]
        
        let api = API()
        let result = api.callAPI(parameters: parameters as AnyObject, endpoint: "/api/v1/user/login", notificationChannel: "loginKey")
        if result {
            print("ok")
        }
        
        
    }
    
    @IBAction func signin(){
        let signinView = RegisterViewController()
        if let navigation = navigationController {
            navigation.pushViewController(signinView, animated: true)
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "OTTC"
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func resultAPI(notification:Notification){

        if let info = notification.userInfo?["message"] {

            let body = info as! Dictionary<String, AnyObject>
            
            if body["user"] != nil {
                
                let user = body["user"] as! Dictionary<String, AnyObject>
                let token = body["access_token"] as! String
                
                let gender:Array = ["feminino","masculino"]
                let indexOfGender = gender.index(of: (user["gender"] as! String).lowercased() )
                
                let ss = Users()
                ss.activeUser(cpf:user["cpf"]! as! String)
                
                if ss.loggedUser(email: user["email"] as! String, password: self.password.text!){
                    ss.updateUser(name:user["name"]! as! String,
                                  cpf:user["cpf"]! as! String,
                                  gender: indexOfGender!,
                                  terms:true,
                                  email:user["email"]! as! String,
                                  password:self.password.text!,
                                  token: token as! String)

                }else{
                    ss.saveUser(name:user["name"]! as! String,
                                cpf:user["cpf"]! as! String,
                                gender: indexOfGender!,
                                terms:true,
                                email:user["email"]! as! String,
                                password:self.password.text!,
                                logged:true,
                                token: token as! String)
                }
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let navigation = self.navigationController {
                    let sendView = storyboard.instantiateViewController(withIdentifier: "tabControl")
                    navigation.pushViewController(sendView, animated: true)
                }
                
            }else{
                
                let alert = UIAlertController(title: "Informação", message:"\(info)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
            }

            
        }
        
        
    }


}
