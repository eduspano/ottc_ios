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

class OperatorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var box: UIView!
    
    @IBOutlet weak var iconclose: UIButton!
    
    @IBOutlet weak var painelPlayer: UICollectionView!
    
    var playerList: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults(suiteName: "group.scipopulis.OTTC")
        playerList = defaults?.object(forKey: "logos") as! NSDictionary
        
        box.layer.shadowColor = UIColor.black.cgColor
        //box.layer.shadowOffset = CGSizeZero
        box.layer.shadowOpacity = 0.5
        box.layer.shadowRadius = 5
        
        box.backgroundColor = UIColor.white
        box.layer.cornerRadius = 10.0
        box.layer.borderColor = UIColor.gray.cgColor
        box.layer.borderWidth = 0.5
        box.clipsToBounds = true
        
        iconclose.addTarget(self, action: #selector(buttonClose), for: .touchUpInside)
        
    }
    
    func buttonOperator(sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("operatorKey"), object: self, userInfo:["operator":(playerList.allKeys[sender.tag] as! String).replacingOccurrences(of: "icone_", with: "").replacingOccurrences(of: ".png", with: "") ] )
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func buttonClose(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerList.allKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellpp", for: indexPath as IndexPath) as! PlayerCollectionViewCell
        
        let imgName = playerList.allKeys[indexPath.row];
        let imgData : Data = playerList.object(forKey: imgName) as! Data
        let image = UIImage(data: imgData)

        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.setBackgroundImage(image, for: UIControlState.normal)
        button.tag = indexPath.row
        button.addTarget(self, action: #selector(buttonOperator), for: .touchUpInside)
        cell.addSubview(button)
        
        
        return cell
    }
    

}
