//
//  inv_VC.swift
//  i-Inverter
//
//  Created by Alton Huang on 2021/4/23.
//

import UIKit

class inv_VC: UIViewController,UIAdaptivePresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    /*
    var arraylist:[(title:String,check: Bool)]
                 = [("aa:1", false),
                  ("bb:2", false),
                  ("cc:3", false)
                ]
    */
    
    var set_Inv_temp = Set<String>()
    
    var arraylist:[(title:String, index_title:String, check: Bool)]
                 = [("aa", "00_aa", false),
                  ("bb", "01_bb", false),
                  ("cc", "02_cc", false)
                ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        set_Inv.removeAll()
        
        arraylist.removeAll()
        
        /*
        var temp_Str:String = "abc"
        temp_Str = String(format: "%02d", 2) + "abc"
        print("temp_Str is \(temp_Str)")
        */
        
        var temp_Int:Int = 0
        for i in myInvList_sSNID {
            //arraylist.append((i, false))
            
            arraylist.append((i, String(format: "%02d", temp_Int) + "_" + i, false))
            temp_Int = temp_Int + 1
        }
        
        //print("arraylist is \n")
        //print(arraylist)
        
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination.presentationController
        vc?.delegate = self
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func OK(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OFF(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! inv_TableViewCell
        
        cell.textLabel?.text = arraylist[indexPath.row].title
        cell.inv_check.isOn = arraylist[indexPath.row].check
        cell.inv_check.tag = indexPath.row
        
        
        //print("call cellForRowAt")
        
            
        
        return cell
    }

    
    
    
    @IBAction func switchValueChanged(_ sender: UISwitch!) {
        
        if sender.isOn {
            //print(arraylist[sender.tag].title)
            
            //set_Inv.insert(arraylist[sender.tag].title)
            
            set_Inv_temp.insert(arraylist[sender.tag].index_title)
            
            //for item in set_Inv {
            //    print("(insert)set_Inv has \(item)")
            //}
            
        } else {
            
            //set_Inv.remove(arraylist[sender.tag].title)
            
            set_Inv_temp.remove(arraylist[sender.tag].index_title)
            
            //for item in set_Inv {
            //    print("(remove)set_Inv has \(item)")
            //}
        }
        
        
        if (set_Inv_temp.count > 0) {
            set_Inv.removeAll()
            for item in set_Inv_temp.sorted() {
                let index = item.index(item.startIndex, offsetBy: 3)
                let tempStr = String(item.suffix(from: index))
                set_Inv.insert(tempStr)
                //print("set_Inv_temp has \(item)")
            }
        }
        
        if (set_Inv.count > 0) {
            print("(inv_VC)set_Inv:\n")
            for item in set_Inv {
                print("\(item)\n")
            }
        }
        
    }
    
    
    @IBAction func SelectAll(_ sender: Any) {
        for row in 0..<arraylist.count {
            arraylist[row].check = true
        }
        tableView.reloadData()
        
        
        set_Inv_temp.removeAll()
        for row in 0..<arraylist.count {
            set_Inv_temp.insert(arraylist[row].index_title)
        }
        
        if (set_Inv_temp.count > 0) {
            set_Inv.removeAll()
            for item in set_Inv_temp.sorted() {
                let index = item.index(item.startIndex, offsetBy: 3)
                let tempStr = String(item.suffix(from: index))
                set_Inv.insert(tempStr)
                //print("set_Inv_temp has \(item)")
            }
        }
        
        if (set_Inv.count > 0) {
            print("(inv_VC)set_Inv:\n")
            for item in set_Inv {
                print("\(item)\n")
            }
        }
        
    }
    
    
}
