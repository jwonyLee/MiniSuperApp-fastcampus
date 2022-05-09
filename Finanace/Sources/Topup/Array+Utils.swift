//
//  Array+Utils.swift
//  
//
//  Created by nine2one on 2022/05/09.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
