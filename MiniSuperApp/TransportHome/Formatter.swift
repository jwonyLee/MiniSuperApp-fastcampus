//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by nine2one on 2022/05/09.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
