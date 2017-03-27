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
import NotificationCenter
import CoreFoundation

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var playerList: NSDictionary = NSDictionary();
    var visibleList: NSMutableDictionary = NSMutableDictionary()
    
    @IBOutlet weak var painelPlayer: UICollectionView!
    
    @IBOutlet weak var buttonPause: UIButton!
    
    @IBAction func butPause(_ sender: UIButton) {
        visibleList.removeAllObjects()
        
        visibleList.addEntries(from: playerList as! [AnyHashable : Any])
        
        painelPlayer.reloadData()
        
        buttonPause.alpha = 0
        
        let eventChannel = EventChannel(applicationGroupIdentifier: "group.scipopulis.OTTC", eventChannel:"widget")
        eventChannel.post(event: "endtrip")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Plist().callApiPlayer() //update players
    }
    
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        let defaults = UserDefaults(suiteName: "group.scipopulis.OTTC")
        playerList=defaults?.object(forKey: "logos") as! NSDictionary
        visibleList.addEntries(from: playerList as! [AnyHashable : Any])
        painelPlayer.reloadData()
        
        
        let defaults2 = UserDefaults(suiteName: "group.scipopulis.OTTC")
        let selectedImgName : String = defaults2?.object(forKey: "startRideOp") as! String
        if(selectedImgName.compare("none").rawValue.description != "0"){
            buttonPause.alpha = 1
            visibleList.removeAllObjects()
            let imgData : Data = playerList.object(forKey: "icone_"+selectedImgName+".png") as! Data
            visibleList.setObject(imgData, forKey: selectedImgName as NSCopying)
            painelPlayer.reloadData()
        }
        
        
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.newData)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleList.allKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellWidget", for: indexPath as IndexPath)
        
        let imageview:UIImageView=UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let imgName : String = visibleList.allKeys[indexPath.row] as! String
        let imgData : Data = visibleList.object(forKey: imgName) as! Data
        let image = UIImage(data: imgData)
        imageview.image = image
        imageview.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.contentView.addSubview(imageview)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        buttonPause.alpha = 1
        
        let selectedImgName : String = visibleList.allKeys[indexPath.row] as! String
        visibleList.removeAllObjects()
        
        
        let imgData : Data = playerList.object(forKey: selectedImgName) as! Data
        visibleList.setObject(imgData, forKey: selectedImgName as NSCopying)
        
        painelPlayer.reloadData()
        
        
        let eventChannel = EventChannel(applicationGroupIdentifier: "group.scipopulis.OTTC", eventChannel:"widget")
        eventChannel.post(event: selectedImgName)
        


    }
    
    

    
    
    
}
