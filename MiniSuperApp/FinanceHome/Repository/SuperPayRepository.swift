//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by nine2one on 2022/05/04.
//

import Combine
import Foundation

protocol SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error>
}

final class SuperPayRepositoryImp: SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }

    private let balanceSubject = CurrentValuePublisher<Double>(0)

    func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            self?.backgroundQueue.async {
                Thread.sleep(forTimeInterval: 2)
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }

    private let backgroundQueue = DispatchQueue(label: "topup.repository.queue")
}
