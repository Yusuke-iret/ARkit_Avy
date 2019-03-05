//
//  HostPageConfiguration.swift
//  ARkit_Avy
//
//  Created by 阿部 祐輔 on 2019/02/19.
//  Copyright © 2019年 阿部 祐輔. All rights reserved.
//

import UIKit

class HostConfigurationVieController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var inputHostNameText: UITextField!
    @IBOutlet weak var GameStartButton: UIButton!
    
    // 文字列保存用の変数
    var textFieldString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputHostNameText.delegate = self
        GameStartButton.isEnabled = false
        // 角丸ボタンにする
        GameStartButton.layer.cornerRadius = 10.0
        GameStartButton.layer.masksToBounds = true
    }
    
    @IBAction func inputHostNameText(_ sender: Any) {
        if (inputHostNameText.text?.isEmpty)!{
            GameStartButton.isEnabled = false
        }else{
            GameStartButton.isEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // ボタン押下時のアクション
    @IBAction func pushGameStartButton(_ sender: UIButton) {
        
        // TextFieldから文字を取得
        textFieldString = inputHostNameText.text!
        
        // TextFieldの中身をクリア
        inputHostNameText.text = ""
        
        let storyboard: UIStoryboard = self.storyboard!
        let nextVc = storyboard.instantiateViewController(withIdentifier: "GamePage")
        self.present(nextVc, animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //テキストフィールドを編集する直前に呼び出される
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        inputHostNameText.textAlignment = NSTextAlignment.center
        return true
    }
    //Returnボタンがタップされた時に呼ばれる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        inputHostNameText.resignFirstResponder()
        return true
    }
}
