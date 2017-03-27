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

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var gender: UISegmentedControl!
    
    @IBOutlet weak var cpf: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var email2: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var term: UISegmentedControl!
    
    
    @IBOutlet weak var viewScroll: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let sendButton = UIBarButtonItem(title: "Enviar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(sendItem))
        navigationItem.rightBarButtonItem = sendButton
        
        
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
    
    func sendItem(){
        
        let textcpf = self.cpf.text
        let textname = self.name.text
        let textemail = self.email.text
        let textemail2 = self.email2.text
        let textgender = self.gender.titleForSegment(at: self.gender.selectedSegmentIndex)?.lowercased()
        let textpassword = self.password.text
        
        let validate = Validation()
        
        if ( textname?.isEmpty )!{
            msg_alert(msg: "Nome vazio")
        }
        else if ( textcpf?.isEmpty )!{
            msg_alert(msg: "CPF vazio")
        }
        else if ( textemail?.isEmpty )!{
            msg_alert(msg: "Email vazio")
        }
        else if let comp_email = textemail?.compare(textemail2!).rawValue, comp_email != 0{
            msg_alert(msg: "Email diferente")
        }
        else if ( textpassword?.isEmpty )!{
            msg_alert(msg: "Senha vazio")
        }
        else if ( (textpassword?.characters.count)!<4 ){
            msg_alert(msg: "Senha pequena")
        }
        else if ( !validate.isValidEmailAddress(emailAddressString: textemail!) ){
            msg_alert(msg: "Email invalido")
        } else if ( !validate.checkIfCPFisValid(input: textcpf!) ) {
            msg_alert(msg: "CPF invalido")
        }else{
        
            let parameters = [
                "device_id": String(format: "%@", textcpf!),
                "name": String(format: "%@", textname!),
                "email": String(format: "%@", textemail!),
                "cpf": String(format: "%@", textcpf!),
                "gender": String(format: "%@", textgender!),
                "password": String(format: "%@", textpassword!)
            ]
            
            let api = API()
            let result = api.callAPI(parameters: parameters as AnyObject, endpoint: "/api/v1/user/signup", notificationChannel: "signupKey")
            if result {
                
                NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.resultAPI), name: Notification.Name("signupKey"), object: nil)
                
                let user = Users()
                user.saveUser(name: textname!, cpf: textcpf!, gender: self.gender.selectedSegmentIndex, terms: true, email: textemail!, password: textpassword!, logged: true, token: "")
            }
            
            
        }
        
        
        
    }
    
    
    func msg_alert(msg:String){
        let alert = UIAlertController(title: "Alerta", message:"\(msg)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func resultAPI(notification:Notification){
        if let info = notification.userInfo?["message"] {
            let alert = UIAlertController(title: "Informação", message:"Cadastrado com sucesso.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

}
