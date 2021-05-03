//
//  ErrorCode_SiteVC.swift
//  i-Inverter
//
//  Created by Alton Huang on 2021/4/21.
//

import UIKit

class ErrorCode_SiteVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //var myList = [("sunrise", "AA", "aaa"),
    //              ("snow", "BB", "bbb"),
    //              ("bicycle", "CC", "ccc")
    //            ]
    /*
    var myList = [("1", "A1", "A2", "A3", "aaa"),
                  ("0", "B1", "B2", "B3", "bbb"),
                  ("1", "C1", "C2", "C3", "ccc")
                ]
    */
    
    var myList_ConChk = [String]()
    var myList_sSNID = [String]()
    var myList_nRS485ID = [String]()
    var myList_nEa = [String]()
    var myList_dCreat_Time = [String]()
    var myList_sErrCode = [String]()
    
    
    struct AQI_ErrorCode: Codable {
        var ConChk: String
        var sSNID: String
        var nRS485ID: Int
        var nEa: Int
        var dCreat_Time: String
        var sErrCode: String
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        myList_sSNID.removeAll()
        //myList2d.removeAll()
        
        var JP_data: String?
        DispatchQueue.global().async{ [self] in
            JP_data = ""
            let url = URL(string: "https://i-inverter.motech.com.tw/vUserApisvr/api/values")
            
            var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            
            request.httpBody = "FunCode=V01_MySolarToday08&FunValues='\(g_sSiteNo)';'\(g_sZoneNo)'".data(using: .utf8)
            
            //let tmpStr:String = "https://i-inverter.motech.com.tw/vUserApisvr/api/values?" + "FunCode=V01_MySolarToday08&FunValues='\(g_sSiteNo)';'\(g_sZoneNo)'"
            //print(tmpStr)
            
            request.httpMethod = "POST"
            let session = URLSession(configuration: .default)
            
            let dataTask = session.dataTask(with: request) { [self] (data, response, error) in
                if let data = data {
                    let html = String(data: data, encoding: .utf8)
                    //print(html!)
                    
                    do{
                        let aqi_errCode = try! JSONDecoder().decode([AQI_ErrorCode].self, from: data)
                        
                        //print("OK")
                        if aqi_errCode.count > 0 {
                        
                            aqi_errCode.forEach { (p) in
                                //print(p)
                                if let _P:String? = (p).dCreat_Time{
                                    JP_data = _P
                                    
                                    
                                    JP_data = JP_data!.replacingOccurrences(of: "T", with: " ")
                                    
                                    
                                    myList_sSNID.append((p).sSNID)
                                    myList_ConChk.append((p).ConChk)
                                    myList_nRS485ID.append(String((p).nRS485ID))
                                    myList_nEa.append(String((p).nEa))
                                    myList_dCreat_Time.append(JP_data!)
                                    //myList_sErrCode.append((p).sErrCode)
                                    if (p).sErrCode == "" {
                                        myList_sErrCode.append("No Error")
                                    } else {
                                        myList_sErrCode.append((p).sErrCode)
                                    }
                                    
                                    
                                } else {
                                    JP_data = ""
                                }
                                
                            }
                            DispatchQueue.main.async{
                                //print("The JP_data is \(JP_data!)")
                                //print("The JP_data is \(myList_sSNID)")
                                //print("The JP_data is \(myList_sErrCode)")
                                
                                
                                
                                tableView.reloadData()
                                
                                
                            } // end of DispatchQueue.main
                        } else{
                            DispatchQueue.main.async{
                                print("(X)The JP_data is \(JP_data!)")
                                
                            } // end of DispatchQueue.main
                            
                        }
                        
                        
                    } catch {
                        print("Catch: The JP_data is \(JP_data!)")
                        
                    }
                    
                }
                //print(error!)
            }
            
            dataTask.resume()
        
            
        } //end of DispatchQueue.global().async
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("ErrorCode_SiteVC(1): " + g_sSiteNo + "/" + g_sZoneNo)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return myList.count
        return myList_sSNID.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        /*
        cell.imageView?.image = UIImage(systemName: myList[indexPath.row].0)
        cell.textLabel?.text = myList[indexPath.row].1
        cell.detailTextLabel?.text = myList[indexPath.row].2
         
         cell.accessoryType = .none
         cell.accessoryView = getAccessoryImg()
        */
        
    
        /*
        if myList[indexPath.row].0 == "1" {
            cell.imageView?.image = UIImage.init(named: "connect")
        } else {
            cell.imageView?.image = UIImage.init(named: "disconnect")
        }
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = myList[indexPath.row].1
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "A2" + "\n" + "A3"
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
            //label.backgroundColor = UIColor.red
            label.font = UIFont(name: "Helvetica Neue", size: 16)
            label.highlightedTextColor = UIColor.white
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = UIColor.blue
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textAlignment = .right
            label.clipsToBounds = true
            label.autoresizesSubviews = true
            label.contentMode = .left
            label.text = "No Error"

            cell.accessoryView = label
        */
        
        if myList_ConChk[indexPath.row] == "1" {
            cell.imageView?.image = UIImage.init(named: "connect")
        } else {
            cell.imageView?.image = UIImage.init(named: "disconnect")
        }
        
        cell.textLabel?.text = myList_sSNID[indexPath.row] + "(" + myList_nRS485ID[indexPath.row] + ")"
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = myList_nEa[indexPath.row] + " kw" + "\n" + myList_dCreat_Time[indexPath.row]
        
        var tmpStr:String = myList_sErrCode[indexPath.row]
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
            label.font = UIFont(name: "Helvetica Neue", size: 16)
            label.highlightedTextColor = UIColor.white
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textAlignment = .right
            label.clipsToBounds = true
            label.autoresizesSubviews = true
            label.contentMode = .left
            
            /*
            if tmpStr == "" {
                label.textColor = UIColor.blue
                label.text = "No Error"
            } else {
                label.textColor = UIColor.red
                label.text = tmpStr
            }
            */
            if tmpStr == "No Error" {
                label.textColor = UIColor.blue
            } else {
                label.textColor = UIColor.red
            }
            label.text = tmpStr

            cell.accessoryView = label
        
        //print("call cellForRowAt")
        
        
        
        return cell
    }
    
    func getAccessoryImg() -> UIView{
            let vi = UIImageView.init(frame: CGRect.init(x: 0, y: 14, width: 16, height: 16))
            vi.image = UIImage.init(named: "hiGood")
        return vi
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        var tmpStr:String = myList_sErrCode[indexPath.row]
        
        if tmpStr == "" {
            tmpStr = "No Error"
        }
        
        print(tmpStr)
        */
        
        //print(myList_sErrCode[indexPath.row])
        
        let alertController = UIAlertController(title: "Error Code", message: "\n" + myList_sErrCode[indexPath.row], preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default) {
            (action) in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
        //tableView.reloadData()

    }
    
}
