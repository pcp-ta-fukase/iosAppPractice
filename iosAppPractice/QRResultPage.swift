//
//  QRResultPage.swift
//  iosAppPractice
//
//  Created by ta_fukase on 2019/03/12.
//  Copyright © 2019 ta_fukase. All rights reserved.
//

import UIKit

class QRResultPage: UIViewController {
    
    @IBOutlet weak var QRStringValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        QRStringValueLabel.text = CommonValue.QRStringValue
    }
    
    @IBAction func onButtonBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

