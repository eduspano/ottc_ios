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

class EditPerfilViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var new_password: UITextField!
    @IBOutlet weak var check_password: UITextField!
    
    @IBOutlet weak var viewScroll: UIScrollView!
    
    var cpf = ""
    var pass = ""
    var new_pass = ""
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditPerfilViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let sendButton = UIBarButtonItem(title: "Alterar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(sendItem))
        navigationItem.rightBarButtonItem = sendButton

        let ss = Users()
        let arr:Dictionary<String,AnyObject> = ss.viewUser()
        name.text = arr["name"] as! String?
        gender.selectedSegmentIndex = arr["gender"] as! Int
        email.text = arr["email"] as! String?
        
        token = arr["token"] as! String
        
        cpf = arr["cpf"]! as! String
        pass = arr["password"]! as! String
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            viewScroll.contentInset = UIEdgeInsets.zero
        } else {
            viewScroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        viewScroll.scrollIndicatorInsets = viewScroll.contentInset
        
        //let selectedRange = viewScroll.selectedRange
        //viewScroll.scrollRangeToVisible(selectedRange)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func msg_alert(msg:String){
        let alert = UIAlertController(title: "Alerta", message:"\(msg)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func sendItem(){
        
        let textname = self.name.text
        let textemail = self.email.text
        let textgender = self.gender.titleForSegment(at: self.gender.selectedSegmentIndex)?.lowercased()
        
        self.new_pass = self.new_password.text!
        if self.new_pass == "" {
            self.new_pass = self.pass
        }
        
        
        let parameters = [
            "device_id": String(format: "%@", self.cpf),
            "name": String(format: "%@", textname!),
            "email": String(format: "%@", textemail!),
            "gender": String(format: "%@", textgender!),
            "password": String(format: "%@", self.pass),
            "password_new": String(format: "%@", self.new_pass),
            ]
        
        let validate = Validation()
        
        if ( textname?.isEmpty )!{
            msg_alert(msg: "Nome vazio")
        }
        else if ( textemail?.isEmpty )!{
            msg_alert(msg: "Email vazio")
        }
        else if ( !validate.isValidEmailAddress(emailAddressString: textemail!) ){
            msg_alert(msg: "Email invalido")
        }else{
            
            if let cpass = password.text?.compare("").rawValue, cpass == 0 {
                
                send(parameters:parameters)
                
            }else{
                
                if let compPass = new_password.text?.compare(check_password.text!).rawValue, compPass != 0 {
                    msg_alert(msg: "Nova senha diferente")
                }
                else if ( (new_password.text?.characters.count)!<4 ){
                    msg_alert(msg: "Senha pequena")
                }
                else if let compOldPass = self.password.text?.compare(pass).rawValue, compOldPass != 0 {
                    msg_alert(msg: "Senha anterior invalida")
                }else{
                    
                    send(parameters:parameters)
                    
                }
                
            }
            
            
            
        }
        
        
        
    }
    
    
    func send(parameters:Any){
        
        let api = API()
        let result = api.callAPI(parameters: parameters as AnyObject, endpoint: "/api/v1/user/update", notificationChannel: "updateKey", token: token)
        if result {
            print("ok")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditPerfilViewController.resultAPI), name: Notification.Name("updateKey"), object: nil)
        
    }
    
    func resultAPI(notification:Notification){
        if let info = notification.userInfo?["message"] {
            let alert = UIAlertController(title: "Informação", message:"\(info)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                
                if let boby = notification.userInfo?["boby"] {
                    let user = boby as! Dictionary<String, AnyObject>
                    
                    let ss = Users()
                    ss.updateUser(name:user["name"]! as! String,
                                cpf:user["cpf"]! as! String,
                                gender:self.gender.selectedSegmentIndex,
                                terms:true,
                                email:user["email"]! as! String,
                                password:self.new_pass,
                                token:user["token"]! as! String)
                    
                    if let navigation = self.navigationController {
                        navigation.popViewController(animated: true)
                    }
                    
                }
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
