//
//  UIViewController.swift
//  Readsome
//
//  Created by Nello Carotenuto on 08/03/18.
//  Copyright © 2018 Readsome. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController  {
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target : self, action : #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
