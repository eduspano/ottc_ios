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

import Foundation
import MMWormhole

class EventChannel {

    var wormhole:MMWormhole
    var channel:String
    
    init(applicationGroupIdentifier: String, eventChannel: String)
    {
        wormhole = MMWormhole(applicationGroupIdentifier: applicationGroupIdentifier, optionalDirectory: "eventchannel")
        channel = eventChannel
    }
    
    
    func post(event:String)
    {
        wormhole.passMessageObject(event as NSCoding?, identifier: self.channel)
    }
    
    
    func subscribe()
    {
        wormhole.listenForMessage(withIdentifier: channel)
        {
            (message) -> Void in
            
            guard let message = message else { return }
            print("[\(self.channel)] \(message)")
            
            if (message as AnyObject).compare("endtrip").rawValue.description != "0" {
                NotificationCenter.default.post(name: Notification.Name("operatorKey"), object: self, userInfo:["operator":(message as AnyObject).replacingOccurrences(of: "icone_", with: "").replacingOccurrences(of: ".png", with: "") ] )
            }else{
                NotificationCenter.default.post(name: Notification.Name("endKey"), object: self )
            }
        }
    }
}
