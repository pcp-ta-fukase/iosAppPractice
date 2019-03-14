//
//  weatherPage.swift
//  iosAppPractice
//
//  Created by ta_fukase on 2019/03/11.
//  Copyright © 2019 ta_fukase. All rights reserved.
//


import UIKit
import Alamofire

class weatherPage: UIViewController {
    
    @IBOutlet weak var weatherResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getLatestQiitaInfo()
    }
    
    @IBAction func onButtonBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func getLatestQiitaInfo() {
        
        let url:String = "http://weather.livedoor.com/forecast/webservice/json/v1?city=130010"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON{ response in
            
            switch response.result {
            case .success:
                print("Succeeded!")
                print(response.result.value)
                
            case .failure(let error):
                print(error)
            }
            
            if let data = response.data {
            
                let decoder = JSONDecoder()
                let feed = try? decoder.decode(WeatherInfo.self, from: data)
            
                let publicTime = feed?.publicTime
                let title = feed?.title
                let date = feed?.forecasts[0].date
                let dateLabel = feed?.forecasts[0].dateLabel
                let telop = feed?.forecasts[0].telop
                
                if let tit = title, let dat = date, let tel = telop {
                    
                    //値がnilでなければ、場所・日付・天気を1行ずつ表示する
                    self.weatherResultLabel.text = "\(tit)\n" + "\(dat)\n" + "\(tel)"
                }
            }
        }
    }

    struct WeatherInfo: Codable {
        
        var publicTime: String
        var title: String
        var forecasts: [WeatherInfoDetail]
    }
    
    struct WeatherInfoDetail: Codable {
     
        var date: String
        var dateLabel: String
        var telop: String
    }
}


