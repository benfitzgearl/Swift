//
//  SearchTextField.swift
//  AutoCompletingText
//
//  Created by Ben Fitzgearl  on 2/9/20.
//

import UIKit

@objc protocol SearchTextFieldDelegate: AnyObject {
    func searchTextFieldSearchButtonTapped()
    func searchTextFieldDidChangeText(_ currentText: String)
}

protocol AutoCompleteTextProtocol {
    
    func handleBackspace(currentText: String, replacementString: String) -> Bool
    func findAndRemoveAnySelectedText() -> Bool
    func appendSelectedText(_ appendingText: String?)
    func selectText(startIndex: Int, length: Int)
    func getSuggestionString(from inputString: String?) -> String?
    func sortSuggestions(_ suggestions: [String]) -> [String]
}

class SearchTextField: UITextField, UITextFieldDelegate, AutoCompleteTextProtocol {
    
    @objc weak var searchTextFieldDelegate: SearchTextFieldDelegate?
    @objc public var searchKey: String?
    private var autoCompleteEnabled: Bool {
        get {
            //return value for setting, if applicable.
            return true
        }
        set {}
    }
    private var useSuggestionText = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.autocorrectionType = .no
        self.returnKeyType = .search
        self.keyboardAppearance = .alert
        self.keyboardType = .default
        self.clearButtonMode = .always
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.clearButtonMode = .always
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string != "\n" else {
            return true
        }
        guard let curText = self.text else {
            return true
        }
        guard string.count > 0 else {
            return handleBackspace(currentText: curText, replacementString: string)
        }
        findAndRemoveAnySelectedText()
        if let curText = self.text, curText.count >= 2, useSuggestionText == true {
           if let suggestion = getSuggestionString(from: curText + string) {
                self.appendSelectedText(suggestion)
                return false
            }
        }
        searchTextFieldDelegate?.searchTextFieldDidChangeText(self.text != nil ? self.text! + string : "")
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        useSuggestionText = autoCompleteEnabled
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextFieldDelegate?.searchTextFieldSearchButtonTapped()
        self.resignFirstResponder()
        return true
    }
    
    internal func handleBackspace(currentText: String, replacementString: String) -> Bool {
        let hasSelection = findAndRemoveAnySelectedText()
        if currentText.count > 1 {
            //May want ot disable if the user backspaces
            //useSuggestionText = false
        } else {
            useSuggestionText = autoCompleteEnabled
        }
        if hasSelection == true {
            return false
        }
        return true
    }
    
    @discardableResult
    internal func findAndRemoveAnySelectedText() -> Bool {
        guard let curText = self.text, let selectedRange = self.selectedTextRange, selectedRange.start != selectedRange.end else {
            return false
        }
        let selectionStart = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
        let selectionEnd = self.offset(from: self.beginningOfDocument, to: selectedRange.end)
        self.text = String(curText[0..<selectionStart]) + String(curText[selectionEnd..<curText.count])
        return true
    }
    
    internal func appendSelectedText(_ appendingText: String?) {
        guard let appendingText = appendingText else {
            return
        }
        let curText = self.text ?? ""
        let replacementText = curText + appendingText
        self.text = replacementText
        selectText(startIndex: curText.count + 1, length: appendingText.count - 1)
    }
    
    internal func selectText(startIndex: Int, length: Int) {
        guard let textCount = self.text?.count, textCount >= startIndex + length else {
            return
        }
        let start = self.position(from: self.beginningOfDocument, offset: startIndex)!
        let end = self.position(from: start, offset: length)!
        let textRange = self.textRange(from: start, to: end)
        self.selectedTextRange = textRange
    }
    
    internal func getSuggestionString(from inputString: String?) -> String? {
        guard let inputString = inputString, let usedSearchKey = searchKey, var suggestionsArray = UserDefaults.standard.object(forKey: usedSearchKey) as? Array<String> else {
            return nil
        }
        suggestionsArray = sortSuggestions(suggestionsArray)
        var appendingString: String?
        for searchString in suggestionsArray {
            if searchString.count > inputString.count {
                if searchString[0..<inputString.count].lowercased() == inputString.lowercased() {
                    appendingString = searchString[inputString.count - 1..<searchString.count]
                    break
                }
            }
        }
        return appendingString
    }
    
    internal func sortSuggestions(_ suggestions: [String]) -> [String] {
        guard suggestions.count > 1 else {
            return suggestions
        }
        var countsDict = [String: Int]()
        for word in suggestions {
            countsDict[word] = word.count
        }
        let result = countsDict.sorted { $0.value < $1.value }.map { $0.key }
        return result
    }
}
