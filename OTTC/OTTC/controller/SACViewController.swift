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

class SACViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var colletionView: UICollectionView!
    
    
    let arrayItem = [
        "Desefa de Autuação",
        "Consulta de multas de trânsito",
        "Recursos de multas de trânsito",
        "Restituição de multas pagas e deferidas",
        "Reclamação de eventos na via",
        "Aplicação de Advertência por Escrito",
        "2a via notificação de autuação de trânsito",
        "2a via auto de infração de trânsito",
        "2a via notificação de penalidade de trânsito",
        "Emissão de boleto pagamento",
        "Aviso de interferências no trânsito",
        "Recurso/defesa de Multa inscrita no CADIN",
        "Indicação de Condutor",
        "Criação/ampliação de estacionamento",
        "Denúncia de má conduta de funcionário da CET"
    ]
    
    let arrayIcon = [
        UIImage(named:"ic_defesa_de_autuacao"),
        UIImage(named:"ic_consulta_multa"),
        UIImage(named:"ic_recursos_de_multas"),
        UIImage(named:"ic_restituicao_de_multa"),
        UIImage(named:"ic_reclamacao_de_eventos"),
        UIImage(named:"ic_aplicacao_de_advertencia"),
        UIImage(named:"ic_2via_notificacao_autuacao"),
        UIImage(named:"ic_2via_auto_de_inflacao"),
        UIImage(named:"ic_2via_notificacao_penalidade"),
        UIImage(named:"ic_emissao_boleto"),
        UIImage(named:"ic_aviso_interferencias"),
        UIImage(named:"ic_defesa_multa_cadin"),
        UIImage(named:"ic_indicacao_de_condutor"),
        UIImage(named:"ic_criacao_estacionamento"),
        UIImage(named:"ic_denuncia_ma_conduta_cet")
        ]
    
    
    let sac_codes = [
    918,
    920,
    919,
    921,
    769,
    926,
    923,
    922,
    924,
    925,
    1556,
    927,
    928,
    761,
    768
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayItem.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! SACCellViewController
        
        cell.imageView?.image = self.arrayIcon[indexPath.row]
        cell.titleView?.text = self.arrayItem[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showItem", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {

        return UIEdgeInsetsMake(0, 400, 0, 400)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPaths = colletionView.indexPathsForSelectedItems!
        let indexPath = indexPaths[0] as IndexPath
        let sacinput = segue.destination as! SACINPUTViewController
        sacinput.image = arrayIcon[indexPath.row]!
        sacinput.titlesac = arrayItem[indexPath.row]
        sacinput.codsac = sac_codes[indexPath.row]
    }

}
