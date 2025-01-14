import ModernRIBs

import CombineUtil
import FinanceRepository
import TransportHome
import Topup

public protocol TransportHomeDependency: Dependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var topupBuildable: TopupBuildable { get }
}

final class TransportHomeComponent: Component<TransportHomeDependency>, TransportHomeInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    var superPayBalance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    var topupBuildable: TopupBuildable { dependency.topupBuildable }
}

// MARK: - Builder

public final class TransportHomeBuilder: Builder<TransportHomeDependency>, TransportHomeBuildable {
    public override init(dependency: TransportHomeDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: TransportHomeListener) -> ViewableRouting {
        let viewController = TransportHomeViewController()

        let component = TransportHomeComponent(dependency: dependency)

        let interactor = TransportHomeInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener

        return TransportHomeRouter(
            interactor: interactor,
            viewController: viewController,
            topupBuildable: component.topupBuildable
        )
    }
}
