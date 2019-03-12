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
        
        let nextVc = storyboard!.instantiateViewController(withIdentifier: "GamePage") as? ViewController
        let _ = nextVc?.view // ** hack code **
        nextVc?.myHostName.text = inputHostNameText.text
        self.present(nextVc!,animated: true, completion: nil)
        
        // TextFieldの中身をクリア
        inputHostNameText.text = ""
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
