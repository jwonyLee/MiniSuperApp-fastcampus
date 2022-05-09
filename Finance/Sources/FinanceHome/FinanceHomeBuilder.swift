import ModernRIBs

import AddPaymentMethod
import CombineUtil
import FinanceRepository
import Topup

public protocol FinanceHomeDependency: Dependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var topupBuildable: TopupBuildable { get }
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency {
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    var topupBuildable: TopupBuildable { dependency.topupBuildable }
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { dependency.addPaymentMethodBuildable }

    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
}

// MARK: - Builder

public protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> ViewableRouting
}

public final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
    public override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: FinanceHomeListener) -> ViewableRouting {
        let viewController = FinanceHomeViewController()

        let component = FinanceHomeComponent(dependency: dependency)

        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener

        let superPayDasyboardBuilder: SuperPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
        let cardOnFileDashboardBuilder: CardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)

        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDasyboardBuildable: superPayDasyboardBuilder,
            cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
            addPaymentMethodBuildable: component.addPaymentMethodBuildable,
            topupBuildable: component.topupBuildable
        )
    }
}
