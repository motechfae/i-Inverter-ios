//
//  chartTabVC.swift
//  i-Inverter
//
//  Created by Alton Huang on 2021/4/15.
//

import UIKit

var g_sSiteNo: String = ""
var g_sSite_Name: String = ""
var g_sZoneNo: String = ""

class chartTabVC: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        let systemFontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)]
        UITabBarItem.appearance().setTitleTextAttributes(systemFontAttributes, for: UIControl.State.normal)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        
        
        print("chartTabVC: " + g_sSiteNo + "/" + g_sSite_Name + "/" + g_sZoneNo)
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        print("(chart)oooooo")
        
    }
    

}
