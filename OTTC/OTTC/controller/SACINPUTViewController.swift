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

class SACINPUTViewController: UIViewController {

    @IBOutlet weak var sacImage: UIImageView!
    
    @IBOutlet weak var sacTitle: UILabel!
    
    @IBOutlet weak var local: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    var image = UIImage()
    var titlesac = ""
    var codsac = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SACINPUTViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let sendButton = UIBarButtonItem(title: "Enviar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(callAPI))
        navigationItem.rightBarButtonItem = sendButton

        textView.layer.borderColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:0.5).cgColor;
        textView.layer.borderWidth = 0.8;
        textView.layer.cornerRadius = 5.0;
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)

        self.sacImage.image = image
        self.sacTitle.text = titlesac
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    let headers = [
        "content-type": "application/json",
        "cache-control": "no-cache"
    ]
    
    func getSACConfig(property: String) -> String {
        
        if let fileUrl = Bundle.main.url(forResource: "Config", withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! NSDictionary {
                return result.object(forKey: property) as! String
            }
        }
        
        return ""
    }
    
    func callAPI() {
        
        let ss = Users()
        let arr:Dictionary<String,AnyObject> = ss.viewUser()
        
        let parameters = [
            "assunto": codsac,
            "descricao": textView.text,
            "endereco":[
                "bairro":"pinheiros",
                "cep":"043080123",
                "cidade":"sao paulo",
                "latitude":"-23.5630040",
                "logradouro": local.text!,
                "longitude":"-46.6864350",
                "numero":4,
                "referencia":"ios",
                "uf":"SP",
            ],
            "solicitante":[
                "cpf":arr["cpf"]!,
                "email":arr["email"]!,
                "nome":arr["name"]!,
                "telefone":[
                    "ddd":11,
                    "numero":34345656,
                    "preferencial":true,
                    "ramal":0,
                    "sms":true,
                    "tipo":"RESIDENCIAL"
                ]
            ]
        ] as [String : Any]
    
            
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options :[])
            
            let request = NSMutableURLRequest(url: NSURL(string: getSACConfig(property: "SACHost"))! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            
            request.httpMethod = "POST"
            request.addValue("Token "+getSACConfig(property: "SACKey"), forHTTPHeaderField: "Authorization")
            request.allHTTPHeaderFields = self.headers
            request.httpBody = postData
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                if (error != nil) {
                    print(error)
                } else {
                    
                    DispatchQueue.main.async {
                        
                        let alert = UIAlertController(title: "Mensagem", message:"Sua solicitação foi enviada com sucesso!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                            
                            
                            if let navigation = self.navigationController {
                                navigation.popViewController(animated: true)
                            }
                            
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    
                    }
                
                    
                    
                }
                
            })
            
            dataTask.resume()
            
        } catch {
            print("JSON serialization failed:  \(error)")
        }
            
        
    }


}
