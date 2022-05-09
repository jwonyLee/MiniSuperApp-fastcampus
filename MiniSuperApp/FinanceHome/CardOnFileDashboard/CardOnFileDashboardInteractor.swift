//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by nine2one on 2022/04/26.
//

import ModernRIBs
import Combine

import FinanceRepository

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    var listener: CardOnFileDashboardPresentableListener? { get set }

    func update(with viewModels: [PaymentMethodViewModel])
}

// 부모 RIB 에게 이벤트가 발생했다는 것을 알리기 위할 때 사용한다.
protocol CardOnFileDashboardListener: AnyObject {
    func cardOnFileDashboardDidTapAddPaymentMethod()
}

protocol CardOnFileDashboardInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

    weak var router: CardOnFileDashboardRouting?
    weak var listener: CardOnFileDashboardListener?

    private let dependency: CardOnFileDashboardInteractorDependency

    private var cancellables: Set<AnyCancellable>

    init(
        presenter: CardOnFileDashboardPresentable,
        dependency: CardOnFileDashboardInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = []
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        dependency.cardOnFileRepository.cardOnFile.sink { methods in
            let viewModels = methods.prefix(5).map(PaymentMethodViewModel.init)
            self.presenter.update(with: viewModels)
        }
        .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()

        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    func didTapAddPaymentMethod() {
        listener?.cardOnFileDashboardDidTapAddPaymentMethod()
    }
}
