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

class Validation {
    
    
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    
    
    
    
    func checkIfCPFisValid(input: String) -> Bool
    {
        
        let cpf = input.characters.filter{"0123456789".characters.contains($0)}
        
        if cpf.count == 11 {
            
            let soma = Int(String(cpf[0]))!*10 + Int(String(cpf[1]))!*9 + Int(String(cpf[2]))!*8 + Int(String(cpf[3]))!*7 + Int(String(cpf[4]))!*6 + Int(String(cpf[5]))!*5 + Int(String(cpf[6]))!*4 + Int(String(cpf[7]))!*3 + Int(String(cpf[8]))!*2

            if ( soma * 10 % 11 ) == Int(String(cpf[9]))! {
                
                let soma2 = Int(String(cpf[0]))!*11 + Int(String(cpf[1]))!*10 + Int(String(cpf[2]))!*9 + Int(String(cpf[3]))!*8 + Int(String(cpf[4]))!*7 + Int(String(cpf[5]))!*6 + Int(String(cpf[6]))!*5 + Int(String(cpf[7]))!*4 + Int(String(cpf[8]))!*3 + Int(String(cpf[9]))!*2
                
                if ( soma2 * 10 % 11 ) == Int(String(cpf[10]))! {
                    return true
                }
                
            }
            
        }
        
        return false
    }
    
    
    
    
}
