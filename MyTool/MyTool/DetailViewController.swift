//
//  DetailViewController.swift
//  MyTool
//
//  Created by 顾鹏凌 on 2017/1/10.
//  Copyright © 2017年 顾鹏凌. All rights reserved.
//

import UIKit

@objc protocol DetailDelegate:NSObjectProtocol {
    func lastDo(data:Any)
    @objc optional func isCompleted() -> Bool //可选
}
//    swift写法声明一个block
typealias changUserName = (String) ->()//A

//MARK:- 数字转大写汉字
class numToCha {
    /** 数字转小写汉字 */
    class func numChaMin(num:String) -> String {
        return convert(money: num, type:0)
    }
    /** 数字转大写汉字 */
    class func numChaMax(num:String) -> String {
        return convert(money: num, type:1)
    }
    //禁止创建实例
    private init(){}
    
    private class func convert(money:String , type:Int) -> String {
        if Float(money)! > 1_0000_0000_0000.0 {
            return "超出范围最大为“兆”！"
        }
        
        var strMoney = money
        print(strMoney)
        
        
        let arrScale:NSArray = ["分", "角", "元", "拾", "佰", "仟", "万", "拾", "佰", "仟", "亿", "拾", "佰", "仟", "兆", "拾", "佰", "仟" ]
        let arrBase :NSArray = ["零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"]
        
        if strMoney.contains("0") {
            
            //删除字符串中的.
            let range: Range<String.Index> = strMoney.range(of: ".")!
            //    let index: Int = strMoney.distance(from: strMoney.startIndex, to: range.lowerBound)
            strMoney.replaceSubrange(range, with: "")
            print(strMoney)
            
        }else {
            strMoney += "00"
        }
        
        //将数字放到数组中
        let arrChar:NSMutableArray = NSMutableArray()
        for ccci in strMoney.characters {
            arrChar.add("\(ccci)")
        }
        print(arrChar)

        
        func checkToNormal(arrAll:inout NSMutableArray) -> String{
            for indexForZero in 0 ..< arrAll.count {
                let str:String = arrAll.object(at: indexForZero) as! String
                if str.contains("零") {
                    if indexForZero < arrAll.count {
                        print("indexForZero== \(indexForZero)  count == \(arrAll.count)")
                        
                        if indexForZero + 1 >= arrAll.count {
                            break
                        }

                        let strNext:String = arrAll.object(at: indexForZero + 1) as! String
                        if strNext.contains("零") {
                            if str.contains("元") {
                                arrAll.replaceObject(at: indexForZero, with: "元")
                            } else if str.contains("亿") {
                                arrAll.replaceObject(at: indexForZero, with: "亿")
                            } else if str.contains("万") {
                                arrAll.replaceObject(at: indexForZero, with: "万")
                            }
                            else {
                                arrAll.replaceObject(at: indexForZero, with: "")
                                
                            }
                        }else{
                            if str.contains("元") {
                                arrAll.replaceObject(at: indexForZero, with: "元零")
                            } else if str.contains("亿") {
                                arrAll.replaceObject(at: indexForZero, with: "亿零")
                            } else if str.contains("万") {
                                arrAll.replaceObject(at: indexForZero, with: "万零")
                            }
                            //                            arrAll.replaceObject(at: indexForZero, with: ("\(arrAll.index(of: indexForZero)) + \("零")"))
                        }
                        
                    }
                    print(str)
                }
            }
            
            var outStr = ""
            var i = 0
            for str in arrAll {
                outStr += str as! String
                if outStr.contains("元零") && i == 0 {
                    outStr = ""
                }

                i += 1
            }
            
            if outStr.contains("零元") {
                let rangeM: Range<String.Index> = outStr.range(of: "零元")!
                outStr.replaceSubrange(rangeM, with: "元")
            }
            if outStr.contains("零角") {
                let rangeM: Range<String.Index> = outStr.range(of: "零角")!
                outStr.replaceSubrange(rangeM, with: "零")
            }
            if outStr.contains("零分") {
                let rangeM: Range<String.Index> = outStr.range(of: "零分")!
                outStr.replaceSubrange(rangeM, with: "")
            }

            
            print( "outStr= \(outStr)")
            return outStr
        }

        
        var M:String = ""
        var arrAllData = NSMutableArray()
        for indexi in ((0 + 1)...arrChar.count).reversed()  {
            print("indexi = \(indexi)  arrCharcount = \(arrChar.count)")
            let str:NSString = arrChar[arrChar.count - indexi] as! NSString
            let base:String = arrBase[Int(str.intValue)] as! String
            print(base)
//            M.append(base )
            //        let x = strMoney.substring(to: strMoney.index(before: strMoney.endIndex))
            //        print(x)
            
            let index = strMoney.index(strMoney.endIndex, offsetBy: -(indexi-1))
            let suffix = strMoney.substring(from: index)
            print(suffix)
            
            
            
            //        let strP:String = arrChar[arrChar.count - indexi] as! String
            if Int(suffix) == 0 && indexi != 1 && indexi != 2 && indexi < 4 {
//                M.append("元整")
                arrAllData.add("\(base)")
                arrAllData.add("元整")
                
//                print(M)
                break
            }
            
            let scale = arrScale[indexi - 1]
//            M.append(scale as! String)
//            print(M)
            
            let strToArr = "\(base)" + "\(scale)"
            arrAllData.add(strToArr)
            
            
            
            
        }
        
