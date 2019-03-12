//
//  DBAccessPage.swift
//  iosAppPractice
//
//  Created by ta_fukase on 2019/03/11.
//  Copyright © 2019 ta_fukase. All rights reserved.
//


import UIKit

class DBAccessPage: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
        
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var nameTableView: UITableView!
    
    var names: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        nameTextField.delegate = self        
        nameTableView.delegate = self
    }
    
    @IBAction func onButtonBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onButtonSend(_ sender: Any) {

        //現在表示されているテキストフィールドの文字列を配列に追加
        names.append(nameTextField.text!)
        
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
    
    // セルをタップした時に呼ばれる
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        print("セルをタップしました")
    }
}
