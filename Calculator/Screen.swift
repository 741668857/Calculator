//
//  Screen.swift
//  Calculator
//
//  Created by Civet on 2020/8/13.
//  Copyright © 2020 Civet. All rights reserved.
//

import UIKit

class Screen: UIView {
    
    var inputLabel:UILabel? //用户输入
    var historyLabel:UILabel? //历史信息
    var inputString:String? //输入字符串集合
    var isExtraPoint:Int = 0 //有多少个小数点 控制加了小数点的数字不再加小数点
    var result:Double? //结果
    
    init() {
        inputLabel = UILabel()
        historyLabel = UILabel()
        inputString = ""
        super.init(frame:CGRect.zero)
        self.installUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func installUI() {
        inputLabel?.textAlignment = .right
        historyLabel?.textAlignment = .right
        
        inputLabel?.font = UIFont.systemFont(ofSize: 34)
        historyLabel?.font = UIFont.systemFont(ofSize: 50)
        
        inputLabel?.textColor = .orange
        historyLabel?.textColor = .systemBlue
        //设置文字大小根据字数适配
        inputLabel?.adjustsFontSizeToFitWidth = true
        inputLabel?.minimumScaleFactor = 0.5
        
        historyLabel?.adjustsFontSizeToFitWidth = true
        historyLabel?.minimumScaleFactor = 0.5
        
        //设置文字截断方式
        inputLabel?.lineBreakMode = .byTruncatingHead
        historyLabel?.lineBreakMode = .byTruncatingHead
        
        inputLabel?.numberOfLines = 0
        historyLabel?.numberOfLines = 0
        
        self.addSubview(inputLabel!)
        self.addSubview(historyLabel!)
        
        inputLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.height.equalTo(inputLabel!.superview!.snp.height).multipliedBy(0.5).offset(-10)
        })
        
        historyLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(10)
            make.height.equalTo(inputLabel!.superview!.snp.height).multipliedBy(0.5).offset(-10)
        })
        
    }
    
    //处理输入接口
    func inputStr(content:String,view:UIViewController) {
        let numArray = ["0","1","2","3","4","5","6","7","8","9"] //数字数组
        let funcArray = ["^","/","*","+","-","%","."] //运算符数组
        
        switch content {
        case "AC": self.inputString = ""
                   isExtraPoint = 0
        case "Delete" : let popStr = self.inputString?.popLast()
                        if popStr == "." {
                        isExtraPoint -= 1
                        }
        case "=" : equalFunc(str: inputString!,view: view)
        case "%" : break
        default:
            if self.inputString?.first == "0" && numArray.contains(content) && !self.inputString!.contains(".") {
                self.inputString = ""
            }
            if inputString!.count > 0 {
                if numArray.contains(String((inputString?.last)!)) {
                    //最后一位是数字就随便加啦
                    if content == "." {
                       isExtraPoint += 1
                    }
                    print(isExtraPoint)
                    guard isExtraPoint < 2 else {
                        isExtraPoint -= 1
                        return
                    }
                    inputString?.append(content)
                } else  {
                    guard numArray.contains(content) else { //不是数字就只能添加数字
                        return
                    }
                    if inputString?.last != "." {
                        isExtraPoint = 0
                    }
                    inputString?.append(content)
                }
            } else
            {
                guard !funcArray.contains(content) else {
                    return
                }
                inputString?.append(content)
            }
            
        }
    }
   
    //等于号接口
    func equalFunc(str:String,view:UIViewController) {
        var tempArray:Array<Character> = []
        var numArray:Array<Double> = [] //存储数字
        var fuhaoArray = [Character]() //存储符号
        var newNumAry = [Double]() //存储新的没有乘除的数组
        let funcArray = ["^","/","*","+","-","%"]
        for char in str {
            if funcArray.contains(String(char)) {
                let num = Double(String(tempArray))
                guard num != nil else {
                    return
                }
                numArray.append(num!)
                fuhaoArray.append(char)
                tempArray = []
            } else {
             tempArray.append(char)
            }
        }
        guard Double(String(tempArray)) != nil else {
            let warning = UIAlertController(title: "경고 하 다", message: "유효한 수학 표현 식 을 입력 하 십시오!", preferredStyle: .alert)
            let sure = UIAlertAction(title: "숫자 추가 계속", style: .default, handler: nil)
            let deleteLast = UIAlertAction(title: "여분 연산 자 삭제", style: .default) { (action) in
                   let _ = self.inputString?.popLast()
                   self.inputLabel?.text = self.inputString
            }
            warning.addAction(sure)
            warning.addAction(deleteLast)
            view.present(warning, animated: true, completion: nil)
            return
        }
        
        numArray.append(Double(String(tempArray))!)
        
        print(numArray)
        print(fuhaoArray)
                
       //计算完乘除后的新数字和字符数组
        func newArray(i:Int,sum:Double) {
            let newNum:Int = Int((2*i+1)/2)
            var firstOldAry = [Double]()
            var lastOldAry = [Double]()
            print("newNum=\(newNum)")
            if newNum > 0 {
                for s in 0..<newNum {
                    firstOldAry.append(numArray[s])
                }
                newNumAry.append(contentsOf: firstOldAry)
                newNumAry.append(sum)
                for s in newNum+2..<numArray.count
                {
                    lastOldAry.append(numArray[s])
                }
                newNumAry.append(contentsOf: lastOldAry)
                numArray = newNumAry
                newNumAry = []
                print(numArray)
            } else {
                for s in 2..<numArray.count {
                    lastOldAry.append(numArray[s])
                }
                newNumAry.append(sum)
                newNumAry.append(contentsOf: lastOldAry)
                numArray = newNumAry
                newNumAry = []
            }
        }
    //乘方最优先
        func removePow() {
            for i in fuhaoArray.indices {
                if fuhaoArray[i] == "^" {
                var sum:Double = 0.0
                switch fuhaoArray[i] {
                case "^":
                    sum = pow(numArray[i], numArray[i+1])
                    fuhaoArray.remove(at: i)
                default:
                    break
                }
                newArray(i: i, sum: sum)
                break
            }
            }
        }
        
        //先计算乘除，把乘除全算完
        func removeExtra() {
            for i in fuhaoArray.indices {
                if fuhaoArray[i] == "*" || fuhaoArray[i] == "/" {
                    var sum:Double = 0.0
                    switch fuhaoArray[i] {
                    case "*":
                        sum = numArray[i] * numArray[i+1]
                        fuhaoArray.remove(at: i)
                    case "/" :
                        sum = numArray[i] / numArray[i+1]
                        fuhaoArray.remove(at: i)
                    default:break
                    }
                    newArray(i: i, sum: sum)
                    break
                }
            }
        }
        
        while fuhaoArray.contains("^") {
            removePow()
        }
        while fuhaoArray.contains("*") || fuhaoArray.contains("/") {
            removeExtra()
        }
        
        print(numArray)
        print(fuhaoArray)
      
        if fuhaoArray.count == 0 {
            result = numArray.last
        } else {
            var tempAry = [Double]()
            for i in fuhaoArray.indices{
                var sum:Double = 0
                switch fuhaoArray[i] {
                case "+":
                    if i > 0 {
                     sum = tempAry[i-1] + numArray[i+1]
                     tempAry.append(sum)
                    } else {
                     sum += numArray[i] + numArray[i+1]
                     tempAry.append(sum)
                    }
                case "-" :
                   if i > 0 {
                    sum = tempAry[i-1] - numArray[i+1]
                    tempAry.append(sum)
                   } else {
                    sum += numArray[i] - numArray[i+1]
                    tempAry.append(sum)
                   }
                default:
                    break
                }
            print(sum)
            print(tempAry)
            result = sum
            }
        }
        print(result ?? "nil")
        self.historyLabel?.text = String(Float(self.result!))
    }
    
}
