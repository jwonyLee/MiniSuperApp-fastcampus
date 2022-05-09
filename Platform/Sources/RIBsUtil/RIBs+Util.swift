//
//  RIBs+Util.swift
//  
//
//  Created by nine2one on 2022/05/09.
//

import Foundation

public enum DismissButtonType {
    case back, close

    public var iconSystemName: String {
        switch self {
        case .back:
            return "chevron.backward"
        case .close:
            return "xmark"
        }
    }
}
