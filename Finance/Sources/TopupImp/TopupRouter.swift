//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by 이지원 on 2022/05/01.
//

import ModernRIBs

import AddPaymentMethod
import FinanceEntity
import RIBsUtil
import SuperUI
import Topup

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }

    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get set }
}

protocol TopupViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
    private var navigationControllable: NavigationControllerable?

    private let addPaymentMethodBuildable: AddPaymentMethodBuildable
    private var addPaymentRouting: Routing?

    private let enterAmountBuildable: EnterAmountBuildable
    private var enterAmountRouting: Routing?

    private let cardOnFileBuildable: CardOnFileBuildable
    private var cardOnFileRouting: Routing?

    init(
        interactor: TopupInteractable,
        viewController: ViewControllable,
        addPaymentMethodBuildable: AddPaymentMethodBuildable,
        enterAmountBuildable: EnterAmountBuildable,
        cardOnFileBuildable: CardOnFileBuildable
    ) {
        self.viewController = viewController
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.enterAmountBuildable = enterAmountBuildable
        self.cardOnFileBuildable = cardOnFileBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        if viewController.uiviewController.presentationController != nil, navigationControllable != nil {
            navigationControllable?.dismiss(completion: nil)
        }
    }

    func attachAddPaymentMethod(closeButtonType: DismissButtonType) {
        if addPaymentRouting != nil {
            return
        }

        let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: closeButtonType)

        if let navigationControllable = navigationControllable {
            navigationControllable.pushViewController(router.viewControllable, animated: true)
        } else {
            presentInsideNavigation(router.viewControllable)
        }

        attachChild(router)
        addPaymentRouting = router
    }

    func detachAddPaymentMethod() {
        guard let router = addPaymentRouting else {
          return
        }

        navigationControllable?.popViewController(animated: true)
        detachChild(router)
        self.addPaymentRouting = nil
    }

    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        let navigation = NavigationControllerable(root: viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        self.navigationControllable = navigation
        viewController.present(navigation, animated: true, completion: nil)
    }

    private func dismissPresentedNavigation(completion: (() -> Void)?) {
        if self.navigationControllable == nil {
            return
        }

        viewController.dismiss(completion: nil)
        self.navigationControllable = nil
    }

    func attachEnterAmount() {
        if enterAmountRouting != nil {
            return
        }

        let router = enterAmountBuildable.build(withListener: interactor)

        if let navigationControllable = navigationControllable {
            navigationControllable.setViewControllers([router.viewControllable])
            resetChildRouting()
        } else {
            presentInsideNavigation(router.viewControllable)
        }
        attachChild(router)
        enterAmountRouting = router
    }

    func detachEnterAmount() {
        guard let router = enterAmountRouting else {
          return
        }

        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        enterAmountRouting = nil
    }

    func attachCardOnFile(paymentMethods: [PaymentMethod]) {
        if cardOnFileRouting != nil {
            return
        }

        let router = cardOnFileBuildable.build(withListener: interactor, paymentMethods: paymentMethods)
        navigationControllable?.pushViewController(router.viewControllable, animated: true)
        attachChild(router)
        cardOnFileRouting = router
    }

    func detachCardOnFile() {
        guard let router = cardOnFileRouting else {
          return
        }

        navigationControllable?.popViewController(animated: true)
        detachChild(router)
        cardOnFileRouting = nil
    }

    func popToRoot() {
        navigationControllable?.popToRoot(animated: true)
        resetChildRouting()
    }

    // MARK: - Private

    private let viewController: ViewControllable

    private func resetChildRouting() {
        if let cardOnFileRouting = cardOnFileRouting {
            detachChild(cardOnFileRouting)
            self.cardOnFileRouting = nil
        }
        if let addPaymentRouting = addPaymentRouting {
            detachChild(addPaymentRouting)
            self.addPaymentRouting = nil
        }
    }

}
