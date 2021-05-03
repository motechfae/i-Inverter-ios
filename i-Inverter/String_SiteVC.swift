//
//  String_SiteVC.swift
//  i-Inverter
//
//  Created by Alton Huang on 2021/4/22.
//

import UIKit

let cons_viewHightGap:Float = 80

var str_DateString: String = "← 請選擇日期"
var str_nothing: String = ""
var isGetPara: Bool = false

var myInvList_sSNID = [String]()

var set_Inv = Set<String>()
var set_Para = Set<String>()
var set_myInv_sDataKey_F = Set<String>()

var invStr:String = ""
var invSQLStr:String = ""
var paraStr:String = ""
var paraSQLStr:String = ""
var arr_Inv = [String]()
var arr_Para = [String]()

var colorStr: String = ""

class String_SiteVC: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    struct AQI_InvModel: Codable {
        var nRS485ID: Int
        var sSNID: String
        var sInvModel: String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        dateLabel.text = str_DateString
        
        
        
        myInvList_sSNID.removeAll()
        var JP_data: String?
        DispatchQueue.global().async{ [self] in
            JP_data = ""
            let url = URL(string: "https://i-inverter.motech.com.tw/vUserApisvr/api/values")
            
            var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            
            request.httpBody = "FunCode=V01_MySolarToday09&FunValues='\(g_sSiteNo)';'\(g_sZoneNo)'".data(using: .utf8)
            
            //let tmpStr:String = "https://i-inverter.motech.com.tw/vUserApisvr/api/values?" + "FunCode=V01_MySolarToday09&FunValues='\(g_sSiteNo)';'\(g_sZoneNo)'"
            //print(tmpStr)
            
            request.httpMethod = "POST"
            let session = URLSession(configuration: .default)
            
            let dataTask = session.dataTask(with: request) { [self] (data, response, error) in
                if let data = data {
                    let html = String(data: data, encoding: .utf8)
                    //print(html!)
                    
                    do{
                        let aqi_InvModel = try! JSONDecoder().decode([AQI_InvModel].self, from: data)
                        
                        //print("OK")
                        if aqi_InvModel.count > 0 {
                        
                            aqi_InvModel.forEach { (p) in
                                //print(p)
                                if let _P:String? = (p).sSNID{
                                    JP_data = _P
                                    
                                    
                                    //JP_data = JP_data!.replacingOccurrences(of: "T", with: " ")
                                    
                                    
                                    myInvList_sSNID.append(JP_data!)
                                    
                                    
                                    
                                } else {
                                    JP_data = ""
                                }
                                
                            }
                            DispatchQueue.main.async{
                                //print("The JP_data is \(JP_data!)")
                                //print("The JP_data is \(myInvList_sSNID)")
                                
                                
                                
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
        
        
        //_ = self.showAAChart_test()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let popoverCtrl = segue.destination.popoverPresentationController
        
        if sender is UIButton {
            popoverCtrl?.sourceRect = (sender as! UIButton).bounds
        }
        popoverCtrl?.delegate = self
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
        dateLabel.text = str_DateString
        print("(String_SiteVC)The str_DateString is \(str_DateString)")
    }
    
    
    @IBAction func InvClick(_ sender: Any) {
        set_Inv.removeAll()
        invStr = ""
        arr_Inv.removeAll()
        print("InvClick")
    }
    
    @IBAction func ParaClick(_ sender: Any) {
        set_Para.removeAll()
        paraStr = ""
        arr_Para.removeAll()
        print("ParaClick")
    }
    
    func showAAChart_test() -> Bool {
        
        let chartViewWidth  = self.view.frame.size.width
        let chartViewHeight = self.view.frame.size.height - self.bottomView.frame.height - CGFloat(cons_viewHightGap)
        //let chartViewHeight = self.view.frame.size.height - 200
        
        let aaChartView = AAChartView()
        aaChartView.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)
        
        self.view.addSubview(aaChartView)
        
        
        
        let aaChartModel = AAChartModel()
            .chartType(.area)
            .title("ABC" + " 發電功率")
            .subtitle("2021-04-22" + " 日")
            
            .legendEnabled(true)//是否啟用圖表的圖例(圖表底部的可點擊的小圓點)
            .tooltipValueSuffix("發電量")//浮動提示框單位後綴
            .colorsTheme(["#fe117c"])//主題顏色數組
            
            .animationType(.easeInOutExpo)
            .animationDuration(0)
            .backgroundColor("#FFFFFF")
            .dataLabelsEnabled(true)
            .categories(["05:00", "05:40", "06:20", "07:00", "08:20"])
        
            .inverted(false)//是否翻轉圖形
            
            .series([
                AASeriesElement()
                    .name("發電量1")
                    .data([3.9, 4.2, 5.7, 8.5, 11.9])
                    .yAxis(0)
                    .color("#fe117c"),
                AASeriesElement()
                    .name("日照量1")
                    .type(AAChartType.spline)
                    .data([100, 98, 95, 105, 109])
                    .yAxis(1)
                    .color("#ffc069"),
                AASeriesElement()
                    .name("溫度1")
                    .type(AAChartType.spline)
                    .data([21.1, 22.1, 21.5, 22.3, 20.8])
                    .yAxis(2)
                    .color("#06caf4"),

            ])
        
        let aaOptions = AAOptionsConstructor.configureChartOptions(aaChartModel)
        
        
        //"#fe117c", "#ffc069", "#06caf4", "#7dffc0"
        
        let aaYAxis0 = AAYAxis()
            .visible(true)
            .labels(AALabels()
            .enabled(true)//设置 y 轴是否显示数字
            .style(AAStyle()
                .color("#ff0000")//yAxis Label font color
                .fontSize(12)//yAxis Label font size
                .fontWeight(AAChartFontWeightType.bold)//yAxis Label font weight
            ))
            .gridLineWidth(0)// Y 轴网格线宽度
            .title(AATitle().text("發電量"))//Y 轴标题
            .min(0)
        
        let aaYAxis1 = AAYAxis()
            .visible(true)
            .labels(AALabels()
            .enabled(true)//设置 y 轴是否显示数字
            .style(AAStyle()
                            
            ))
            .opposite(true)
            .title(AATitle().text("日照量"))//Y 轴标题
            .min(0)
        
        let aaYAxis2 = AAYAxis()
            .visible(true)
            .labels(AALabels()
            .enabled(true)//设置 y 轴是否显示数字
            .style(AAStyle()
                            
            ))
            .opposite(true)
            .title(AATitle().text("溫度"))//Y 轴标题
            .min(0)
        
        //aaOptions.yAxisArray(Array(_immutableCocoaArray: aaYAxis0))
        aaOptions.yAxisArray(Array(arrayLiteral: aaYAxis0,aaYAxis1,aaYAxis2))
        
        
        aaOptions.plotOptions?.column?.groupPadding(0)

        
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
        aaChartView.aa_drawChartWithChartOptions(aaOptions)
        
       
        
        print("call showAAChart_temp()")
        print("The chartViewHeight is \(chartViewHeight)")
        
        return true
    }

    
    @IBAction func ShowChart(_ sender: Any) {
        
        _ = self.Commit()
        
        
    }
    
    
    func Commit() -> Bool {
        //_ = self.showAAChart_test()
        
        /*
        var _tempStr:String = "O5418B00594WN@554.5"
        let range = _tempStr.range(of: "@")
        var _tempStr1:String = String(_tempStr.prefix(upTo: range!.lowerBound))
        var _tempStr2:String = String(_tempStr.suffix(from: range!.upperBound))
        print("_tempStr1 is \(_tempStr1); _tempStr2 is \(_tempStr2)")
        return false
        */
        
        
        //arr_Inv.removeAll()
        for item in set_Inv {
            //print("(String_SiteVC)set_Inv has \(item)")
            invStr = invStr + "'" + item + "',"
            arr_Inv.append(item)
        }
        if ((set_Inv.count > 0) && (invStr.count > 0)) {
            let idx = invStr.index(invStr.endIndex, offsetBy: -1)
            invStr = String(invStr.prefix(upTo: idx))
            //invStr = "(" + invStr + ")"
            invStr = "AND B.sSNID in (" + invStr + ")"
            invSQLStr = invStr
        }
        print("invSQLStr is: \(invSQLStr)")
        
        
        
        //arr_Para.removeAll()
        for item in set_Para {
            //print("(String_SiteVC)set_Para has \(item)")
            
            switch item {
            case "nEa":
                paraStr = paraStr + "ROUND((B.nPac)/1000,2) as nEa,"
            case "nPpv":
                paraStr = paraStr + "ROUND((B.nPpv)/1000,2) as nPpv,"
            default:
                paraStr = paraStr + "B." + item + ","
            }
            
            arr_Para.append(item)
        }
        if ((set_Para.count > 0) && (paraStr.count > 0)) {
            let idx = paraStr.index(paraStr.endIndex, offsetBy: -1)
            paraStr = String(paraStr.prefix(upTo: idx))
            paraStr = " ," + paraStr
            paraSQLStr = paraStr
        }
        print("paraSQLStr is: \(paraSQLStr)")
        
        
        
        //print("dateLabel is \(dateLabel.text!)" + ", str_DateString is \(str_DateString)")
        if str_DateString.count != 10 {
            let alertController = UIAlertController(title: "Error", message: "\n" + "請選擇日期", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default) {
                (action) in
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
            return false
        }
        
        //let r = paraStr.contains("nEa")
        //print("r is \(r)")
        
        if (paraStr.contains("nEa") ||
            paraStr.contains("nPpv") ||
            paraStr.contains("nOVol") ||
            paraStr.contains("nVpv") ||
            paraStr.contains("nOCur") ||
            paraStr.contains("nIpv")) {
                if (invSQLStr.count == 0) {
                    let alertController = UIAlertController(title: "Error", message: "\n" + "請至少選擇一台inverter", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "確定", style: .default) {
                        (action) in
                    }
                    alertController.addAction(okAction)
                    present(alertController, animated: true, completion: nil)
                    
                    return false
                }
        }
        
        
        if (invSQLStr.count > 0) && (paraSQLStr.count > 0) {
            _ = self.getInverterStringData()
            
            
            // ["Inv","Para","Val_01","Val_02",...,"Val_NN"]
            
            /*
            var array: [[String]] = []
            
            for row in 0..<2 {
                // Append an empty row.
                array.append([String]())
                for _ in 0..<6 {
                    // Populate the row.
                    array[row].append(String(Int(arc4random_uniform(100))))
                    
                    
                }
            }
            
            
            array.append(["Inv01", "Para01", "69", "2", "6", "81"])
            array.append(["Inv02", "Para02", "97", "30", "33", "10"])
            
            print(array)
            */
            
            
        } else {
            _ = self.getSiteData()
        }
        
        

        
    
        
        print("return true")
        return true
    }
    
    //var dict : [String : Array<String>] = ["A" : ["a1","a2"], "B" : ["b1", "b2"]]
    //var dict = Dictionary<String, Array<String>> ()
    //var dict = Dictionary<String, Array<Array<String>>> ()
    
    //func dimension<T>(_ num: Int,  _ value: T) -> [T] {
    //    return [T](repeating: value, count: num)
    //}
    
    var arr2D: [[String]] = []
    var arr2D_F: [[String]] = []
    
    struct AQI_InvStringData: Codable {
        var sDataKey_sSNID: String?
        var sSNID_Para: String?
        
        var sDataKey: String
        var nRS485ID: Int
        var sSNID: String
        var nEa: Double?
        var nOVol: Double?
        var nOCur: Double?
        var nPpv: Double?
        var nVpv_A: Double?
        var nVpv_B: Double?
        var nVpv_C: Double?
        var nVpv_D: Double?
        var nVpv_E: Double?
        var nVpv_F: Double?
        var nIpv_A: Double?
        var nIpv_B: Double?
        var nIpv_C: Double?
        var nIpv_D: Double?
        var nIpv_E: Double?
        var nIpv_F: Double?
    }
    
    var myInv_sDataKey_sSNID = [String]()
    var sSNID_Para = [String]()
    
    var myInv_sDataKey = [String]()
    var myInv_sDataKey_F = [String]()
    var myInv_sSNID = [String]()
    
    var myInv_nEa = [String]()
    var myInv_nOVol = [String]()
    var myInv_nOCur = [String]()
    var myInv_nPpv = [String]()
    var myInv_nVpv_A = [String]()
    var myInv_nVpv_B = [String]()
    var myInv_nVpv_C = [String]()
    var myInv_nVpv_D = [String]()
    var myInv_nVpv_E = [String]()
    var myInv_nVpv_F = [String]()
    var myInv_nIpv_A = [String]()
    var myInv_nIpv_B = [String]()
    var myInv_nIpv_C = [String]()
    var myInv_nIpv_D = [String]()
    var myInv_nIpv_E = [String]()
    var myInv_nIpv_F = [String]()
    
    var myInv_nPara = [String]()
    
    var sSNID_nEa = [String]()
    var sSNID_nOVol = [String]()
    var sSNID_nOCur = [String]()
    var sSNID_nPpv = [String]()
    var sSNID_nVpv_A = [String]()
    var sSNID_nVpv_B = [String]()
    var sSNID_nVpv_C = [String]()
    var sSNID_nVpv_D = [String]()
    var sSNID_nVpv_E = [String]()
    var sSNID_nVpv_F = [String]()
    var sSNID_nIpv_A = [String]()
    var sSNID_nIpv_B = [String]()
    var sSNID_nIpv_C = [String]()
    var sSNID_nIpv_D = [String]()
    var sSNID_nIpv_E = [String]()
    var sSNID_nIpv_F = [String]()
    
    func getInverterStringData() -> Bool {
        
        myInv_sDataKey_sSNID.removeAll()
        sSNID_Para.removeAll()
        
        myInv_sDataKey.removeAll()
        myInv_sDataKey_F.removeAll()
        myInv_sSNID.removeAll()
        
        myInv_nEa.removeAll()
        myInv_nOVol.removeAll()
        myInv_nOCur.removeAll()
        myInv_nPpv.removeAll()
        myInv_nVpv_A.removeAll()
        myInv_nVpv_B.removeAll()
        myInv_nVpv_C.removeAll()
        myInv_nVpv_D.removeAll()
        myInv_nVpv_E.removeAll()
        myInv_nVpv_F.removeAll()
        myInv_nIpv_A.removeAll()
        myInv_nIpv_B.removeAll()
        myInv_nIpv_C.removeAll()
        myInv_nIpv_D.removeAll()
        myInv_nIpv_E.removeAll()
        myInv_nIpv_F.removeAll()
        myInv_nPara.removeAll()
        
        sSNID_nEa.removeAll()
        sSNID_nOVol.removeAll()
        sSNID_nOCur.removeAll()
        sSNID_nPpv.removeAll()
        sSNID_nVpv_A.removeAll()
        sSNID_nVpv_B.removeAll()
        sSNID_nVpv_C.removeAll()
        sSNID_nVpv_D.removeAll()
        sSNID_nVpv_E.removeAll()
        sSNID_nVpv_F.removeAll()
        sSNID_nIpv_A.removeAll()
        sSNID_nIpv_B.removeAll()
        sSNID_nIpv_C.removeAll()
        sSNID_nIpv_D.removeAll()
        sSNID_nIpv_E.removeAll()
        sSNID_nIpv_F.removeAll()
        set_myInv_sDataKey_F.removeAll()
        var JP_data: String?
        DispatchQueue.global().async{ [self] in
            JP_data = ""
            let url = URL(string: "https://i-inverter.motech.com.tw/vUserApisvr/api/values")
            
            var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            
            request.httpBody = "FunCode=V01_MySolarToday03&FunValues=\(paraSQLStr);'\(g_sSiteNo)';'\(g_sZoneNo)';'\(str_DateString) 04:00';'\(str_DateString) 19:59';\(invSQLStr)".data(using: .utf8)
            
            //let tmpStr:String = "https://i-inverter.motech.com.tw/vUserApisvr/api/values?" + "FunCode=V01_MySolarToday03&FunValues=\(paraSQLStr);'\(g_sSiteNo)';'\(g_sZoneNo)';'\(str_DateString) 04:00';'\(str_DateString) 19:59';\(invSQLStr)"
            //print(tmpStr)
            
            request.httpMethod = "POST"
            let session = URLSession(configuration: .default)
            
            let dataTask = session.dataTask(with: request) { [self] (data, response, error) in
                if let data = data {
                    let html = String(data: data, encoding: .utf8)
                    //print(html!)
                    
                    do{
                        let aqi_InvStringData = try! JSONDecoder().decode([AQI_InvStringData].self, from: data)
                        
                        //print("OK")
                        if aqi_InvStringData.count > 0 {
                        
                            aqi_InvStringData.forEach { (p) in
                                //print(p)
                                if let _P:String? = (p).sDataKey{
                                    JP_data = _P
                                    
                                    
                                    myInv_sDataKey.append(JP_data!)
                                    myInv_sDataKey_sSNID.append((p).sDataKey + "_" + (p).sSNID)
                                    //sSNID_Para.append((p).sSNID + "_" + String((p).nVpv_A!))
                                    
                                    
                                    JP_data = (_P as! NSString).substring(with: NSMakeRange(8, 2)) + ":" + (_P as! NSString).substring(with: NSMakeRange(10, 2))
                                    //myInv_sDataKey_F.append(JP_data!)
                                    set_myInv_sDataKey_F.insert(JP_data!)
                                    
                                    
                                    myInv_sSNID.append((p).sSNID)
                                    if paraStr.contains("nEa") {
                                        myInv_nEa.append(String((p).nEa!))
                                        sSNID_nEa.append((p).sSNID + "@" + String((p).nEa!))
                                    }
                                    if paraStr.contains("nOVol") {
                                        myInv_nOVol.append(String((p).nOVol!))
                                        sSNID_nOVol.append((p).sSNID + "@" + String((p).nOVol!))
                                    }
                                    if paraStr.contains("nOCur") {
                                        myInv_nOCur.append(String((p).nOCur!))
                                        sSNID_nOCur.append((p).sSNID + "@" + String((p).nOCur!))
                                    }
                                    if paraStr.contains("nPpv") {
                                        myInv_nPpv.append(String((p).nPpv!))
                                        sSNID_nPpv.append((p).sSNID + "@" + String((p).nPpv!))
                                    }
                                    
                                    
                                    if paraStr.contains("nVpv_A") {
                                        myInv_nVpv_A.append(String((p).nVpv_A!))
                                        sSNID_nVpv_A.append((p).sSNID + "@" + String((p).nVpv_A!))
                                    }
                                    if paraStr.contains("nVpv_B") {
                                        myInv_nVpv_B.append(String((p).nVpv_B!))
                                        sSNID_nVpv_B.append((p).sSNID + "@" + String((p).nVpv_B!))
                                    }
                                    if paraStr.contains("nVpv_C") {
                                        myInv_nVpv_C.append(String((p).nVpv_C!))
                                        sSNID_nVpv_C.append((p).sSNID + "@" + String((p).nVpv_C!))
                                    }
                                    if paraStr.contains("nVpv_D") {
                                        myInv_nVpv_D.append(String((p).nVpv_D!))
                                        sSNID_nVpv_D.append((p).sSNID + "@" + String((p).nVpv_D!))
                                    }
                                    if paraStr.contains("nVpv_E") {
                                        myInv_nVpv_E.append(String((p).nVpv_E!))
                                        sSNID_nVpv_E.append((p).sSNID + "@" + String((p).nVpv_E!))
                                    }
                                    if paraStr.contains("nVpv_F") {
                                        myInv_nVpv_F.append(String((p).nVpv_F!))
                                        sSNID_nVpv_F.append((p).sSNID + "@" + String((p).nVpv_F!))
                                    }
                                    
                                    if paraStr.contains("nIpv_A") {
                                        myInv_nIpv_A.append(String((p).nIpv_A!))
                                        sSNID_nIpv_A.append((p).sSNID + "@" + String((p).nIpv_A!))
                                    }
                                    if paraStr.contains("nIpv_B") {
                                        myInv_nIpv_B.append(String((p).nIpv_B!))
                                        sSNID_nIpv_B.append((p).sSNID + "@" + String((p).nIpv_B!))
                                    }
                                    if paraStr.contains("nIpv_C") {
                                        myInv_nIpv_C.append(String((p).nIpv_C!))
                                        sSNID_nIpv_C.append((p).sSNID + "@" + String((p).nIpv_C!))
                                    }
                                    if paraStr.contains("nIpv_D") {
                                        myInv_nIpv_D.append(String((p).nIpv_D!))
                                        sSNID_nIpv_D.append((p).sSNID + "@" + String((p).nIpv_D!))
                                    }
                                    if paraStr.contains("nIpv_E") {
                                        myInv_nIpv_E.append(String((p).nIpv_E!))
                                        sSNID_nIpv_E.append((p).sSNID + "@" + String((p).nIpv_E!))
                                    }
                                    if paraStr.contains("nIpv_F") {
                                        myInv_nIpv_F.append(String((p).nIpv_F!))
                                        sSNID_nIpv_F.append((p).sSNID + "@" + String((p).nIpv_F!))
                                    }
                                    
                                    
                                    
                                    
                                } else {
                                    JP_data = ""
                                }
                                
                            }
                            DispatchQueue.main.async{
                                //print("The JP_data is \(JP_data!)")
                                print("The myInv_sDataKey_sSNID is \(myInv_sDataKey_sSNID)")
                                print("The myInv_sDataKey_sSNID.count is \(myInv_sDataKey_sSNID.count)")
                                
                                print("The sSNID_nVpv_A is \(sSNID_nVpv_A)")
                                print("The sSNID_nVpv_A.count is \(sSNID_nVpv_A.count)")
                                
                                print("The myInv_sSNID is \(myInv_sSNID)")
                                print("The myInv_sSNID.count is \(myInv_sSNID.count)")
                                
                                print("The myInv_nEa is \(myInv_nEa)")
                                print("The myInv_nVpv_A is \(myInv_nVpv_A)")
                                print("The myInv_nVpv_A.count is \(myInv_nVpv_A.count)")
                                
                                //myInv_nPara = myInv_nVpv_A
                                //print("The myInv_nPara is \(myInv_nPara)")
                                //print("The myInv_nPara.count is \(myInv_nPara.count)")
                                
                                
                                for item in set_myInv_sDataKey_F.sorted() {
                                    myInv_sDataKey_F.append(item)
                                }
                                set_myInv_sDataKey_F.removeAll()
                                
                                var arr = [String]()
                                /*
                                arr.append("Inv01")
                                arr.append("Para01")
                                for i in 0..<myInv_sDataKey_sSNID.count {
                                    arr.append(myInv_sDataKey[i])
                                }
                                arr2D.append(arr)
                                */
                                
                                arr2D.removeAll()
                                
                                print("myInv_sSNID: \n\(myInv_sSNID)")
                                print("arr_Inv: \n\(arr_Inv)")
                                print("arr_Para: \n\(arr_Para)")
                                
                                
                                if arr_Inv.count > 0 {
                                    for i in 0..<arr_Inv.count {
                                        
                                        if arr_Para.count > 0 {
                                            for j in 0..<arr_Para.count {
                                                
                                                var gotIt:Bool = false
                                                for l in 0..<myInv_sSNID.count {
                                                    if arr_Inv[i] == myInv_sSNID[l]   {
                                                        gotIt = true
                                                        break
                                                    }
                                                }
                                                
                                                
                                                if gotIt == true  {                  // bug: arr_Inv[i] == myInv_sSNID[i]
                                                    if paraStr.contains(arr_Para[j]) {
                                                        myInv_nPara.removeAll()
                                                        isGetPara = false
                                                        print("arr_Para[j] is \(arr_Para[j])")
                                                        switch arr_Para[j] {
                                                            case "nEa":
                                                                for kk in 0..<sSNID_nEa.count {
                                                                    var range = sSNID_nEa[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nEa[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nEa[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nOVol":
                                                                for kk in 0..<sSNID_nOVol.count {
                                                                    var range = sSNID_nOVol[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nOVol[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nOVol[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nOCur":
                                                                for kk in 0..<sSNID_nOCur.count {
                                                                    var range = sSNID_nOCur[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nOCur[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nOCur[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nPpv":
                                                                for kk in 0..<sSNID_nPpv.count {
                                                                    var range = sSNID_nPpv[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nPpv[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nPpv[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nVpv_A":
                                                                for kk in 0..<sSNID_nVpv_A.count {
                                                                    var range = sSNID_nVpv_A[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nVpv_A[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nVpv_A[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nVpv_B":
                                                                for kk in 0..<sSNID_nVpv_B.count {
                                                                    var range = sSNID_nVpv_B[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nVpv_B[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nVpv_B[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nVpv_C":
                                                                for kk in 0..<sSNID_nVpv_C.count {
                                                                    var range = sSNID_nVpv_C[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nVpv_C[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nVpv_C[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nVpv_D":
                                                                for kk in 0..<sSNID_nVpv_D.count {
                                                                    var range = sSNID_nVpv_D[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nVpv_D[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nVpv_D[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nVpv_E":
                                                                for kk in 0..<sSNID_nVpv_E.count {
                                                                    var range = sSNID_nVpv_E[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nVpv_E[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nVpv_E[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nVpv_F":
                                                                for kk in 0..<sSNID_nVpv_F.count {
                                                                    var range = sSNID_nVpv_F[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nVpv_F[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nVpv_F[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nIpv_A":
                                                                for kk in 0..<sSNID_nIpv_A.count {
                                                                    var range = sSNID_nIpv_A[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nIpv_A[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nIpv_A[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nIpv_B":
                                                                for kk in 0..<sSNID_nIpv_B.count {
                                                                    var range = sSNID_nIpv_B[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nIpv_B[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nIpv_B[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nIpv_C":
                                                                for kk in 0..<sSNID_nIpv_C.count {
                                                                    var range = sSNID_nIpv_C[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nIpv_C[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nIpv_C[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nIpv_D":
                                                                for kk in 0..<sSNID_nIpv_D.count {
                                                                    var range = sSNID_nIpv_D[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nIpv_D[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nIpv_D[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nIpv_E":
                                                                for kk in 0..<sSNID_nIpv_E.count {
                                                                    var range = sSNID_nIpv_E[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nIpv_E[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nIpv_E[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            case "nIpv_F":
                                                                for kk in 0..<sSNID_nIpv_F.count {
                                                                    var range = sSNID_nIpv_F[kk].range(of: "@")
                                                                    if arr_Inv[i] == String(sSNID_nIpv_F[kk].prefix(upTo: range!.lowerBound))  {
                                                                        myInv_nPara.append(String(sSNID_nIpv_F[kk].suffix(from: range!.upperBound)))
                                                                    }
                                                                }
                                                                isGetPara = true
                                                            default:
                                                                str_nothing = ""
                                                        }
                                                        
                                                        if isGetPara == true {
                                                            arr.append(arr_Inv[i])
                                                            arr.append(arr_Para[j])
                                                            
                                                            for k in 0..<myInv_nPara.count {
                                                                arr.append(myInv_nPara[k])
                                                            }
                                                            
                                                            arr2D.append(arr)
                                                        }
                                                        
                                                        arr.removeAll()
                                                        myInv_nPara.removeAll()
                                                        isGetPara = false
                                                    }
                                                }
                                                
                                            } // end of for: arr_Para
                                        }
                                    } // end of for: arr_Inv
                                }
                                
                                
                                
                                
                                print("(getInverterStringData)arr2D: \n\(arr2D)")
                                
                                set_Inv.removeAll()
                                set_Para.removeAll()
                                //arr_Inv.removeAll()
                                //arr_Para.removeAll()
                                
                                
                                _ = self.getSiteData()
 
                                
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
        
        
        
        print("call getInverterStringData()")
        return true
    }
    
    
    
    
    struct AQI_SiteData: Codable {
        var sDataKey: String
        var nEa: Double
        var nHi: Int
        var nTmp: Int
    }
    
    var mySite_sDataKey = [String]()
    var mySite_nEa = [Double]()
    var mySite_nHi = [Int]()
    var mySite_nTmp = [Int]()
    
    func getSiteData() -> Bool {
        
        mySite_sDataKey.removeAll()
        mySite_nEa.removeAll()
        mySite_nHi.removeAll()
        mySite_nTmp.removeAll()
        var JP_data: String?
        DispatchQueue.global().async{ [self] in
            JP_data = ""
            let url = URL(string: "https://i-inverter.motech.com.tw/vUserApisvr/api/values")
            
            var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            
            request.httpBody = "FunCode=V01_SettingQuerypara01&FunValues='\(g_sSiteNo)';'\(g_sZoneNo)';'\(str_DateString) 04:00';'\(str_DateString) 19:59'".data(using: .utf8)
            
            //let tmpStr:String = "https://i-inverter.motech.com.tw/vUserApisvr/api/values?" + "FunCode=V01_SettingQuerypara01&FunValues='\(g_sSiteNo)';'\(g_sZoneNo)';'\(str_DateString) 04:00';'\(str_DateString) 19:59'"
            //print(tmpStr)
            
            request.httpMethod = "POST"
            let session = URLSession(configuration: .default)
            
            let dataTask = session.dataTask(with: request) { [self] (data, response, error) in
                if let data = data {
                    let html = String(data: data, encoding: .utf8)
                    //print(html!)
                    
                    do{
                        let aqi_SiteData = try! JSONDecoder().decode([AQI_SiteData].self, from: data)
                        
                        //print("OK")
                        if aqi_SiteData.count > 0 {
                        
                            aqi_SiteData.forEach { (p) in
                                //print(p)
                                if let _P:String? = (p).sDataKey{
                                    //JP_data = _P
                                    
                                    JP_data = (_P as! NSString).substring(with: NSMakeRange(8, 2)) + ":" + (_P as! NSString).substring(with: NSMakeRange(10, 2))
                                    
                                    mySite_sDataKey.append(JP_data!)
                                    mySite_nEa.append((p).nEa)
                                    mySite_nHi.append((p).nHi)
                                    mySite_nTmp.append((p).nTmp)
                                    
                                    
                                } else {
                                    JP_data = ""
                                }
                                
                            }
                            DispatchQueue.main.async{
                                //print("The JP_data is \(JP_data!)")
                                //print("The JP_data is \(mySite_sDataKey)")
                                
                                print("The mySite_sDataKey is \(mySite_sDataKey)")
                                print("The mySite_sDataKey.count is \(mySite_sDataKey.count)")
                                
                                print("The myInv_sDataKey_F is \(myInv_sDataKey_F)")
                                print("The myInv_sDataKey_F.count is \(myInv_sDataKey_F.count)")
                                
                                //print("The arr2D.count is \(arr2D.count)")
                                
                                print("(getSiteData)arr2D: \n\(arr2D)")
                                
                                
                                
                                arr2D_F.removeAll()
                                var arr = [String]()
                                
                                if arr2D.count > 0 {
                                    for row in 0..<arr2D.count {
                                        arr.append(arr2D[row][0])
                                        arr.append(arr2D[row][1])
                                        
                                        for i in 0..<mySite_sDataKey.count {
                                            var idx:Int = -1
                                            var isHaving:Bool = false
                                            for ii in 0..<myInv_sDataKey_F.count {
                                        
                                                if mySite_sDataKey[i] == myInv_sDataKey_F[ii] {
                                                    isHaving = true
                                                    idx = ii
                                                    break
                                                }
                        
                                            }
                                            
                                            if isHaving == true {
                                                arr.append(arr2D[row][2+idx])
                                            } else {
                                                arr.append("nil")
                                            }
                                            
                                        }
                                        
                                        arr2D_F.append(arr)
                                        arr.removeAll()
                                        
                                    } // for row in 0..<arr2D.count
                                    
                                  
                                } // if arr2D.count > 0
                                
                                
                                print("(getSiteData)arr2D_F: \n\(arr2D_F)")
                                
                                
                                if (paraSQLStr.count == 0 && invSQLStr.count == 0) {
                                    _ = self.showAAChart()
                                } else {
                                    _ = self.showAAChart()
                                }
                                
 
                                
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
        
        
        
        return true
    }
    
    
    func getColor() -> String {
        //"#fe117c", "#ffc069", "#06caf4", "#7dffc0"
        
        switch colorStr {
        case "":
            colorStr = "#fe117c"
        case "#fe117c":
            colorStr = "#ffc069"
        case "#ffc069":
            colorStr = "#06caf4"
        case "#06caf4":
            colorStr = "#7dffc0"
        case "#7dffc0":
            colorStr = "#fe117c"
        default:
            str_nothing = ""
        }
        
        return colorStr
    }
    
    
    func showAAChart() -> Bool {
        /*
        if arr2D_F.count > 0 {
            var myList_str = [String]()
            for row in 0..<arr2D_F.count {
                print("Inv is \(arr2D_F[row][0])")
                print("Para is \(arr2D_F[row][1])")
                
                var _para_arr_str:String = ""
                for i in 0..<myInv_sDataKey_F.count {
                    //_para_arr_str = _para_arr_str + arr2D_F[row][2+i]
                    myList_str.append(arr2D_F[row][2+i])
                }
                
                print("Data is \(myList_str)")
                
            }
        }
        return false
        */
        
        colorStr = ""
        
        let chartViewWidth  = self.view.frame.size.width
        let chartViewHeight = self.view.frame.size.height - self.bottomView.frame.height - CGFloat(cons_viewHightGap)
        let aaChartView = AAChartView()
        aaChartView.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)
        
        self.view.addSubview(aaChartView)
        
        
        /*
        val xCategory = listSiteData.map { it.sDataKey.substring(8..9) + ":" + it.sDataKey.substring(10..11) }.toTypedArray()

                // 以SiteData的sDataKey當X軸
                val aaChartModel : AAChartModel = AAChartModel()
                    .chartType(AAChartType.Area)
                    .title(sSite_Name_GLB + " 串列分析")
                    .subtitle(v.txtdate.text.toString())
                    .animationType(AAChartAnimationType.EaseInOutExpo)
                    .animationDuration(0)
                    .backgroundColor("#FFFFFF")
                    .dataLabelsEnabled(true)
                    .categories(xCategory)

                // 初始化左右Y軸
                val aaYAxisArray = mutableListOf<AAYAxis>()
                initLeftYAxis(aaYAxisArray)
                initRightYAxis(aaYAxisArray)

                // 塞左右Y軸資料
                val aaSeriesElementArray = mutableListOf<AASeriesElement>()
                addLeftYSeries(aaSeriesElementArray, xCategory)
                addRightYSeries(aaSeriesElementArray, xCategory)

                var aaOptions = aaChartModel.aa_toAAOptions()
                aaOptions.yAxisArray(aaYAxisArray.toTypedArray())
                    .series(aaSeriesElementArray.toTypedArray())

                v.aa_chart_view2.aa_drawChartWithChartModel(aaChartModel)
                v.aa_chart_view2.aa_drawChartWithChartOptions(aaOptions)
        */
        
        
        
        let aaChartModel = AAChartModel()
            .chartType(.area)
            .title(g_sSite_Name + " 串列分析")
            .subtitle(str_DateString)
            
            .legendEnabled(true)//是否啟用圖表的圖例(圖表底部的可點擊的小圓點)
            .tooltipValueSuffix("發電量")//浮動提示框單位後綴
            .colorsTheme(["#fe117c"])//主題顏色數組
            
            .animationType(.easeInOutExpo)
            .animationDuration(0)
            .backgroundColor("#FFFFFF")
            .dataLabelsEnabled(true)
            //.categories(["05:00", "05:40", "06:20", "07:00", "08:20"])
            .categories(mySite_sDataKey)
        
            .inverted(false)//是否翻轉圖形
            
        
            
            .series([
                AASeriesElement()
                    .name("案場發電功率")
                    //.data([3.9, 4.2, nil, 8.5, 11.9])
                    .data(mySite_nEa)
                    .yAxis(0)
                    //.color("#fe117c"),
                    .color(getColor()),
                
                /*
                AASeriesElement()
                    .name("Ea1")
                    .type(AAChartType.spline)
                    //.data([100, 98, 95, 105, 109])
                    .data(myList_nHi)
                    .yAxis(1),
                    //.color("#ffc069"),
                AASeriesElement()
                    .name("Ea2")
                    .type(AAChartType.spline)
                    //.data([21.1, 22.1, 21.5, 22.3, 20.8])
                    .data(myList_nTmp)
                    .yAxis(1),
                    //.color("#06caf4"),
                */
            ])
            
        if paraStr.contains("nEa") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nEa" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "發電功率")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(0)
                                                        //.color("#ffc069")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nEa" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        
        if paraStr.contains("nPpv") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nPpv" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "輸入功率")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(0)
                                                        //.color("#ffc069")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nPpv" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        
        if paraStr.contains("nVpv_A") {
            if arr2D_F.count > 0 {
                
                var myList_str = [Any] ()
                
                for row in 0..<arr2D_F.count {
                    
                    if arr2D_F[row][1] == "nVpv_A" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                            
                        }
                        
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "nVpv_A")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(1)
                                                        //.color("#ffc069")
                                                        .color(getColor())
                        )
                        
                        //print(arr2D_F[row][0] + "-" + "nVpv_A" + ": Data is \(myList_str)")
                    }
                
                } // for row in 0..<arr2D_F.count
            }
        }
        if paraStr.contains("nVpv_B") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nVpv_B" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "nVpv_B")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(1)
                                                        //.color("#ffc069")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nVpv_B" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        if paraStr.contains("nVpv_C") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nVpv_C" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "nVpv_C")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(1)
                                                        //.color("#ffc069")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nVpv_C" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        if paraStr.contains("nVpv_D") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nVpv_D" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "nVpv_D")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(1)
                                                        //.color("#ffc069")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nVpv_D" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        if paraStr.contains("nVpv_E") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nVpv_E" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "nVpv_E")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(1)
                                                        //.color("#ffc069")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nVpv_E" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        if paraStr.contains("nVpv_F") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nVpv_F" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "nVpv_F")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(1)
                                                        //.color("#ffc069")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nVpv_F" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        if paraStr.contains("nOVol") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nOVol" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "nOVol")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(1)
                                                        //.color("#ffc069")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nOVol" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        if paraStr.contains("nOCur") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nOCur" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "nOCur")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(2)
                                                        //.color("#06caf4")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nOCur" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        if paraStr.contains("nIpv_A") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nIpv_A" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "nIpv_A")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(2)
                                                        //.color("#06caf4")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nIpv_A" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        if paraStr.contains("nIpv_B") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nIpv_B" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "nIpv_B")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(2)
                                                        //.color("#06caf4")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nIpv_B" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        if paraStr.contains("nIpv_C") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nIpv_C" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "nIpv_C")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(2)
                                                        //.color("#06caf4")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nIpv_C" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        if paraStr.contains("nIpv_D") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nIpv_D" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "nIpv_D")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(2)
                                                        //.color("#06caf4")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nIpv_D" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        if paraStr.contains("nIpv_E") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nIpv_E" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "nIpv_E")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(2)
                                                        //.color("#06caf4")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nIpv_E" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        if paraStr.contains("nIpv_F") {
            if arr2D_F.count > 0 {
                var myList_str = [Any] ()
                for row in 0..<arr2D_F.count {
                    if arr2D_F[row][1] == "nIpv_F" {
                        for i in 0..<myInv_sDataKey_F.count {
                            var db:Double = Double(arr2D_F[row][2+i])!
                            if db == 0 {
                                myList_str.append("")
                            } else {
                                myList_str.append(db)
                            }
                        }
                        aaChartModel.series?.append(AASeriesElement()
                                                        .name(arr2D_F[row][0] + "-" + "nIpv_F")
                                                        .type(AAChartType.spline)
                                                        .data(myList_str)
                                                        .yAxis(2)
                                                        //.color("#06caf4")
                                                        .color(getColor())
                        )
                        //print(arr2D_F[row][0] + "-" + "nIpv_F" + ": Data is \(myList_str)")
                    }
                } // for row in 0..<arr2D_F.count
            }
        }
        
        
        if paraStr.contains("nHi") {
            aaChartModel.series?.append(AASeriesElement()
                                            .name("日照計計")
                                            .type(AAChartType.spline)
                                            .data(mySite_nHi)
                                            .yAxis(3)
                                            //.color("#7dffc0")
                                            .color(getColor())
            )
            
            //print( "mySite_nHi is \(mySite_nHi)")
        }
       
        if paraStr.contains("nTmp") {
            aaChartModel.series?.append(AASeriesElement()
                                            .name("溫度計")
                                            .type(AAChartType.spline)
                                            .data(mySite_nTmp)
                                            .yAxis(4)
                                            //.color("#06caf4")
                                            .color(getColor())
            )
            
            //print( "mySite_nTmp is \(mySite_nTmp)")
        }
        
        
        let aaOptions = AAOptionsConstructor.configureChartOptions(aaChartModel)
        
        
        
        
        // 初始化左右Y軸
        // 左邊Y軸設定 (Site nEa, Inv nEa, Inv nPpv 在左邊)
        let aaYAxis0 = AAYAxis()
            .visible(true)
            .labels(AALabels()
            .enabled(true)//设置 y 轴是否显示数字
            .style(AAStyle()
                .color("#ff0000")//yAxis Label font color
                .fontSize(12)//yAxis Label font size
                .fontWeight(AAChartFontWeightType.bold)//yAxis Label font weight
            ))
            .gridLineWidth(0)// Y 轴网格线宽度
            .title(AATitle().text("即時發電功率(kW)"))//Y 轴标题
            .min(0)
        
        
        // 右邊Y軸設定 (伏特(V), 安培(A), W/㎡, ℃)
        
        let aaYAxis1 = AAYAxis()
            .visible(false)
            .labels(AALabels()
            .enabled(true)//设置 y 轴是否显示数字
            .style(AAStyle()
                            
            ))
            .opposite(true)
            .title(AATitle().text("伏特(V)"))//Y 轴标题
            .min(0)
        if (paraStr.contains("nOVol") || paraStr.contains("nVpv")) {
            aaYAxis1.visible = true
        }
        
        let aaYAxis2 = AAYAxis()
            .visible(false)
            .labels(AALabels()
            .enabled(true)//设置 y 轴是否显示数字
            .style(AAStyle()
                            
            ))
            .opposite(true)
            .title(AATitle().text("安培(A)"))//Y 轴标题
            .min(0)
        if (paraStr.contains("nOCur") || paraStr.contains("nIpv")) {
            aaYAxis2.visible = true
        }
        
        let aaYAxis3 = AAYAxis()
            .visible(false)
            .labels(AALabels()
            .enabled(true)//设置 y 轴是否显示数字
            .style(AAStyle()
                            
            ))
            .opposite(true)
            .title(AATitle().text("W/㎡"))//Y 轴标题
            .min(0)
        if paraStr.contains("nHi") {
            aaYAxis3.visible = true
        }
        
        let aaYAxis4 = AAYAxis()
            .visible(false)
            .labels(AALabels()
            .enabled(true)//设置 y 轴是否显示数字
            .style(AAStyle()
                            
            ))
            .opposite(true)
            .title(AATitle().text("℃"))//Y 轴标题
            .min(0)
        if paraStr.contains("nTmp") {
            aaYAxis4.visible = true
        }
        
        
        
        aaOptions.yAxisArray(Array(arrayLiteral: aaYAxis0,aaYAxis1,aaYAxis2,aaYAxis3,aaYAxis4))
        //aaOptions.yAxisArray(Array(arrayLiteral: aaYAxis0,aaYAxis4))
        
        
        aaOptions.plotOptions?.column?.groupPadding(0)

        
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
        aaChartView.aa_drawChartWithChartOptions(aaOptions)
        
        
        print("call showAAChart()")
        arr2D.removeAll()
        arr2D_F.removeAll()
        return true
    }
    
    
    
    
    
   
    
    
    func abc() -> Bool {
        print("call abc()")
        return true
    }
    
}
