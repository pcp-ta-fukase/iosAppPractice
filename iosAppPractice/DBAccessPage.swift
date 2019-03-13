//
//  DBAccessPage.swift
//  iosAppPractice
//
//  Created by ta_fukase on 2019/03/11.
//  Copyright © 2019 ta_fukase. All rights reserved.
//


import UIKit
import FMDB

class DBAccessPage: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
        
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var nameTableView: UITableView!
    
    var names: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        nameTextField.delegate = self        
        nameTableView.delegate = self
        
        listDBInfoToTable()
        nameTableView.reloadData()
    }
    
    @IBAction func onButtonBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onButtonSend(_ sender: Any) {

        //現在表示されているテキストフィールドの文字列をDBに追加
        addInfoToDB(nameToInsert: nameTextField.text!)
        
        listDBInfoToTable()
        nameTableView.reloadData()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        //Keyboardを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    //keyboard以外の画面を押すと、keyboardを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (self.nameTextField.isFirstResponder) {
            
            self.nameTextField.resignFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルにテキストを出力する。
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        // セルに表示する値（ラベルの文字など）を設定する
        cell.textLabel!.text = names[indexPath.row]
        
        return cell
    }
    
    private func listDBInfoToTable() {
        
        // /Documentsまでのパスを取得
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        // <Application>/Documents/test.db というパスを生成
        let _path: String? = paths[0] + "test.sqlite"
        
        // FMDatabaseクラスのインスタンスを作成
        let db = FMDatabase(path: _path)
        
        // データベースをオープン
        if db.open() {
            print("Succeeded in opening the database.")
        } else {
            print("Failed to open the database.")
        }
        
        var user_ids: [Int32] = []
        var user_names: [String] = []
        
        //user_listテーブルからuser_id、user_nameを取得
        let results = db.executeQuery("SELECT user_id, user_name FROM user_list;", withArgumentsIn: [])
        
        guard let unwrappedResults = results else {
            
            print("Failed to unwrap results.")
            return
        }

        while unwrappedResults.next() {
            // カラム名を指定して値を取得する方法
            user_ids.append(unwrappedResults.int(forColumn: "user_id"))
            // カラムのインデックスを指定して取得する方法
            user_names.append(unwrappedResults.string(forColumnIndex: 1) ?? "")
        }
        
        //tableViewに反映させる配列を更新
        names = user_names
        
        // データベースをクローズ
        db.close()
    }
    
    private func addInfoToDB(nameToInsert: String) {
        
        // /Documentsまでのパスを取得
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        // <Application>/Documents/test.db というパスを生成
        let _path: String? = paths[0] + "test.sqlite"
        
        // FMDatabaseクラスのインスタンスを作成
        let db = FMDatabase(path: _path)
        
        // データベースをオープン
        if db.open() {
            print("Succeeded in opening the database.")
        } else {
            print("Failed to open the database.")
        }
        
        //引数で受け取った文字列をDBに追加
        if db.executeUpdate("INSERT INTO user_list (user_name) VALUES (?);" , withArgumentsIn: [nameToInsert]) {
            print("Inserting succeeded.")
        } else {
            print("Inserting failed.")
        }
        
        // データベースをクローズ
        db.close()
    }
}
