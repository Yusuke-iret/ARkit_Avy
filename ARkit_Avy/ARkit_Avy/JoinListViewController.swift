//
//  MultiplayerJoinListViewController.swift
//  ARkit_Avy
//
//  Created by 阿部 祐輔 on 2019/02/21.
//  Copyright © 2019年 阿部 祐輔. All rights reserved.
//

import UIKit

class JoinListViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //okButton.isEnabled = false
        // 角丸ボタンにする
        okButton.layer.cornerRadius = 10.0
        okButton.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // ボタン押下時のアクション
    @IBAction func okButton(_ sender: UIButton) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextVc = storyboard.instantiateViewController(withIdentifier: "GamePage")
        self.present(nextVc, animated: true, completion: nil)
    }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
