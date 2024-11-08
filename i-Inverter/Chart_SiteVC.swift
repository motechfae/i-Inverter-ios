//
//  Chart_SiteVC.swift
//  i-Inverter
//
//  Created by Alton Huang on 2021/4/14.
//

import UIKit
import AAInfographics

class Chart_SiteVC: UIViewController {

    var testStr: String?
    var currentDateAndTime: String?
    var dateStr: String?
    var dateEnd: String?
    
    var currentDateAndTime2: String?
    
    struct AQI: Codable {
        var sZoneNo: String
        var sMemo: String
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let testStr = testStr {
            print (testStr)
        }
        
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "zh_Hant_TW")
        dateFormat.dateFormat = "yyyy-MM-dd"
        currentDateAndTime = dateFormat.string(from: Date())
        dateStr = currentDateAndTime! + " 05:00"
        dateEnd = currentDateAndTime! + " 18:59"
        print(currentDateAndTime! + "/" + dateStr! + "/" + dateEnd!)
        
        let dateFormat2 = DateFormatter()
        dateFormat2.locale = Locale(identifier: "zh_Hant_TW")
        dateFormat2.dateFormat = "yyyyMMdd"
        currentDateAndTime2 = dateFormat2.string(from: Date())
        
        //g_sZoneNo = "MGLR05"
        //_ = self.showAAChart()
        
        
        var JP_sZoneNo: String?
        DispatchQueue.global().async{
            JP_sZoneNo = ""
            let url = URL(string: "https://i-inverter.motech.com.tw/vUserApisvr/api/values")
            
            var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            
            request.httpBody = "FunCode=V01_MySolarQerrcode06&FunValues='admin';'\(g_sSiteNo)'".data(using: .utf8)
            request.httpMethod = "POST"
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
                                if let _P:String? = (p).sZoneNo {
                                    JP_sZoneNo = _P
                                    g_sZoneNo = JP_sZoneNo!
                                    
                                } else {
                                    JP_sZoneNo = ""
                                }
                                
                            }
                            DispatchQueue.main.async{ [self] in
                                print("The JP_sZoneNo is \(JP_sZoneNo!)")
                                
                                print("Chart_SiteVC(2): " + g_sSiteNo + "/" + g_sSite_Name + "/" + g_sZoneNo)
                                
                                
                                
                                _ = self.showAAChart()
                                //_ = self.showAAChart_temp()
                                
                                //self.test_label.text = "測試1"
                                /*
                                let textLabel = UILabel(frame: CGRect(x: 0, y: 80, width: 200, height: 80))
                                textLabel.text = "測試1"
                                textLabel.textColor = UIColor.gray
                                textLabel.font = UIFont(name: "Helvetica-Light", size: 16)
                                textLabel.textAlignment = NSTextAlignment.left
                                textLabel.numberOfLines = 1
                                textLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
                                textLabel.backgroundColor = UIColor.yellow
                                //textLabel.shadowColor = UIColor.gray
                                //textLabel.shadowOffset = CGSize(width: 2, height: 2)
                                self.view.addSubview(textLabel)
                                */
                                /*
                                let testlayer = CATextLayer()
                                testlayer.string = "測試2"
                                testlayer.frame = CGRect(x: 20, y: 20, width: 200, height: 80)
                                //testlayer.contentsScale = UIScreen.main.scale
                                view.layer.addSublayer(testlayer)
                                */
                                
                                print("Add label")
                                
                            } // end of DispatchQueue.main
                        } else{
                            DispatchQueue.main.async{
                                print("(X)The JP_sZoneNo is \(JP_sZoneNo!)")
                                
                            } // end of DispatchQueue.main
                            
                        }
                        
                        
                    } catch {
                        print("Catch: The JP_sZoneNo is \(JP_sZoneNo!)")
                        
                    }
                    
                }
                //print(error!)
            }
            
            dataTask.resume()
            
            //sleep(3)
            
        }

        print("Chart_SiteVC(1): " + g_sSiteNo + "/" + g_sSite_Name + "/" + g_sZoneNo)
        
        
        
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func showAAChart_temp() -> Bool {
        
        let chartViewWidth  = self.view.frame.size.width
        let chartViewHeight = self.view.frame.size.height
        let aaChartView = AAChartView()
        aaChartView.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)
        
        self.view.addSubview(aaChartView)
        
        
        
        let aaChartModel = AAChartModel()
            .chartType(.area)
            .title(g_sSite_Name + " 發電功率")
            .subtitle(currentDateAndTime! + " 日")
            
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
        
        return true
    }
    
    
    struct AQI_Chart: Codable {
        var sDataKey: String
        var nEa: Double
        var nHi: Int
        var nTmp: Double
    }
    
    var myList_sDataKey = [String]()
    var myList_nEa = [Double]()
    var myList_nHi = [Int]()
    var myList_nTmp = [Double]()
    
    
    func showAAChart() -> Bool {
        
        
        var JP_data: String?
        DispatchQueue.global().async{ [self] in
            JP_data = ""
            let url = URL(string: "https://i-inverter.motech.com.tw/vUserApisvr/api/values")
            
            var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            
            request.httpBody = "FunCode=V01_SettingQuerypara01&FunValues='\(g_sSiteNo)';'\(g_sZoneNo)';'\(dateStr!)';'\(dateEnd!)'".data(using: .utf8)
            
            //let tmpStr:String = "https://i-inverter.motech.com.tw/vUserApisvr/api/values?" + "FunCode=V01_SettingQuerypara01&FunValues='\(g_sSiteNo)';'\(g_sZoneNo)';'\(dateStr!)';'\(dateEnd!)'"
            //print(tmpStr)
            
            request.httpMethod = "POST"
            let session = URLSession(configuration: .default)
            
            let dataTask = session.dataTask(with: request) { [self] (data, response, error) in
                if let data = data {
                    let html = String(data: data, encoding: .utf8)
                    //print(html!)
                    
                    do{
                        let aqi_chart = try! JSONDecoder().decode([AQI_Chart].self, from: data)
                        
                        //print("OK")
                        if aqi_chart.count > 0 {
                        
                            aqi_chart.forEach { (p) in
                                //print(p)
                                if let _P:String? = (p).sDataKey {
                                    //JP_data = _P
                                    
                                    
                                    JP_data = (_P as! NSString).substring(with: NSMakeRange(8, 2)) + ":" + (_P as! NSString).substring(with: NSMakeRange(10, 2))
                                    
                                    myList_sDataKey.append(JP_data!)
                                    myList_nEa.append((p).nEa)
                                    myList_nHi.append((p).nHi)
                                    myList_nTmp.append((p).nTmp)
                                    
                                } else {
                                    JP_data = ""
                                }
                                
                            }
                            DispatchQueue.main.async{
                                //print("The JP_data is \(JP_data!)")
                                //print("The JP_data is \(myList_sDataKey)")
                                //print("The JP_data is \(myList_nEa)")
                                
                                /*
                                var _str: String?
                                for tempStr in myList_sDataKey {
                                    //_str = _str! + String(tempStr)
                                    _str = _str! + tempStr
                                }
                                
                                print("The _str is \(_str!)")
                                */
                                
                                //_ = self.showAAChart_temp()
                                
                                
                                
                                //----------------- Start drawing
                                let chartViewWidth  = self.view.frame.size.width
                                let chartViewHeight = self.view.frame.size.height
                                let aaChartView = AAChartView()
                                aaChartView.frame = CGRect(x:0,y:0,width:chartViewWidth,height:chartViewHeight)
                                
                                self.view.addSubview(aaChartView)
                                
                                
                                
                                let aaChartModel = AAChartModel()
                                    .chartType(.area)
                                    .title(g_sSite_Name + " 發電功率")
                                    .subtitle(currentDateAndTime! + " 日")
                                    
                                    .legendEnabled(true)//是否啟用圖表的圖例(圖表底部的可點擊的小圓點)
                                    .tooltipValueSuffix("發電量")//浮動提示框單位後綴
                                    .colorsTheme(["#fe117c"])//主題顏色數組
                                    
                                    .animationType(.easeInOutExpo)
                                    .animationDuration(0)
                                    .backgroundColor("#FFFFFF")
                                    .dataLabelsEnabled(true)
                                    //.categories(["05:00", "05:40", "06:20", "07:00", "08:20"])
                                    .categories(myList_sDataKey)
                                
                                    .inverted(false)//是否翻轉圖形
                                    
                                    .series([
                                        AASeriesElement()
                                            .name("發電量1")
                                            //.data([3.9, 4.2, 5.7, 8.5, 11.9])
                                            .data(myList_nEa)
                                            .yAxis(0)
                                            .color("#fe117c"),
                                        AASeriesElement()
                                            .name("日照量1")
                                            .type(AAChartType.spline)
                                            //.data([100, 98, 95, 105, 109])
                                            .data(myList_nHi)
                                            .yAxis(1)
                                            .color("#ffc069"),
                                        AASeriesElement()
                                            .name("溫度1")
                                            .type(AAChartType.spline)
                                            //.data([21.1, 22.1, 21.5, 22.3, 20.8])
                                            .data(myList_nTmp)
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
                                //----------------- End drawing
                                
                                
                                _ = self.getLastData()
                                
                                
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
            
            //sleep(3)
            
        }
        
        
        
        
       
        
        print("call showAAChart()")
        
        
        return true
    }
    
    
    struct AQI_TodayData: Codable {
        var sDataKey: String
        var nEa: Double
        var nHi: Int
        var nTmp: Double
        var nTEa: Double
        var nEaMax: Double
    }
    
    
    func getLastData() -> Bool {
        
        var JP_data: String?
        var JP_nEa: String?
        var JP_nHi: String?
        var JP_nTmp: String?
        var JP_nTEa: String?
        var JP_nEaMax: String?
        
        DispatchQueue.global().async{ [self] in
            JP_data = ""
            let url = URL(string: "https://i-inverter.motech.com.tw/vUserApisvr/api/values")
            
            var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            
            request.httpBody = "FunCode=V04_AppToday01&FunValues=\(g_sSiteNo);\(g_sZoneNo);\(currentDateAndTime2!)".data(using: .utf8)
            
            //let tmpStr:String = "https://i-inverter.motech.com.tw/vUserApisvr/api/values?" + "FunCode=V04_AppToday01&FunValues=\(g_sSiteNo);\(g_sZoneNo);\(currentDateAndTime2!)"
            //print(tmpStr)
            
            request.httpMethod = "POST"
            let session = URLSession(configuration: .default)
            
            let dataTask = session.dataTask(with: request) { [self] (data, response, error) in
                if let data = data {
                    let html = String(data: data, encoding: .utf8)
                    //print(html!)
                    
                    do{
                        let aqi_TodayData = try! JSONDecoder().decode([AQI_TodayData].self, from: data)
                        
                        //print("OK")
                        if aqi_TodayData.count > 0 {
                            
                            aqi_TodayData.forEach { (p) in
                                //print(p)
                                if let _P:String? = (p).sDataKey {
                                    JP_data = _P
                                    
                                    JP_nEa = String((p).nEa)
                                    //JP_nHi = String((p).nHi)
                                    JP_nHi = String(format: "%.1f", Double((p).nHi))
                                    //JP_nTmp = String((p).nTmp)
                                    JP_nTmp = String(format: "%.1f", Double((p).nTmp))
                                    JP_nTEa = String((p).nTEa)
                                    JP_nEaMax = String((p).nEaMax)
                            
                                    
                                    
                                } else {
                                    JP_data = ""
                                    
                                    JP_nEa = ""
                                    JP_nHi = ""
                                    JP_nTmp = ""
                                    JP_nTEa = ""
                                    JP_nEaMax = ""
                                }
                                
                            }
                            DispatchQueue.main.async{
                                print("The JP_data is \(JP_data!)")
                                
                                
                                
                                let textLabel = UILabel(frame: CGRect(x: 0, y: 140, width: 180, height: 100))
                                //textLabel.text = "今日累積:32.41kWh" + "\n" + "今日最高:32.89kw" + "\n" + "及時發電功率:7.93kw" + "\n" + "實體日照:42.0W/m2" + "\n" + "模組溫度:18.0°C"
                                textLabel.text = "今日累積:\(JP_nTEa!)kWh" + "\n" + "今日最高:\(JP_nEaMax!)kw" + "\n" + "及時發電功率:\(JP_nEa!)kw" + "\n" + "實體日照:\(JP_nHi!)W/m2" + "\n" + "模組溫度:\(JP_nTmp!)°C"
                                
                                
                                
                                textLabel.textColor = UIColor.gray
                                textLabel.font = UIFont(name: "Helvetica-Light", size: 16)
                                textLabel.textAlignment = NSTextAlignment.left
                                textLabel.numberOfLines = 5
                                textLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
                                //textLabel.backgroundColor = UIColor.yellow
                                textLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 0.4)
                                //textLabel.shadowColor = UIColor.gray
                                //textLabel.shadowOffset = CGSize(width: 2, height: 2)
                                self.view.addSubview(textLabel)
                                
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
            
            //sleep(3)
            
        }
        
        
        print("call getLastData()")
        
        
        return true
    }
    
}





