//
//  NumbersScrollView.swift
//  InfiniteScrollViewSwift
//
//  Created by Ben Fitzgearl  on 7/3/20.
//  Copyright © 2020 Ben Fitzgearl . All rights reserved.
//

import UIKit

class NumbersScrollView: InfiniteScrollView {
    
    private var currentDisplayNumber = 0
    
    //MARK: Superclass overrides
    override func drawSubviews(_ frame: CGRect) {
        super.drawSubviews(frame)
        self.insert(leftView: self.numberView(currentDisplayNumber - 1), centerView: self.numberView(currentDisplayNumber), rightView: self.numberView(currentDisplayNumber + 1))
    }
    
    override func didPageRight() {
        currentDisplayNumber += 1
        self.insertNewRightSubview(self.numberView(currentDisplayNumber + 1))
        self.infiniteScrollViewDelegate?.infiniteScrollViewDidPageRight()
    }
    
    override func didPageLeft() {
        currentDisplayNumber -= 1
        self.insertNewLeftSubview(self.numberView(currentDisplayNumber - 1))
        self.infiniteScrollViewDelegate?.infiniteScrollViewDidPageLeft()
    }
    
    //MARK: View methods
    func numberView(_ numberToDisplay: Int) -> UIView {
        let numberView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        numberView.backgroundColor = UIColor.clear
        let numberLabel = UILabel(frame: CGRect(x: 0, y: numberView.frame.size.height / 4.0, width: numberView.frame.size.width, height: numberView.frame.size.height / 2.0))
        numberLabel.backgroundColor = UIColor.clear
        numberLabel.textColor = UIColor.red
        numberLabel.font = UIFont.boldSystemFont(ofSize: 120.0)
        numberLabel.textAlignment = .center
        numberLabel.text = "\(numberToDisplay)"
        numberView.addSubview(numberLabel)
        return numberView
    }
}
