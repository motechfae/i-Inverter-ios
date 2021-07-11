//
//  ViewController.swift
//  i-Inverter
//
//  Created by Alton Huang on 2021/2/19.
//

import UIKit

var str_PWbySegueBack0: String = ""
var uID_global: String = ""

class LoginVC: UIViewController {
    
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var text_UserID: UITextField!
    @IBOutlet weak var text_UserPW: UITextField!
    @IBOutlet weak var label_userID: UILabel!
    @IBOutlet weak var label_userPW: UILabel!
    
    @IBOutlet weak var login_Switch: UISwitch!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var nextPageBtn: UIButton!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        activity.stopAnimating()
        
        print("str_PWbySegueBack0: \(str_PWbySegueBack0)")
        if str_PWbySegueBack0 == "LoginAgain" {
            self.text_UserPW.text = ""
            print("empty1")
        }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        if let str_PWbySegueBack = str_PWbySegueBack {
            print("str_PWbySegueBack: \(str_PWbySegueBack)")
            if str_PWbySegueBack == "LoginAgain" {
                self.text_UserPW.text = ""
                print("empty1")
            }
        }
        */
        
        
        
    
    
        
        logoImageView.image = UIImage(named: "apple-icon-152x152.png")
        
        nextPageBtn.isEnabled = false
        nextPageBtn.isHidden=true
        
        //判斷 swith(記住我)
        //讀 txt值給 文字框
        let fm = FileManager.default
        var filename_userID = NSHomeDirectory() + "/Documents/userDataID.txt"
        var filename_userPW = NSHomeDirectory() + "/Documents/userDataPW.txt"
        var filename_userLS = NSHomeDirectory() + "/Documents/loginSwitch.txt"
        
        var uPW_Str: String?
        
