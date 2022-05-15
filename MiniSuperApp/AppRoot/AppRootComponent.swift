//
//  AppRootComponent.swift
//  MiniSuperApp
//
//  Created by nine2one on 2022/05/09.
//

import Foundation
import ModernRIBs

import AddPaymentMethod
import AddPaymentMethodImp
import AppHome
import FinanceHome
import ProfileHome
import FinanceRepository
import TransportHome
import TransportHomeImp
import Topup
import TopupImp
import Network
import NetworkImp

final class AppRootComponent:
    Component<AppRootDependency>,
    AppHomeDependency,
    FinanceHomeDependency,
    ProfileHomeDependency,
    TransportHomeDependency,
    TopupDependency,
    AddPaymentMethodDependency
{
    var topupBaseViewController: ViewControllable { rootViewController.topViewControllerable }
    
    var cardOnFileRepository: CardOnFileRepository
    var superPayRepository: SuperPayRepository
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        return TransportHomeBuilder(dependency: self)
    }()
    lazy var topupBuildable: TopupBuildable = {
        return TopupBuilder(dependency: self)
    }()
    lazy var addPaymentMethodBuildable: AddPaymentMethodBuildable = {
        return AddPaymentMethodBuilder(dependency: self)
    }()
    
    
    private let rootViewController: ViewControllable
    
    init(
        dependency: AppRootDependency,
        rootViewController: ViewControllable
    ) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [SuperAppURLProtocol.self]

        setupURLProtocol()

        let network = NetworkImp(session: URLSession(configuration: config))

        self.cardOnFileRepository = CardOnFileRepositoryImp(network: network, baseURL: BaseURL().financeBaseURL)
        self.cardOnFileRepository.fetch()
        self.superPayRepository = SuperPayRepositoryImp(network: network, baseURL: BaseURL().financeBaseURL)
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
}
