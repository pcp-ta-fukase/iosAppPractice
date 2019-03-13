//
//  Home.swift
//  iosAppPractice
//
//  Created by ta_fukase on 2019/03/11.
//  Copyright © 2019 ta_fukase. All rights reserved.
//

import UIKit
import AVFoundation
import FMDB

class Home: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //アプリ起動時にuser_listテーブルを作成
        createTable()
    }
    
    @IBAction func onButtonQR(_ sender: Any) {
        
        moveToNextPage(nextStoryboardName: "QRReadingPage")
    }
    
    @IBAction func onButtonWeather(_ sender: Any) {
     
        moveToNextPage(nextStoryboardName: "weatherPage")
    }
    
    @IBAction func onButtonDB(_ sender: Any) {
        
        moveToNextPage(nextStoryboardName: "DBAccessPage")
    }

    //storyboard名を受け取り、その画面に遷移する
    func moveToNextPage(nextStoryboardName name: String) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: nil)
        let nextViewController = storyboard.instantiateInitialViewController()!
        present(nextViewController, animated: true, completion: nil)
    }

    private func createTable() {

        // FMDatabaseクラスのインスタンスを作成
        let db = FMDatabase(path: CommonValue.pathForAppDB)
        
        // データベースをオープン
        guard db.open() else {
            
            print("Failed to open the database.")
            return
        }
        
        //user_listテーブルが存在しなければ作成
        let logForCreatingTable = db.executeUpdate("CREATE TABLE IF NOT EXISTS user_list (user_id INTEGER PRIMARY KEY, user_name TEXT);", withArgumentsIn: []) ? "Did create table." : "Did not create table."

        //ログ出力
        print(logForCreatingTable)
        
        // データベースをクローズ
        db.close()
    }
}
