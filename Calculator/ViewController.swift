//
//  ViewController.swift
//  Calculator
//
//  Created by Civet on 2020/7/24.
//  Copyright © 2020 Civet. All rights reserved.
//

import UIKit

class ViewController: UIViewController,BoardButtonDelegate {
    
     var board:Board = Board()
     var screen:Screen = Screen()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(board)
        self.view.addSubview(screen)
        board.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        board.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(self.view.center.y)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        screen.snp.updateConstraints { (make) in
            make.bottom.equalTo(board.snp.top)
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
         self.view.layoutIfNeeded()
    }
    
    //代理方法
    func boardButtonClick(content: String) {
       screen.inputStr(content: content,view: self)
       screen.inputLabel?.text = screen.inputString
    }
    
}

