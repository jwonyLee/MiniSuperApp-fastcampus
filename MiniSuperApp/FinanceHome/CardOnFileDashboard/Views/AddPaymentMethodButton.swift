//
//  AddPaymentMethodButton.swift
//  MiniSuperApp
//
//  Created by nine2one on 2022/04/26.
//

import UIKit

final class AddPaymentMethodButton: UIControl {
    private let plusIcon: UIImageView = {
        let imageView: UIImageView = UIImageView(
            image: UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
            )
        )
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        addSubview(plusIcon)

        NSLayoutConstraint.activate([
            plusIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            plusIcon.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
