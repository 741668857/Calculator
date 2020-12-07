//
//  FuncButton.swift
//  Calculator
//
//  Created by Civet on 2020/7/24.
//  Copyright © 2020 Civet. All rights reserved.
//

import UIKit

class FuncButton: UIButton {
    init() {
        super.init(frame:CGRect.zero)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red: 219/255.0, green: 219/255.0, blue: 219/255.0, alpha: 1).cgColor
        self.setTitleColor(.orange, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize:25)
        self.setTitleColor(.black, for: .highlighted)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }//这是NSCoding protocol定义的，遵守了NSCoding protocol的所有类必须继承。只是有的情况会隐式继承，而有的情况下需要显示实现。比如UIView系列的类、UIViewController系列的类。

}
