//
//  DBAccessPage.swift
//  iosAppPractice
//
//  Created by ta_fukase on 2019/03/11.
//  Copyright © 2019 ta_fukase. All rights reserved.
//


import UIKit
import FMDB
import CoreGraphics

class DBAccessPage: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
        
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var nameTableView: UITableView!
    
    var ids: [Int32] = []
    var names: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        nameTextField.delegate = self
        nameTableView.delegate = self

        //テキストフィールドの表示スタイルを設定
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.borderWidth  = 2
        nameTextField.layer.masksToBounds = true
        
        //テキストフィールドに初期カラーを設定する
        setTextFieldWithNormalColor()
        
        //DBに格納されているユーザー情報をテーブルビューに表示する
        listDBInfoToTable()
        nameTableView.reloadData()
    }
    
    @IBAction func onButtonBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onButtonSend(_ sender: Any) {
        
        //送信ボタン押下時にテキストボックスが空欄であればDBに追加せずに入力エラーとする
        guard (nameTextField.text)! != "" else {
            
            setTextFieldWithWarningColor()
            return
        }

        //現在表示されているテキストフィールドの文字列をDBに追加
        insertUserInfoToDB(nameToInsert: nameTextField.text!)
        
        listDBInfoToTable()
        nameTableView.reloadData()
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        setTextFieldWithNormalColor()
        return true
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
        cell.textLabel!.text = "\(ids[indexPath.row])"
        cell.detailTextLabel!.text = names[indexPath.row]
        
        return cell
    }
    
    private func listDBInfoToTable() {

        // FMDatabaseクラスのインスタンスを作成
        let db = FMDatabase(path: CommonValue.pathForAppDB)
        
        // データベースをオープン
        guard db.open() else {
            
            print("Failed to open the database.")
            return
        }
        
        var user_ids: [Int32] = []
        var user_names: [String] = []
        
        //user_listテーブルからuser_id、user_nameを取得
        let results = db.executeQuery("SELECT user_id, user_name FROM user_list;", withArgumentsIn: [])
        
        if let unwrappedResults = results {
            
            while unwrappedResults.next() {
                
                user_ids.append(unwrappedResults.int(forColumn: "user_id"))
                user_names.append(unwrappedResults.string(forColumnIndex: 1) ?? "")
            }
            
        } else {
            
            //ログを出力
            print("Failed to retrieving data from database table.")
        }
        
        //tableViewに反映させる配列を更新
        ids = user_ids
        names = user_names
        
        // データベースをクローズ
        db.close()
    }
    
    private func insertUserInfoToDB(nameToInsert: String) {
        
        // FMDatabaseクラスのインスタンスを作成
        let db = FMDatabase(path: CommonValue.pathForAppDB)
        
        // データベースをオープン
        guard db.open() else {
            
            print("Failed to open the database.")
            return
        }
        
        //引数で受け取った文字列をDBに追加
        let logForInsertInfo = db.executeUpdate("INSERT INTO user_list (user_name) VALUES (?);" , withArgumentsIn: [nameToInsert]) ? "Insert succeeded." : "Insert failed."

        //ログを出力
        print(logForInsertInfo)
        
        // データベースをクローズ
        db.close()
    }
    
    private func setTextFieldWithNormalColor() {
        
        nameTextField.backgroundColor = UIColor.hexStr(of: "#EEEEEE", alpha: 1)
        nameTextField.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setTextFieldWithWarningColor() {
        
        nameTextField.backgroundColor = UIColor.hexStr(of: "#EBAAB3", alpha: 1)
        nameTextField.layer.borderColor = UIColor.hexStr(of: "#F04747", alpha: 1).cgColor
    }
}

//HEX値で色を指定できるようにUIColorを拡張
extension UIColor {
    class func hexStr(of hexString : NSString, alpha : CGFloat) -> UIColor {
        let hexStr = hexString.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string")
            return UIColor.white
        }
    }
}
