//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by nine2one on 2022/05/04.
//

import Foundation

protocol SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
}

final class SuperPayRepositoryImp: SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }

    private let balanceSubject = CurrentValuePublisher<Double>(0)
}
