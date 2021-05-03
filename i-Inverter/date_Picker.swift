//
//  date_Picker.swift
//  i-Inverter
//
//  Created by Alton Huang on 2021/4/22.
//

import UIKit

class date_Picker: UIViewController {

    @IBOutlet weak var _datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        str_DateString = ""
        
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/M/d H:m"
        formatter.dateFormat = "yyyy-MM-dd"
        str_DateString = formatter.string(from: Date())
        
        _datePicker.date = Date()
        
        
        print("(date_Picker 1)The str_DateString is \(str_DateString)")
        
    }
    
    

    
    @IBAction func valueChanged(_ sender: Any) {
        
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/M/d H:m"
        formatter.dateFormat = "yyyy-MM-dd"
        
        var string = formatter.string(from: (sender as AnyObject).date)
        
        if string == "" {
            string = formatter.string(from: Date())
        } else {
            
        }
        
        str_DateString = string
        print("(date_Picker 2)The str_DateString is \(str_DateString)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
   

    /*
    @IBAction func OK(_ sender: Any) {
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/M/d H:m"
        formatter.dateFormat = "yyyy-MM-dd"
        str_DateString = formatter.string(from: _datePicker.date)
        
        dismiss(animated: true, completion: nil)
    }
    */
    
}
