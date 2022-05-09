//
//  AddPaymentMethodInfo.swift
//  MiniSuperApp
//
//  Created by 이지원 on 2022/04/27.
//

import Foundation

public struct AddPaymentMethodInfo {
    public let number: String
    public let cvc: String
    public let expiry: String

    public init(
        number: String,
        cvc: String,
        expiry: String
    ) {
        self.number = number
        self.cvc = cvc
        self.expiry = expiry
    }
}
