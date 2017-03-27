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

class ListItemTripInfoTableViewCell: UITableViewCell, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var op: UIImageView!

    @IBOutlet weak var start: UILabel!
    
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var end: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var ts: UILabel!
    
    var mapView = MKMapView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialisation code
    }
    
    func addmap(){
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        mapView.showsPointsOfInterest = true
        mapView.delegate = self
        mapView.frame = CGRect(x: 0, y: 80, width: screenWidth, height: 220)
        self.addSubview(mapView)
    }
    
    func showPoints(points:[CLLocationCoordinate2D]){
        let polyline = MKPolyline(coordinates: points, count: points.count)
        mapView.add(polyline)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineView = MKPolylineRenderer(overlay: overlay)
        polylineView.strokeColor = UIColor.blue
        polylineView.lineWidth = 5
        return polylineView
    }
    

}