        if fm.fileExists(atPath: filename_userID) {
            print("(初始)檔案存在")
            do{
                let uID_Str = try String(contentsOfFile: filename_userID, encoding: .utf8)
                text_UserID.text = uID_Str
            } catch {
                
            }
            do{
                uPW_Str = try String(contentsOfFile: filename_userPW, encoding: .utf8)
                //text_UserPW.text = uPW_Str
            } catch {
                
            }
            do{
                let uLS_Str = try String(contentsOfFile: filename_userLS, encoding: .utf8)
                if uLS_Str == "1"{
                    login_Switch.isOn = true
                    text_UserPW.text = uPW_Str
                    if str_PWbySegueBack0 == "LoginAgain" {
                        self.text_UserPW.text = ""
                        print("empty2")
                    }
                } else {
                    login_Switch.isOn = false
                    text_UserPW.text = ""
                }
            } catch {
                
            }
        }
        
    }
    
    
    
    //離開鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
    class DataModel : Codable {
        var FunCode = ""
        var FunValues = ""
    }
    */
    
    struct AQI: Codable {
        var sAccount: String
        var sPassword: String
        var sAccountName: String
        var sEMail: String
    }
    
    //let q = DispatchQueue.global()
    //let q1 = DispatchQueue(label: "q1")

    @IBAction func login(_ sender: Any) {
        //print("submit.")
        
        /*
        var JP: String?
        JP = ""
        let url = URL(string: "https://i-inverter.motech.com.tw/vUserApisvr/api/values")
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        request.httpBody = "FunCode=V01_Login01&FunValues='admin';'iinverter'".data(using: .utf8)
        request.httpMethod = "POST"
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let html = String(data: data, encoding: .utf8)
                //print(html!)
                
                do{
                    let aqi = try! JSONDecoder().decode([AQI].self, from: data)
                    
                    //print("OK")
                    
                    aqi.forEach { (p) in
                        //print(p)
                        JP = (p).sAccount
                        //print(JP)
                    }
                    
                } catch {
                    
                }
                
            }
            //print(error!)
        }
        
        dataTask.resume()
        */
        
                
        
        var c_ID = text_UserID.text!.count
        var c_PW = text_UserPW.text!.count
        //print(c_ID)
        
        var u_ID: String?
        u_ID = text_UserID.text
        var u_PW: String?
        u_PW = text_UserPW.text
        
        activity.startAnimating()

    
        //還有要判斷 swith(記住我)
        if login_Switch.isOn{
            var JP: String?
            if c_ID>0 && c_PW>0 {
                
                /*
                if u_ID == "abc" && u_PW == "123" {
                    _ = userData(uID: u_ID, uPW: u_PW, uLS: "1")
                    
                    let vc = storyboard?.instantiateViewController(withIdentifier: "mainVC")
                    show(vc!, sender: self)
                } else {
                    //寫 alert message
                    let alertController = UIAlertController(title: "Error", message: "輸入 帳號、密碼 不正確！\n" + "\n請重新輸入", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default) {
                        (action) in
                    }
                    alertController.addAction(okAction)
                    present(alertController, animated: true, completion: nil)
                }
                */
                
                
                DispatchQueue.global().async{
                    JP = ""
                    let url = URL(string: "https://i-inverter.motech.com.tw/vUserApisvr/api/values")
                    var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
                    
                    request.httpBody = "FunCode=V01_Login01&FunValues='\(u_ID!)';'\(u_PW!)'".data(using: .utf8)
                    request.httpMethod = "POST"
                    uID_global = u_ID!
                    let session = URLSession(configuration: .default)
                    let dataTask = session.dataTask(with: request) { (data, response, error) in
                        if let data = data {
                            let html = String(data: data, encoding: .utf8)
                            //print(html!)
                            
                            do{
                                let aqi = try! JSONDecoder().decode([AQI].self, from: data)
                                
                                //print("OK")
                                if aqi.count > 0 {
                                
                                    aqi.forEach { (p) in
                                        //print(p)
                                        //JP = (p).sAccount
                                        if let _P:String? = (p).sAccount {
                                            JP = _P
                                            
                                            
                                        } else {
                                            JP = ""
                                        }
                                        DispatchQueue.main.async{
                                            print("(On)The JP is \(JP!)")
                                            print("(On)JP: \(JP!)")
                                            if JP != "" {
                                                _ = self.userData(uID: u_ID, uPW: u_PW, uLS: "1")
                                                
                                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainTabVC")
                                                self.show(vc!, sender: self)
                                            } else {
                                                //寫 alert message
                                                let alertController = UIAlertController(title: "Error", message: "輸入 帳號、密碼 不正確！\n" + "\n請重新輸入", preferredStyle: .alert)
                                                let okAction = UIAlertAction(title: "確定", style: .default) {
                                                    (action) in
                                                }
                                                alertController.addAction(okAction)
                                                self.present(alertController, animated: true, completion: nil)
                                            }
                                            self.activity.stopAnimating()
                                        } // end of DispatchQueue.main
                                    }
                                } else{
                                    DispatchQueue.main.async{
                                        print("(On)The JP is \(JP!)")
                                        print("(On)JP: \(JP!)")
                                        if JP != "" {
                                            _ = self.userData(uID: u_ID, uPW: u_PW, uLS: "1")
                                            
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainTabVC")
                                            self.show(vc!, sender: self)
                                        } else {
                                            //寫 alert message
                                            let alertController = UIAlertController(title: "Error", message: "輸入 帳號、密碼 不正確！\n" + "\n請重新輸入", preferredStyle: .alert)
                                            let okAction = UIAlertAction(title: "確定", style: .default) {
                                                (action) in
                                            }
                                            alertController.addAction(okAction)
                                            self.present(alertController, animated: true, completion: nil)
                                        }
                                        self.activity.stopAnimating()
                                    } // end of DispatchQueue.main
                                    
                                }
                                
                                
                            } catch {
                                print("(On)Catch: The JP is \(JP!)")
                                //self.activity.stopAnimating()
                            }
                            
                        }
                        //print(error!)
                    }
                    
                    dataTask.resume()
                    
                } //end DispathQueue.global()
               
                
            } else { //if c_ID>0 && c_PW>0
                //寫 alert message
                print("(On)Msg")
                let alertController = UIAlertController(title: "Error", message: "請輸入正確帳號、密碼", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default) {
                    (action) in
                }
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
                activity.stopAnimating()
            }
        } else {
            var JP: String?
            if c_ID>0 && c_PW>0 {
                
                /*
                q1.sync {
                }
                */
                
                DispatchQueue.global().async{   //login password 不區分大小寫
                
                    JP = ""
                    let url = URL(string: "https://i-inverter.motech.com.tw/vUserApisvr/api/values")
                    var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
                    
                    request.httpBody = "FunCode=V01_Login01&FunValues='\(u_ID!)';'\(u_PW!)'".data(using: .utf8)
                    request.httpMethod = "POST"
                    uID_global = u_ID!
                    //print("FunCode=V01_Login01&FunValues='\(u_ID!)';'\(u_PW!)'")
                    let session = URLSession(configuration: .default)
                    let dataTask = session.dataTask(with: request) { (data, response, error) in
                        if let data = data {
                            let html = String(data: data, encoding: .utf8)
                            //print(html!)
                            
                            
                            do{
                                
                                let aqi = try! JSONDecoder().decode([AQI].self, from: data)
                                
                                //print("OK")
                                if aqi.count > 0 {
                                
                                
                                
                                    aqi.forEach { (p) in
                                    //print(p)
                                    //JP = (p).sAccount
                                    if let _P:String? = (p).sAccount {
                                        JP = _P
                                        
                                        
                                    } else {
                                        JP = ""
                                    }
                                    print("(Off)The JP is \(JP!)")
                                    DispatchQueue.main.async{
                                        print("(Off)JP: \(JP!)")
                                        if JP != "" {
                                            
                                            _ = self.userData(uID: u_ID, uPW: u_PW, uLS: "0")
                                            
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainTabVC")
                                            self.show(vc!, sender: self)
                                            
                                        } else {
                                            //寫 alert message
                                            print("(Off)Msg")
                                            
                                            let alertController = UIAlertController(title: "Error", message: "輸入 帳號、密碼 不正確！\n" + "\n請重新輸入", preferredStyle: .alert)
                                            let okAction = UIAlertAction(title: "確定", style: .default) {
                                                (action) in
                                            }
                                            alertController.addAction(okAction)
                                            self.present(alertController, animated: true, completion: nil)
                                            
                                        }
                                        self.activity.stopAnimating()
                                    }
                                }
                                } else{
                                    //寫 alert message
                                    DispatchQueue.main.async{
                                        print("(Off)Msg")
                                        
                                        let alertController = UIAlertController(title: "Error", message: "輸入 帳號、密碼 不正確！\n" + "\n請重新輸入", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "確定", style: .default) {
                                            (action) in
                                        }
                                        alertController.addAction(okAction)
                                        self.present(alertController, animated: true, completion: nil)
                                        self.activity.stopAnimating()
                                    } // end of DispathcQueue.main
                                    
                                }
                            } catch {
                                print("(Off)Catch: The JP is \(JP!)")
                                self.activity.stopAnimating()
                            }
                        
                            
                        }
                        //print(error!)
                    }
                    
                    dataTask.resume()
                    
                   
                    /*
                    q1.sync  {
                    }
                    */
                    
                    
                
                } //end DispathQueue.global()
                
                
            } else {  //if c_ID>0 && c_PW>0
                //寫 alert message
                let alertController = UIAlertController(title: "Error", message: "請輸入正確帳號、密碼", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "確定", style: .default) {
                    (action) in
                }
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
                activity.stopAnimating()
                
            }
            
        }
        
        
        
        /*
        if c_ID>0 && c_PW>0 {
            _ = userData(uID: u_ID, uPW: u_PW)
            
        } else {
            //寫 alert message
        }
        */
        
        
        
        
        /*
        let vc = storyboard?.instantiateViewController(withIdentifier: "mainVC")
        show(vc!, sender: self)
        */
    }
    
    func userData(uID: String?, uPW: String?, uLS: String?) -> Bool {
        
        let fm = FileManager.default
        var filename_userID = NSHomeDirectory() + "/Documents/userDataID.txt"
        var filename_userPW = NSHomeDirectory() + "/Documents/userDataPW.txt"
        var filename_loginSwitch = NSHomeDirectory() + "/Documents/loginSwitch.txt"
        
        let _userDataID = uID?.data(using: .utf8)
        let _userDataPW = uPW?.data(using: .utf8)
        let _userDataLS = uLS?.data(using: .utf8)
        
        if fm.fileExists(atPath: filename_userID) {
            print("檔案存在")
            
            do{
                try fm.removeItem(atPath: filename_userID)
                
                fm.createFile(atPath: filename_userID, contents: _userDataID, attributes: nil)
                label_userID.text = uID
            } catch {
                print("Error: Delete userDataID.txt")
            }
            
            do{
                try fm.removeItem(atPath: filename_userPW)
                
                fm.createFile(atPath: filename_userPW, contents: _userDataPW, attributes: nil)
                label_userPW.text = uPW
            } catch {
                print("Error: Delete userDataPW.txt")
            }
            
            do{
                try fm.removeItem(atPath: filename_loginSwitch)
                
                fm.createFile(atPath: filename_loginSwitch, contents: _userDataLS, attributes: nil)
                
            } catch {
                print("Error: Delete userDataLS.txt")
            }
            
            
        } else {
            print("檔案不存在")
            
            
            fm.createFile(atPath: filename_userID, contents: _userDataID, attributes: nil)
            label_userID.text = uID
            fm.createFile(atPath: filename_userPW, contents: _userDataPW, attributes: nil)
            label_userPW.text = uPW
            
            fm.createFile(atPath: filename_loginSwitch, contents: _userDataLS, attributes: nil)
        }
        
        
        
        
        return true
    }
    
    
}

