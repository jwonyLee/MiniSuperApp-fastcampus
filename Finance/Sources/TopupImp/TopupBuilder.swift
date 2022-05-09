//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by 이지원 on 2022/05/01.
//

import ModernRIBs

import AddPaymentMethod
import CombineUtil
import FinanceEntity
import FinanceRepository
import Topup

public protocol TopupDependency: Dependency {
    var topupBaseViewController: ViewControllable { get }
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, EnterAmountDependency, CardOnFileDependency {
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { paymentMethodStream }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { dependency.addPaymentMethodBuildable }

    fileprivate var topupBaseViewController: ViewControllable {
        return dependency.topupBaseViewController
    }

    let paymentMethodStream: CurrentValuePublisher<PaymentMethod>

    init(
        dependency: TopupDependency,
        paymentMethodStream: CurrentValuePublisher<PaymentMethod>
    ) {
        self.paymentMethodStream = paymentMethodStream
        super.init(dependency: dependency)
    }
}

// MARK: - Builder
public final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    public override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: TopupListener) -> Routing {
        let paymentMethodStream = CurrentValuePublisher(
            PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false)
        )

        let component = TopupComponent(dependency: dependency, paymentMethodStream: paymentMethodStream)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener

        let enterAmountBuilder = EnterAmountBuilder(dependency: component)
        let cardOnFileBuilder = CardOnFileBuilder(dependency: component)

        return TopupRouter(
            interactor: interactor,
            viewController: component.topupBaseViewController,
            addPaymentMethodBuildable: component.addPaymentMethodBuildable,
            enterAmountBuildable: enterAmountBuilder,
            cardOnFileBuildable: cardOnFileBuilder
        )
    }
}
