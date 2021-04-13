//
//  CollectionViewController_1.swift
//  i-Inverter
//
//  Created by Alton Huang on 2021/3/17.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController_1: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

 
    
    //let myList = ["茂迪南科五廠","茂迪南科二廠","永興祥木業","茂迪南科六廠(啟碁)" ,"家樂福安平店","雲林莿桐茂森","台南果菜市場-舊冰庫","台南果菜市場-集貨場","案場一","案場二"]
    
    var myList = [String]()
    var myList_real = [String]()
    //var myList = ["defaultF"]
    var myList2d = [String]()
    var myList2d_real = [String]()
    
    //var myList2Darr = [[String]]()
    
    
    static let width1 = floor((UIScreen.main.bounds.width - 4) / 2)
    
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    */
    
    struct AQI: Codable {
        var sSiteType: String
        var sSiteNo: String
        var sSite_Name: String
        var nSHI: Int
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        /*
        myList.append("3rd")
        myList.remove(at: 0)
        
        for item in myList {
            print(item)
        }
        */
        
        //myList.append("bb")
        
        print("11111")
        myList.removeAll()
        myList2d.removeAll()
        DispatchQueue.global().async{
        
            var JP: String?
            JP = ""
            let url = URL(string: "https://i-inverter.motech.com.tw/vUserApisvr/api/values")
            var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            print("22222")
            
            request.httpBody = "FunCode=V02_RwdDashboard04&FunValues='\(uID_global)'".data(using: .utf8)
            request.httpMethod = "POST"
            print("33333")
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: request) { [self] (data, response, error) in
                if let data = data {
                    let html = String(data: data, encoding: .utf8)
                    //print(html!)
                    
                    do{
                        let aqi = try! JSONDecoder().decode([AQI].self, from: data)
                        
                        //print("OK")
                        
                        aqi.forEach { (p) in
                            //print(p)
                            //JP = (p).sAccount
                            if let _P:String? = (p).sSite_Name {
                                JP = _P
                                
                                if (p).sSiteType == "1" {
                                    myList.append(JP!)
                                    //myList2Darr.append([JP!,String((p).nSHI)])
                                    myList2d.append(String((p).nSHI))
                                }
                                
                                
                                //print("The JP is \(JP!)")
                                
                            } else {
                                JP = ""
                            }
                            //print("The JP is \(JP!)")
                            
                            
                        }
                        myList_real = myList
                        myList2d_real = myList2d
                        
                        DispatchQueue.main.async{
                            self.collectionView.reloadData()
                        }
                        
                        print("YYYYY")
                        
                    } catch {
                        print("Catch: The JP is \(JP!)")
                        
                    }
                    
                }
                //print(error!)
            }
            
            print("44444")
            
            dataTask.resume()
        } //end of DispatchQueue.global().async
        
        print("55555")
        //sleep(3)
        //myList.remove(at: 0)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("BBBBB")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        ///self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        /*
        let cellNib = UINib(nibName: "CollectionViewCell_1", bundle: nil)
        collectionView1.register(cellNib, forCellWithReuseIdentifier: "cell")
        */

        // Do any additional setup after loading the view.
        
        
        
        
        
    }
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return myList.count
        //return myList2Darr.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        /*
        if let label = cell.viewWithTag(200) as? UILabel {
            label.text = myList[indexPath.row]
            print(label.text)
        }
        */
        
        /*
        let imgView = cell.viewWithTag(600) as? UIImageView
        imgView?.image = UIImage(named: "hiGood.png")
        imgView?.backgroundColor = UIColor(red: 50/255, green: 166/255, blue: 0, alpha: 1)
        */
        
        
        let imgView = cell.viewWithTag(601) as? UIImageView
        
        switch myList2d[indexPath.row] {
        case "1":
            imgView?.image = UIImage(named: "hiGood.png")
            imgView?.backgroundColor = UIColor(red: 0/255, green: 166/255, blue: 90/255, alpha: 1)
        case "2":
            imgView?.image = UIImage(named: "hiGoodNew.png")
            imgView?.backgroundColor = UIColor(red: 0/255, green: 166/255, blue: 90/255, alpha: 1)
        case "-3":
            imgView?.image = UIImage(named: "hiAlert.png")
            imgView?.backgroundColor = UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1)
        case "-4":
            imgView?.image = UIImage(named: "hiAlertNew.png")
            imgView?.backgroundColor = UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1)
        case "-5":
            imgView?.image = UIImage(named: "hiBad.png")
            imgView?.backgroundColor = UIColor(red: 221/255, green: 75/255, blue: 57/255, alpha: 1)
        case "-6":
            imgView?.image = UIImage(named: "hiBadNew.png")
            imgView?.backgroundColor = UIColor(red: 221/255, green: 75/255, blue: 57/255, alpha: 1)
        case "0":
            imgView?.image = UIImage(named: "hiSkip.png")
            imgView?.backgroundColor = UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1)
        case "-1":
            imgView?.image = UIImage(named: "hiErr.png")
            imgView?.backgroundColor = UIColor(red: 221/255, green: 75/255, blue: 57/255, alpha: 1)
        case "3":
            imgView?.image = UIImage(named: "hiSleep.png")
            imgView?.backgroundColor = UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1)
        default:
            imgView?.image = UIImage(named: "hiGood.png")
            imgView?.backgroundColor = UIColor(red: 50/255, green: 166/255, blue: 0/255, alpha: 1)
        }
        
        
        let titleLabel = cell.viewWithTag(201) as? UILabel
        titleLabel?.text = myList[indexPath.row]
        //titleLabel!.text = myList2Darr[indexPath.row][0]
        
    
        // Configure the cell
        
        /*
        let cell = collectionView1.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell_1
        cell.setCell2(title: myList[indexPath.row])
        */
        
        return cell
    }


    
    
    
    
    
    // MARK: UICollectionViewDelegate

    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAT indexPath: IndexPath) {
        print(indexPath.section,"-",indexPath.row)
    }
    */
    
    
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print("sizeForItemAt")
        return CGSize(width: CollectionViewController_1.width1, height: 140)
    }
    */
   
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // handle tap events
            print("You selected cell #\(indexPath.item)!")
    }

    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

       if (kind == UICollectionView.elementKindSectionHeader) {
           let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar1", for: indexPath)

                return headerView
            }

            return UICollectionReusableView()

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        self.myList.removeAll()
        self.myList2d.removeAll()
        for index in 0...(myList_real.count - 1){
            if (myList_real[index].lowercased().contains(searchBar.text!.lowercased())){
                self.myList.append(myList_real[index])
                self.myList2d.append(myList2d_real[index])
            }
        }
                 
        if (searchBar.text!.isEmpty) {
            self.myList = self.myList_real
            self.myList2d = self.myList2d_real
        }
        self.collectionView.reloadData()
        
        
        print("searchbar_click")
        
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /*
        self.myList.removeAll()
        self.myList2d.removeAll()
        for index in 0...(myList_real.count - 1){
            if (myList_real[index].lowercased().contains(searchBar.text!.lowercased())){
                self.myList.append(myList_real[index])
                self.myList2d.append(myList2d_real[index])
            }
        }
                 
        if (searchText.isEmpty) {
            self.myList = self.myList_real
            self.myList2d = self.myList2d_real
        }
        self.collectionView.reloadData()
        */
        print("Search data is \(searchText)")
    }
    
 
 
 
}



