//
//  ViewController.swift
//  AutoCompletingText
//
//  Created by Ben Fitzgearl  on 9/30/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.testSearchTextField()
        //self.testAutoCompletingTextView()
    }
    
    func testSearchTextField() {
        
        let searchKey = "kSearchkey"
        let searchTextField = SearchTextField(frame: CGRect(x: 12, y: 64, width: self.view.frame.size.width - 24, height: 40))
        searchTextField.searchKey = searchKey
        UserDefaults.standard.setValue(["Testing", "Tea", "Tesseract", "Test for autocompleting search field"], forKey: searchKey)
        searchTextField.layer.borderColor = UIColor.gray.cgColor
        searchTextField.layer.borderWidth = 1.0
        self.view.addSubview(searchTextField)
    }
    
    func testAutoCompletingTextView() {
        
        let searchKey = "kSearchkey"
        let autoCompletingTextView = AutoCompletingTextView(frame: CGRect(x: 12, y: 64, width: self.view.frame.size.width - 24, height: 200))
        autoCompletingTextView.searchKey = searchKey
        UserDefaults.standard.setValue(["Testing", "Tea", "Tesseract", "Test for autocompleting text view"], forKey: searchKey)
        autoCompletingTextView.layer.borderColor = UIColor.gray.cgColor
        autoCompletingTextView.layer.borderWidth = 1.0
        self.view.addSubview(autoCompletingTextView)
    }
}

