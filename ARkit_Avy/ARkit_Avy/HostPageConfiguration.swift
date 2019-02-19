//
//  HostPageConfiguration.swift
//  ARkit_Avy
//
//  Created by 阿部 祐輔 on 2019/02/19.
//  Copyright © 2019年 阿部 祐輔. All rights reserved.
//

import UIKit

class HostPageConfiguration: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
