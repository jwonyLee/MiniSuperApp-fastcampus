//
//  UIViewController+Utils.swift
//  MiniSuperApp
//
//  Created by 이지원 on 2022/05/02.
//

import UIKit

import RIBsUtil

extension UIViewController {
    public func setupNavigationItem(with buttonType: DismissButtonType, target: Any?, action: Selector?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: buttonType.iconSystemName,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
            ),
            style: .plain,
            target: target,
            action: action
        )
    }
}
