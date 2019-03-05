//
//  GameTirleViewController.swift
//  ARkit_Avy
//
//  Created by 阿部 祐輔 on 2019/02/21.
//  Copyright © 2019年 阿部 祐輔. All rights reserved.
//

import UIKit

class GameTitleViewController: UIViewController{
    
    @IBAction func hostButton(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextVc = storyboard.instantiateViewController(withIdentifier: "HostPage")
        self.present(nextVc, animated: true, completion: nil)
    }
    
    @IBAction func joinButton(_ sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextVc = storyboard.instantiateViewController(withIdentifier: "JoinPage")
        self.present(nextVc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
