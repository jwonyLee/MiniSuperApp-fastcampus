import ModernRIBs

protocol FinanceHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency, TopupDependency {
    var cardOnFileRepository: CardOnFileRepository
    var superPayRepository: SuperPayRepository
    var topupBaseViewController: ViewControllable

    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }

    init(
        dependency: FinanceHomeDependency,
        cardOnFileRepository: CardOnFileRepository,
        superPayRepository: SuperPayRepository,
        topupBaseViewController: ViewControllable
    ) {
        self.cardOnFileRepository = cardOnFileRepository
        self.superPayRepository = superPayRepository
        self.topupBaseViewController = topupBaseViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {

    override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
        let viewController = FinanceHomeViewController()

        let component = FinanceHomeComponent(
            dependency: dependency,
            cardOnFileRepository: CardOnFileRepositoryImp(),
            superPayRepository: SuperPayRepositoryImp(),
            topupBaseViewController: viewController
        )

        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener

        let superPayDasyboardBuilder: SuperPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
        let cardOnFileDashboardBuilder: CardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        let addPaymentMethodBuilder: AddPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        let topupBuilder: TopupBuilder = TopupBuilder(dependency: component)

        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDasyboardBuildable: superPayDasyboardBuilder,
            cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
            addPaymentMethodBuildable: addPaymentMethodBuilder,
            topupBuildable: topupBuilder
        )
    }
}
