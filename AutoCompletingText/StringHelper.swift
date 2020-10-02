//
//  StringHelper.swift
//  AutoCompletingText
//
//  Created by Ben Fitzgearl  on 9/30/20.
//

import Foundation

extension String {
  subscript(_ i: Int) -> String {
    let firstIndex = index(startIndex, offsetBy: i)
    let secondIndex = index(firstIndex, offsetBy: 1)
    return String(self[firstIndex..<secondIndex])
  }

  subscript (rng: Range<Int>) -> String {
    let start = index(startIndex, offsetBy: rng.lowerBound)
    let end = index(startIndex, offsetBy: rng.upperBound)
    return String(self[start ..< end])
  }

  subscript (rng: CountableClosedRange<Int>) -> String {
    let startIndex =  self.index(self.startIndex, offsetBy: rng.lowerBound)
    let endIndex = self.index(startIndex, offsetBy: rng.upperBound - rng.lowerBound)
    return String(self[startIndex...endIndex])
  }
}
