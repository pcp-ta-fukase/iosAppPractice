//
//  CommonValue.swift
//  iosAppPractice
//
//  Created by ta_fukase on 2019/03/12.
//  Copyright © 2019 ta_fukase. All rights reserved.
//

import Foundation

class CommonValue {
    
    static var QRStringValue = ""
    
    // <Application>/Documents/test.db というパスを生成
    static let pathForAppDB = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] + "test.db"

}
