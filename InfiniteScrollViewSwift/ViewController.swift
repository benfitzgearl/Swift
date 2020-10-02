//
//  ViewController.swift
//  InfiniteScrollViewSwift
//
//  Created by Ben Fitzgearl  on 7/3/20.
//  Copyright © 2020 Ben Fitzgearl . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let numbersScrollView = NumbersScrollView(scrollingDirection: .horizontal)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        numbersScrollView.infiniteScrollViewDelegate = self
        self.view.addSubview(numbersScrollView)
    }
    
    override func viewWillLayoutSubviews() {
        numbersScrollView.drawSubviews(self.view.frame)
    }
}

extension ViewController: InfiniteScrollViewDelegate {
    
    func infiniteScrollViewDidPageRight() {
        print("infiniteScrollViewDidPageRight")
    }
    
    func infiniteScrollViewDidPageLeft() {
        print("infiniteScrollViewDidPageLeft")
    }
}

