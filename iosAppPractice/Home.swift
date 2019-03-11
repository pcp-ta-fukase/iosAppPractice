//
//  Home.swift
//  iosAppPractice
//
//  Created by ta_fukase on 2019/03/11.
//  Copyright © 2019 ta_fukase. All rights reserved.
//

import UIKit

class Home: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func onButtonWeather(_ sender: Any) {
     
        moveToNextPage(nextStoryboardName: "weatherPage")
    }
    
    @IBAction func onButtonDB(_ sender: Any) {
        
        moveToNextPage(nextStoryboardName: "DBAccessPage")
    }
    
    private func moveToNextPage(nextStoryboardName name: String) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: nil)
        let nextViewController = storyboard.instantiateInitialViewController()!
        present(nextViewController, animated: true, completion: nil)
    }
}

