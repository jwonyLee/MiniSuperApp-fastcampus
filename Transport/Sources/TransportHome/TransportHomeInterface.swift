//
//  TransportHomeInterface.swift
//  
//
//  Created by nine2one on 2022/05/09.
//

import Foundation
import ModernRIBs

public protocol TransportHomeBuildable: Buildable {
    func build(withListener listener: TransportHomeListener) -> ViewableRouting
}


public protocol TransportHomeListener: AnyObject {
    func transportHomeDidTapClose()
}
