//
//  ViewController.swift
//  ScrollTextLabel
//
//  Created by L on 2019/3/18.
//  Copyright © 2019 L. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let scrollTextView = ScrollTextView()
    
    var isOriginText: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        scrollTextView.text = "12345,上山打老虎"
        scrollTextView.textColor = .red
        scrollTextView.backgroundColor = .yellow
        scrollTextView.frame = CGRect(x: 50, y: 150, width: 100, height: 50)
        view.addSubview(scrollTextView)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        scrollTextView.text = isOriginText  ? "11" : "12345,上山打老虎"
        isOriginText = !isOriginText
    }


}

