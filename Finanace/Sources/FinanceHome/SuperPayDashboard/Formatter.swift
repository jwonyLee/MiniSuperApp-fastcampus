//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by nine2one on 2022/04/26.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
