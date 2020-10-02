//
//  InfiniteScrollView.swift
//  InfiniteScrollViewSwift
//
//  Created by Ben Fitzgearl  on 7/3/20.
//  Copyright © 2020 Ben Fitzgearl . All rights reserved.
//

import UIKit

private let kSupportedNumberOfSubviews: Int = 3
private let kLeftViewTag: Int = 100
private let kCenterViewTag: Int = 101
private let kRightViewTag: Int = 102

enum ScrollViewScrollDirection {
    case horizontal
    case vertical
}

protocol InfiniteScrollViewDelegate: AnyObject {
    func infiniteScrollViewDidPageRight()
    func infiniteScrollViewDidPageLeft()
}

//Adding empty method implementations here so that they're not required when we implement the protocol elsewhere.
extension InfiniteScrollViewDelegate {
    func infiniteScrollViewDidPageRight() {}
    func infiniteScrollViewDidPageLeft() {}
}

class InfiniteScrollView: UIScrollView {

    weak var infiniteScrollViewDelegate: InfiniteScrollViewDelegate?
    private var scrollDirection: ScrollViewScrollDirection = .horizontal
    
    required init(scrollingDirection: ScrollViewScrollDirection) {
        super.init(frame: UIScreen.main.bounds);
        scrollDirection = scrollingDirection;
        self.delegate = self;
        self.isPagingEnabled = true;
        self.showsHorizontalScrollIndicator = false;
        self.showsVerticalScrollIndicator = false;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Subview management
    func drawSubviews(_ frame: CGRect) {
        self.frame = frame
        if scrollDirection == .vertical {
            self.contentSize = CGSize(width: frame.size.width, height: CGFloat(kSupportedNumberOfSubviews) * frame.size.height)
        } else {
            self.contentSize = CGSize(width: CGFloat(kSupportedNumberOfSubviews) * frame.size.width, height: frame.size.height)
        }
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        self.offsetToCenter()
    }
    
    public func insert(leftView: UIView, centerView: UIView, rightView: UIView) {
        self.insert(leftSubview: leftView)
        self.insert(centerSubview: centerView)
        self.insert(rightSubview: rightView)
    }
    
    private func insert(leftSubview: UIView) {
        leftSubview.frame = self.leftSubviewFrame()
        leftSubview.tag = kLeftViewTag
        self.addSubview(leftSubview)
    }
    
    private func insert(centerSubview: UIView) {
        centerSubview.frame = self.centerSubviewFrame()
        centerSubview.tag = kCenterViewTag
        self.addSubview(centerSubview)
    }
    
    private func insert(rightSubview: UIView) {
        rightSubview.frame = self.rightSubviewFrame()
        rightSubview.tag = kRightViewTag
        self.addSubview(rightSubview)
    }
    
    public func insertNewRightSubview(_ newRightSubview: UIView) {
        if let curLeftView = self.viewWithTag(kLeftViewTag) {
            curLeftView.removeFromSuperview()
        }
        if let curCenterView = self.viewWithTag(kCenterViewTag) {
            curCenterView.frame = self.leftSubviewFrame()
            curCenterView.tag = kLeftViewTag
        }
        if let curRightView = self.viewWithTag(kRightViewTag) {
            curRightView.frame = self.centerSubviewFrame()
            curRightView.tag = kCenterViewTag
        }
        newRightSubview.frame = self.rightSubviewFrame()
        newRightSubview.tag = kRightViewTag
        self.addSubview(newRightSubview)
        self.offsetToCenter()
    }
    
    public func insertNewLeftSubview(_ newLeftSubview: UIView) {
        if let curRightView = self.viewWithTag(kRightViewTag) {
            curRightView.removeFromSuperview()
        }
        if let curCenterView = self.viewWithTag(kCenterViewTag) {
            curCenterView.frame = self.rightSubviewFrame()
            curCenterView.tag = kRightViewTag
        }
        if let curLeftView = self.viewWithTag(kLeftViewTag) {
            curLeftView.frame = self.centerSubviewFrame()
            curLeftView.tag = kCenterViewTag
        }
        newLeftSubview.frame = self.leftSubviewFrame()
        newLeftSubview.tag = kLeftViewTag
        self.addSubview(newLeftSubview)
        self.offsetToCenter()
    }
    
    //MARK: View geometry
    private func offsetToCenter() {
        if scrollDirection == .horizontal {
            self.setContentOffset(CGPoint(x: self.contentSize.width / CGFloat(kSupportedNumberOfSubviews), y: 0), animated: false)
        } else {
            self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height / CGFloat(kSupportedNumberOfSubviews)), animated: false)
        }
    }
    
    private func subviewWidth() -> CGFloat {
        return scrollDirection == .horizontal ? self.contentSize.width / CGFloat(kSupportedNumberOfSubviews) : self.contentSize.width
    }
    
    private func leftSubviewFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: self.subviewWidth(), height: self.frame.size.height)
    }
    
    private func centerSubviewFrame() -> CGRect {
        if scrollDirection == .vertical {
            return CGRect(x: 0, y: self.contentSize.height / CGFloat(kSupportedNumberOfSubviews), width: self.subviewWidth(), height: self.frame.size.height)
        }
        return CGRect(x: self.contentSize.width / CGFloat(kSupportedNumberOfSubviews), y: 0, width: self.subviewWidth(), height: self.frame.size.height)
    }
    
    private func rightSubviewFrame() -> CGRect {
        if scrollDirection == .vertical {
            return CGRect(x: 0, y: 2 * self.contentSize.height / CGFloat(kSupportedNumberOfSubviews), width: self.subviewWidth(), height: self.frame.size.height)
        }
        return CGRect(x: 2 * self.contentSize.width / CGFloat(kSupportedNumberOfSubviews), y: 0, width: self.subviewWidth(), height: self.frame.size.height)
    }
    
    //MARK: UIScrollView delegate helper methods
    public func didPageRight() {}
    
    public func didPageLeft() {}
    
}

extension InfiniteScrollView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollDirection {
        case .vertical:
            if Int(scrollView.contentOffset.y) > Int(scrollView.contentSize.height / CGFloat(kSupportedNumberOfSubviews)) {
                self.didPageRight()
            } else if Int(scrollView.contentOffset.y) < Int(scrollView.contentSize.height / CGFloat(kSupportedNumberOfSubviews)) {
                self.didPageLeft()
            }
        case .horizontal:
            fallthrough
        default:
            if Int(scrollView.contentOffset.x) > Int(scrollView.contentSize.width / CGFloat(kSupportedNumberOfSubviews)) {
                self.didPageRight()
            } else if Int(scrollView.contentOffset.x) < Int(scrollView.contentSize.width / CGFloat(kSupportedNumberOfSubviews)) {
               self.didPageLeft()
            }
        }
    }
}
