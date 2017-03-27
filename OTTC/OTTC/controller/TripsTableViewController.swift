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
import MapKit
import CoreData

struct cellData {
    let id : String!
    let ts : String!
    let localStart : String!
    let timeStart : String!
    let localEnd : String!
    let timeEnd : String!
    let player : String!
}

class TripsTableViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableTrips: UITableView!
    
    var arrayOfCellData = [cellData]()
    var selectedIndex = -1
    
    var cpf = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Users()
        let arr = user.viewUser()
        cpf = arr["cpf"] as! String
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableTrips.reloadData()
    }
    
    func getData(){
        arrayOfCellData = [cellData]()
        
        let arr = Trips()
        let trips = arr.listTrip(cpf:cpf)
        
        if trips.count > 0{
            for i in 0...(trips.count - 1) {

                var player=trips[i]["player"] as! String!
                player = "icone_"+player!
                if(!(player?.contains(".png"))!) {
                    player?.append(".png")
                }
                
                let tempInfo = cellData(id: trips[i]["id"] as! String,
                                        ts: trips[i]["data"] as! String!,
                                        localStart: trips[i]["localStart"] as! String!,
                                        timeStart: trips[i]["timeStart"] as! String!,
                                        localEnd: trips[i]["localEnd"] as! String!,
                                        timeEnd: trips[i]["timeEnd"] as! String!,
                                        player: player)
                arrayOfCellData.append(tempInfo)
                
            }
        }
        
    }


    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ListItemTripInfoTableViewCell", owner: self, options: nil)?.first as! ListItemTripInfoTableViewCell
        
        cell.start.text = arrayOfCellData[indexPath.row].localStart
        cell.startTime.text = arrayOfCellData[indexPath.row].timeStart
        cell.end.text = arrayOfCellData[indexPath.row].localEnd
        cell.endTime.text = arrayOfCellData[indexPath.row].timeEnd
        cell.ts.text = arrayOfCellData[indexPath.row].ts
        
        let defaults = UserDefaults(suiteName: "group.scipopulis.OTTC")
        let playerList = defaults?.object(forKey: "logos") as! NSDictionary

        if(playerList.object(forKey: arrayOfCellData[indexPath.row].player!) != nil) {
            let imgData : Data = playerList.object(forKey: arrayOfCellData[indexPath.row].player!) as! Data
            let image = UIImage(data: imgData)
            
            cell.op.image = UIImageView(image: image).image
        }
        
        
        let arr  = Points()
        let pps = arr.listPoint(tripcod: arrayOfCellData[indexPath.row].id)
            
        var zoomRect:MKMapRect = MKMapRectNull;
            
        var points:[CLLocationCoordinate2D]=[]
        for ll in pps{
                
            let local = CLLocationCoordinate2DMake( Double(ll["latitude"]!)! , Double(ll["longitude"]!)! )
        
            let p = MKMapPointForCoordinate ( local )
            let pointRect:MKMapRect = MKMapRectMake( p.x, p.y , 0, 0);
            if MKMapRectIsNull(zoomRect) {
                zoomRect = pointRect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect)
            }
                
            points.append( local )
        }
        
        
        if(selectedIndex == indexPath.row) {
            cell.addmap()
            cell.mapView.setVisibleMapRect(zoomRect, animated: true)
            cell.showPoints(points: points)
        } else{
            cell.mapView.frame = CGRect(x: 0, y: 80, width: 0, height: 0)
        }
        

        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(selectedIndex == indexPath.row) {
            return 300;
        } else {
            return 80;
        }
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedIndex == indexPath.row) {
            selectedIndex = -1
        } else {
            selectedIndex = indexPath.row
        }
        self.tableTrips.beginUpdates()
        self.tableTrips.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic )
        self.tableTrips.endUpdates()
        
        self.tableTrips.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Deletar") { (action, indexPath) in
            
            print(self.arrayOfCellData[indexPath.row].id)
            let tripid = Trips()
            
            let noteEntity = "Trip" //Entity
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            managedContext.delete( tripid.findTrip(id: self.arrayOfCellData[indexPath.row].id) )

            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }

            self.arrayOfCellData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        
        /*
        let cancel = UITableViewRowAction(style: .normal, title: "Cancelar") { (action, indexPath) in
            tableView.setEditing(false, animated: true)
        }
        
        cancel.backgroundColor = UIColor.blue
         return [delete, cancel]
        */
        
        return [delete]
        
    }
    
    
    
    
    

}
