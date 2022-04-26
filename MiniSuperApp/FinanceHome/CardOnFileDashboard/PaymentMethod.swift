//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by nine2one on 2022/04/26.
//

import Foundation

struct PaymentMethod: Decodable {
    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}
