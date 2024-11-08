//
//  para_VC.swift
//  i-Inverter
//
//  Created by Alton Huang on 2021/4/23.
//

import UIKit

class para_VC: UIViewController, UIAdaptivePresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var set_Para_temp = Set<String>()
    
    var arraylist:[(title:String, para:String, check: Bool)]
                 = [("交流側_發電功率", "00_nEa", false),
                  ("交流側_電壓", "01_nOVol", false),
                  ("交流側_電流", "02_nOCur", false),
                  ("直流側_輸入功率", "03_nPpv", false),
                  ("直流側_輸入電壓-A串", "04_nVpv_A", false),
                  ("直流側_輸入電壓-B串", "05_nVpv_B", false),
                  ("直流側_輸入電壓-C串", "06_nVpv_C", false),
                  ("直流側_輸入電壓-D串", "07_nVpv_D", false),
                  ("直流側_輸入電壓-E串", "08_nVpv_E", false),
                  ("直流側_輸入電壓-F串", "09_nVpv_F", false),
                  ("直流側_輸入電壓-G串", "10_nVpv_G", false),
                  ("直流側_輸入電壓-H串", "11_nVpv_H", false),
                  ("直流側_輸入電壓-I串", "12_nVpv_I", false),
                  ("直流側_輸入電壓-J串", "13_nVpv_J", false),
                  ("直流側_輸入電壓-K串", "14_nVpv_K", false),
                  ("直流側_輸入電壓-L串", "15_nVpv_L", false),
                  ("直流側_輸入電流-A串", "16_nIpv_A", false),
                  ("直流側_輸入電流-B串", "17_nIpv_B", false),
                  ("直流側_輸入電流-C串", "18_nIpv_C", false),
                  ("直流側_輸入電流-D串", "19_nIpv_D", false),
                  ("直流側_輸入電流-E串", "20_nIpv_E", false),
                  ("直流側_輸入電流-F串", "21_nIpv_F", false),
                  ("直流側_輸入電流-G串", "22_nIpv_G", false),
                  ("直流側_輸入電流-H串", "23_nIpv_H", false),
                  ("直流側_輸入電流-I串", "24_nIpv_I", false),
                  ("直流側_輸入電流-J串", "25_nIpv_J", false),
                  ("直流側_輸入電流-K串", "26_nIpv_K", false),
                  ("直流側_輸入電流-L串", "27_nIpv_L", false),
                  ("感測器_日照計", "28_nHi", false),
                  ("感測器_溫度計", "29_nTmp", false)
                ]
    
    var arraylist_real:[(title:String, para:String, check: Bool)]
                = [("交流側_發電功率", "00_nEa", false),
                 ("交流側_電壓", "01_nOVol", false),
                 ("交流側_電流", "02_nOCur", false),
                 ("直流側_輸入功率", "03_nPpv", false),
                 ("直流側_輸入電壓-A串", "04_nVpv_A", false),
                 ("直流側_輸入電壓-B串", "05_nVpv_B", false),
                 ("直流側_輸入電壓-C串", "06_nVpv_C", false),
                 ("直流側_輸入電壓-D串", "07_nVpv_D", false),
                 ("直流側_輸入電壓-E串", "08_nVpv_E", false),
                 ("直流側_輸入電壓-F串", "09_nVpv_F", false),
                 ("直流側_輸入電壓-G串", "10_nVpv_G", false),
                 ("直流側_輸入電壓-H串", "11_nVpv_H", false),
                 ("直流側_輸入電壓-I串", "12_nVpv_I", false),
                 ("直流側_輸入電壓-J串", "13_nVpv_J", false),
                 ("直流側_輸入電壓-K串", "14_nVpv_K", false),
                 ("直流側_輸入電壓-L串", "15_nVpv_L", false),
                 ("直流側_輸入電流-A串", "16_nIpv_A", false),
                 ("直流側_輸入電流-B串", "17_nIpv_B", false),
                 ("直流側_輸入電流-C串", "18_nIpv_C", false),
                 ("直流側_輸入電流-D串", "19_nIpv_D", false),
                 ("直流側_輸入電流-E串", "20_nIpv_E", false),
                 ("直流側_輸入電流-F串", "21_nIpv_F", false),
                 ("直流側_輸入電流-G串", "22_nIpv_G", false),
                 ("直流側_輸入電流-H串", "23_nIpv_H", false),
                 ("直流側_輸入電流-I串", "24_nIpv_I", false),
                 ("直流側_輸入電流-J串", "25_nIpv_J", false),
                 ("直流側_輸入電流-K串", "26_nIpv_K", false),
                 ("直流側_輸入電流-L串", "27_nIpv_L", false),
                 ("感測器_日照計", "28_nHi", false),
                 ("感測器_溫度計", "29_nTmp", false)
               ]
    
    var arraylist_SearchBar:[(title:String, para:String, check: Bool)]
                = [("交流側_發電功率", "00_nEa", false),
                 ("交流側_電壓", "01_nOVol", false),
                 ("交流側_電流", "02_nOCur", false),
                 ("直流側_輸入功率", "03_nPpv", false),
                 ("直流側_輸入電壓-A串", "04_nVpv_A", false),
                 ("直流側_輸入電壓-B串", "05_nVpv_B", false),
                 ("直流側_輸入電壓-C串", "06_nVpv_C", false),
                 ("直流側_輸入電壓-D串", "07_nVpv_D", false),
                 ("直流側_輸入電壓-E串", "08_nVpv_E", false),
                 ("直流側_輸入電壓-F串", "09_nVpv_F", false),
                 ("直流側_輸入電壓-G串", "10_nVpv_G", false),
                 ("直流側_輸入電壓-H串", "11_nVpv_H", false),
                 ("直流側_輸入電壓-I串", "12_nVpv_I", false),
                 ("直流側_輸入電壓-J串", "13_nVpv_J", false),
                 ("直流側_輸入電壓-K串", "14_nVpv_K", false),
                 ("直流側_輸入電壓-L串", "15_nVpv_L", false),
                 ("直流側_輸入電流-A串", "16_nIpv_A", false),
                 ("直流側_輸入電流-B串", "17_nIpv_B", false),
                 ("直流側_輸入電流-C串", "18_nIpv_C", false),
                 ("直流側_輸入電流-D串", "19_nIpv_D", false),
                 ("直流側_輸入電流-E串", "20_nIpv_E", false),
                 ("直流側_輸入電流-F串", "21_nIpv_F", false),
                 ("直流側_輸入電流-G串", "22_nIpv_G", false),
                 ("直流側_輸入電流-H串", "23_nIpv_H", false),
                 ("直流側_輸入電流-I串", "24_nIpv_I", false),
                 ("直流側_輸入電流-J串", "25_nIpv_J", false),
                 ("直流側_輸入電流-K串", "26_nIpv_K", false),
                 ("直流側_輸入電流-L串", "27_nIpv_L", false),
                 ("感測器_日照計", "28_nHi", false),
                 ("感測器_溫度計", "29_nTmp", false)
               ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        set_Para.removeAll()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! para_TableViewCell
        
        cell.textLabel?.text = arraylist[indexPath.row].title
        cell.para_check.isOn = arraylist[indexPath.row].check
        cell.para_check.tag = indexPath.row
        
        
        //print("call cellForRowAt")
        
            
        
        return cell
    }
    
    
    @IBAction func switchValueChanged(_ sender: UISwitch!) {
        if sender.isOn {
            //print(arraylist[sender.tag].title)
            
            //set_Para.insert(arraylist[sender.tag].para)
            set_Para_temp.insert(arraylist[sender.tag].para)
            
            //for item in set_Para {
            //    print("(insert)set_Para has \(item)")
            //}
            
        } else {
            
            //set_Para.remove(arraylist[sender.tag].para)
            set_Para_temp.remove(arraylist[sender.tag].para)
            
            //for item in set_Para {
            //    print("(remove)set_Para has \(item)")
            //}
        }
        
        if (set_Para_temp.count > 0) {
            set_Para.removeAll()
            for item in set_Para_temp.sorted() {
                let index = item.index(item.startIndex, offsetBy: 3)
                let tempStr = String(item.suffix(from: index))
                set_Para.insert(tempStr)
            }
        }
        
        if (set_Para.count > 0) {
            print("(para_VC)set_Para:\n")
            for item in set_Para {
                print("\(item)\n")
            }
        }
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        self.arraylist.removeAll()
        for index in 0...(arraylist_SearchBar.count - 1){
            if (arraylist_SearchBar[index].title.lowercased().contains(searchBar.text!.lowercased())){
                
                self.arraylist.append(arraylist_SearchBar[index])
            }
        }
                 
        if (searchBar.text!.isEmpty) {
            self.arraylist = self.arraylist_real
        }
        
        self.tableView.reloadData()
        
        
        print("searchbar_click")
        
        
        
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("Search data is \(searchText)")
    }
    
    
}
