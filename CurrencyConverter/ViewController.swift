//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by hasan bilgin on 30.09.2023.
//

import UIKit

class ViewController: UIViewController {
    
    /*
    -Cuurent converter api  (döviz çevirici api) arattık fixer.io girdik
     -hasanbilgintr@gmail.com -> kayıt olundus
    -get free api key diyip -> free plan seçip -> bilgileri girip ardın key vericektir
    -https://codebeautify.org/jsonviewer json kodları güzel gösterir
    -http şifreleme yoktur https de vardır post ederken veriler sadece görünür ikisinde denicem
     -http için izin verilmesi lazım  info.plist ten App Transport Security Settings seçinde hemen solunda oynat simgesine benzer tıklayınca ok aşağı bakar ve aynı satıra + basınca ordan Allow Arbitrary Loads seçip values te YES girilmesi yeterli
     */

    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getRatesClicked(_ sender: Any) {
        
        /*
         1. Request & session //url adresine istek yollama
         2. Respponse & Data //istekten gelen cevaba göre veriyi (datayı) almak
         3. Parsing & JSON Serialization //aldığın veriyi işlemek, parçalamak ..vs..
         */
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=\(contants.key)")

        
        //request
        let session = URLSession.shared
        //istek birden fazla olmaması için ayırdık
        //input url dir //data = veri // response = cevap // error = hata
        //callbackfucntion,closure butip functionlara gönderiyoruz sonucudan birşeyler veriyor
        //completionHandler dir bu entere basılarak sonuçları verir
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                //error?.localizedDescription kullanıcının anlayabilceği dilden mesajdır
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(okButton)
                //sunmak closure içinde ise self zorunlumuş
                self.present(alert, animated: true)
                
            }else{
                if data != nil {
                    //json alıp objelere tek tek dönüştürmekte
                    do{
                        //JSONSerialization.ReadingOptions.mutableContainers dictionaries ile kullanılabilir yaptık
                      let jsonResponse = try  JSONSerialization.jsonObject(with: data!,options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        //bu trhread arkaplanda çalıştığı için ama verilere mainde olması gerektiği içinthread değişklik ği yapıcaz
                        //async = senkronize olmayan // sync senkronize olan
                        DispatchQueue.main.async {
                            //tüm datayı verdi
                            //print(jsonResponse)
                            if let rates = jsonResponse["rates"] as? [String : Any]{
                                if let cad = rates["CAD"] as? Double {
                                    self.cadLabel.text = "CAD: \(cad)"
                                }
                                if let chf = rates["CHF"] as? Double {
                                    self.chfLabel.text = "CHF: \(chf)"
                                }
                                if let gbp = rates["GBP"] as? Double {
                                    self.gbpLabel.text = "GBP: \(gbp)"
                                }
                                if let jpy = rates["JPY"] as? Double {
                                    self.jpyLabel.text = "JPY: \(jpy)"
                                }
                                if let usd = rates["USD"] as? Double {
                                    self.usdLabel.text = "USD: \(usd)"
                                }
                                if let turkish = rates["TRY"] as? Double {
                                    self.tryLabel.text = "TRY: \(turkish)"
                                }
                            }
                        }
                    }catch{
                        print("error")
                    }
                    
                   
                }
            }
        }
        //isteği başlatıyoruz diyebiliriz
        task.resume()
        
    }
    
}

