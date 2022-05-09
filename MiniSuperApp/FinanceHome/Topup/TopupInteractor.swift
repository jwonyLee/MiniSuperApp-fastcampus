//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by 이지원 on 2022/05/01.
//

import ModernRIBs

import AddPaymentMethod
import CombineUtil
import FinanceEntity
import FinanceRepository
import RIBsUtil
import SuperUI

protocol TopupRouting: Routing {
    func cleanupViews()

    func attachAddPaymentMethod(closeButtonType: DismissButtonType)
    func detachAddPaymentMethod()

    func attachEnterAmount()
    func detachEnterAmount()

    func attachCardOnFile(paymentMethods: [PaymentMethod])
    func detachCardOnFile()

    func popToRoot()
}

protocol TopupListener: AnyObject {
    func topupDidClose()
    func topupDidFinish()
}

protocol TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy

    weak var router: TopupRouting?
    weak var listener: TopupListener?

    private var isEnterAmountRoot: Bool = false

    private let dependency: TopupInteractorDependency
    private var paymentMethods: [PaymentMethod] {
        dependency.cardOnFileRepository.cardOnFile.value
    }

    init(dependency: TopupInteractorDependency) {
        self.dependency = dependency
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init()
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        if let card = dependency.cardOnFileRepository.cardOnFile.value.first {
            isEnterAmountRoot = true
            dependency.paymentMethodStream.send(card)
            // 금액 입력 화면
            router?.attachEnterAmount()
        } else {
            isEnterAmountRoot = false
            // 카드 추가 화면
            router?.attachAddPaymentMethod(closeButtonType: .close)
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
    }

    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
        if isEnterAmountRoot == false {
            listener?.topupDidClose()
        }
    }

    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
        dependency.paymentMethodStream.send(paymentMethod)

        if isEnterAmountRoot {
            router?.popToRoot()
        } else {
            isEnterAmountRoot = true
            router?.attachEnterAmount()
        }
    }

    func presentationControllerDidDismiss() {
        listener?.topupDidClose()
    }

    func enterAmountDidTapClose() {
        router?.detachEnterAmount()
        listener?.topupDidClose()
    }

    func enterAmountDidTapPaymentMethod() {
        router?.attachCardOnFile(paymentMethods: paymentMethods)
    }

    func enterAmountDidFinishTopup() {
        listener?.topupDidFinish()
    }

    func cardOnFileDidTapClose() {
        router?.detachCardOnFile()
    }

    func cardOnFileDidTapAddCard() {
        router?.attachAddPaymentMethod(closeButtonType: .back)
    }

    func cardOnFileDidSelect(at index: Int) {
        if let selected = paymentMethods[safe: index] {
            dependency.paymentMethodStream.send(selected)
        }
        router?.detachCardOnFile()
    }
}
