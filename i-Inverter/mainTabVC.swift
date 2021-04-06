//
//  mainTabVC.swift
//  i-Inverter
//
//  Created by Alton Huang on 2021/3/12.
//

import UIKit

class mainTabVC: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("(2)oooooo")
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)
     
        if isMovingFromParent {
            print("ccc")
            
            str_PWbySegueBack0 = "LoginAgain"
            print("(2)str_PWbySegueBack0: \(str_PWbySegueBack0)")
        }
     }
     
}
