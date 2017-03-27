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

class PerfilViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var gender: UISegmentedControl!
    
    @IBOutlet weak var cpf: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var terms: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sendButton = UIBarButtonItem(title: "Editar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(sendItem))
        navigationItem.rightBarButtonItem = sendButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Perfil"
    }
    
    func loadUser(){
        let ss = Users()
        let arr:Dictionary<String,AnyObject> = ss.viewUser()

        name.text = arr["name"] as! String?
        gender.selectedSegmentIndex = arr["gender"] as! Int
        cpf.text = arr["cpf"] as! String?
        email.text = arr["email"] as! String?
        
        var term = 0
        if (arr["terms"] != nil) as Bool {
            term = 1
        }
        terms.selectedSegmentIndex = term
    }
    
    func sendItem(){
        let editView = EditPerfilViewController()
        if let navigation = navigationController {
            navigation.pushViewController(editView, animated: true)
        }
    }

}
