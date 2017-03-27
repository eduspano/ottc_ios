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
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var uuid = "none"
    var player = "none"
    var status = "W"
    var cpf = ""
    var initialLocation = true
    var today = ""
    
    var polyline:MKPolyline? = nil
    var locationManager: CLLocationManager!
    var zoomRect:MKMapRect = MKMapRectNull;
    let regionRadius: CLLocationDistance = 1000
    
    var points:[CLLocationCoordinate2D]=[]
    
    @IBOutlet weak var botTrip: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func butMap(_ sender: UIButton) {
        
        if sender.tag == 0{
            let vc = (
                storyboard?.instantiateViewController(
                    withIdentifier: "PlayerOp")
                )!
            vc.view.backgroundColor = UIColor.clear
            vc.modalTransitionStyle = .coverVertical
            present(vc, animated: true, completion: nil)
        }else{
            NotificationCenter.default.post(name: Notification.Name("endKey"), object: self )
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        botTrip.layer.shadowRadius = 1.0
        botTrip.layer.shadowOpacity = 0.5
        botTrip.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)

        let user = Users()
        let arr = user.viewUser()
        cpf = arr["cpf"] as! String
    
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = 20
        locationManager.distanceFilter = 100
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.resultAPI), name: Notification.Name("operatorKey"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.resultAPI2), name: Notification.Name("positionKey"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.resultAPI3), name: Notification.Name("endKey"), object: nil)
        
    }
    
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError!) {
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation

        //let time = String(describing: userLocation.timestamp)
        //let dd = Date()
        //let ts = Calendar.current.startOfDay(for: dd)
        let ts = userLocation.timestamp

        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "dd/MM/yyyy"
        let data = myFormatter.string(from: ts)
        

        let myFormatter2 = DateFormatter()
        myFormatter2.dateFormat = "hh:mm"
        let time = myFormatter2.string(from: ts)
        

        let lat = userLocation.coordinate.latitude
        let lng = userLocation.coordinate.longitude
        
        let local = CLLocationCoordinate2DMake(lat, lng)
        
        if initialLocation {
            initialLocation = false
            centerMapOnLocation(location: CLLocation(latitude: lat, longitude: lng) )
        }

        if botTrip.tag == 1 {
            
            if polyline != nil{
                mapView.remove(polyline!)
            }
    
            points.append( local )
            
            if points.count == 1{
                status = "RB"
            }else{
                if status.compare("RE").rawValue.description != "0" { //0 é igual
                    status = "R"
                }
                if status.compare("RE").rawValue.description == "0" { //0 é igual
                    botTrip.tag = 0
                }
            }
        
            geocoder(id:uuid, latitude: lat, longitude: lng, timeEnd: time, timeStart: time, data: data, player:player, indice: points.count, ts: ts )
            
            let pp = Points()
            pp.savePoint( tripcod:uuid,ts:userLocation.timestamp,latitude:String(lat),longitude:String(lng) )
            
            polyline = MKPolyline(coordinates: &points, count: points.count)
            mapView.add(polyline!)
            
            let p = MKMapPointForCoordinate ( local )
            let pointRect:MKMapRect = MKMapRectMake( p.x, p.y , 0, 0);
            if MKMapRectIsNull(zoomRect) {
                zoomRect = pointRect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect)
            }
            mapView.setVisibleMapRect(zoomRect, animated: true)
            
        }
        

        if(today.compare(data).rawValue.description != "0"){ //different
            if(status.compare("W").rawValue.description=="0"){
                uuid = UUID().uuidString
            }
        }
        
        let parameters = [
            "user_id": String(format: "%@", cpf),
            "mobile_id": String(format: "%@", uuid),
            "ride_id": String(format: "%@", uuid),
            "status": String(format: "%@", status),
            "provider": String(format: "%@", player),
            "agency": String(format: "%@", "saopaulo_sp"),
            "service": String(format: "%@", "rideshare"),
            "lat": lat,
            "lng": lng,
            "ts": String(format: "%@",  Date().iso8601 as CVarArg ),
            //"ts": String(format: "%@",  time as CVarArg )
            ] as [String : Any]
        
        let api = API()
        if api.callAPI(parameters:parameters as AnyObject, endpoint:"/api/v1/position", notificationChannel:"positionKey"){

        }
        
        
        print(parameters)
        
        status = "W"
        
    }
    
    func resultAPI(notification:Notification){
        if let op = notification.userInfo?["operator"] {
            
            points=[]
            
            player = op as! String
            
            uuid = UUID().uuidString
            
            botTrip.backgroundColor = UIColor(red: 255.0/255.0, green: 81.0/255.0, blue: 85.0/255.0, alpha: 1.0)
            botTrip.setTitle("Terminar corrida",for: .normal)
            botTrip.tag = 1
            
            if polyline != nil{
                mapView.remove(polyline!)
            }
            
            self.locationManager.startUpdatingLocation()
            
            //update widget
            let defaults = UserDefaults(suiteName: "group.scipopulis.OTTC")
            defaults?.setValue(player, forKey: "startRideOp")
            defaults?.synchronize()
            
            
        }
    }
    
    func resultAPI2(notification:Notification){
        //retorno do position
        if let mm = notification.userInfo?["message"] {
            print(mm)
        }
    }
    
    func resultAPI3(notification:Notification){
        botTrip.backgroundColor = UIColor(red: 102/255.0, green: 210/255.0, blue: 105/255.0, alpha: 1.0)
        botTrip.setTitle("Iniciar corrida",for: .normal)
        status = "RE"
        
        self.locationManager.startUpdatingLocation()
        
        player = "none"
        
        //update widget
        let defaults = UserDefaults(suiteName: "group.scipopulis.OTTC")
        defaults?.setValue(player, forKey: "startRideOp")
        defaults?.synchronize()
        
    }
    
    
    func geocoder(id:String,latitude:CLLocationDegrees, longitude:CLLocationDegrees,timeEnd:String,timeStart:String,data:String,player:String,indice:Int,ts:Date) {
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                let tt = Trips()
                
                //print (pm.thoroughfare!)

                
                if indice == 1{
                    
                    tt.saveTrip(id:id,localEnd:"-- --",localStart:pm.name!,timeEnd:timeEnd,timeStart:timeStart,data:data,player:player,cpf:self.cpf,ts:ts)
                }else{
                    tt.updateTrip(id:id,localEnd:pm.name!,timeEnd:timeEnd)
                }
            }
            else {
                print( "Problem with the data received from geocoder" )
            }
        })
        
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineView = MKPolylineRenderer(overlay: overlay)
        polylineView.strokeColor = UIColor.blue
        polylineView.lineWidth = 5
        return polylineView
        
    }
    

}


extension Date {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    var iso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
}
