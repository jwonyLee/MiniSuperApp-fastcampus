//
//  AddPaymentMethodViewController.swift
//  MiniSuperApp
//
//  Created by 이지원 on 2022/04/27.
//

import ModernRIBs
import UIKit

protocol AddPaymentMethodPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AddPaymentMethodViewController: UIViewController, AddPaymentMethodPresentable, AddPaymentMethodViewControllable {

    weak var listener: AddPaymentMethodPresentableListener?
}