        //    checkZero(numCheck: &M)
        M = checkToNormal(arrAll: &arrAllData)
        
        return M
        
    }
}



class DetailViewController: UIViewController {

    
    var detailDelegate:DetailDelegate!

    
    
    @IBOutlet var txfTixtRMB:UITextField!
    @IBOutlet var txfEatRMB:UITextField!
    @IBOutlet var txfOtherRMB:UITextField!
    @IBOutlet var labCountNum:UILabel!
    @IBOutlet var labCountCha:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "详情"
        
//        内部调用block
        let tools = HttpTools(names: 12) { (data) in
            print("\(data)")
        }
        print(tools)
        
        
        let ajaxResult = ajaxTools(name: "fuck") { (name, isShow) -> (String, Bool) in
            print("-----\(name)---\(isShow)---")
            return ("asasdsad",true)
        }
        print(ajaxResult)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- 闭包block
//    其他类使用
    var changName: changUserName?//B
    // 或者使用实例方法调用（方法名字不固定，但参数是必须的）
    func setMyChangeName(tempClose: @escaping changUserName)  {
        self.changName = tempClose
    }

//其他不使用
    func HttpTools(names: Int ,complated:(_ data:Any) -> ()) -> Int {
        let resInt = names + 10
        print("1：先执行函数")
        complated(data:resInt)
        return resInt
    }
    
    func ajaxTools(name:String ,complated:(_ runStr: String,_ isStop:Bool) -> (String,Bool)) -> String {
        let resStr = name + "覆水难收"
        let result = complated(resStr, true)
        print("回调之后\(result.0)-----\(result.1)")
        return resStr + " - 内部函数返回"
    }

    

    //MARK:- 按钮点击clicked
    @IBAction func btnCliked() {
        if (self.detailDelegate.isCompleted!()) {
            self.detailDelegate?.lastDo(data: "fuck")
        }
        changName?("很好的block")
    }

    
    @IBAction func matchBtnClicked() {
        var match = Float(txfEatRMB.text!)! + Float(txfTixtRMB.text!)! + Float(txfOtherRMB.text!)!
        match = Float(String.init(format: "%.2f", match))!
        
        let dx = numToCha.numChaMax(num: String.init(format: "%.2f", match))
//        let dx = numToCha.numChaMax(num: String.init(format: "%.2f", 123.0))
        labCountCha.text = dx
        
        labCountNum.text = String(match) + "元"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK- 其他other
    func changeToChaMAX(num:Float) {//挂尾闭包
        let changeToEng = [0:"零",1:"壹",2:"贰",3:"叁",4:"肆",5:"伍",6:"陆",7:"柒",8:"捌",9:"玖"]
        
        let numArr = [20,30,23,58,12345]
        let arr = numArr.map {
            (numshuzi) -> String in
            var n = numshuzi
            var str = ""
            while(n > 0) {
                str = changeToEng[n%10]! + str
                n /= 10
            }
            return str
        }
        
        print(arr)
    }

}
