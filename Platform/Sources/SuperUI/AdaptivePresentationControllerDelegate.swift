//
//  AdaptivePresentationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by 이지원 on 2022/04/27.
//

import UIKit

public protocol AdaptivePresentationControllerDelegate: AnyObject {
    func presentationControllerDidDismiss()
}

public final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
    public weak var delegate: AdaptivePresentationControllerDelegate?

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.presentationControllerDidDismiss()
    }
}
