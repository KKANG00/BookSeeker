//
//  EmptyStateUIView.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/19/25.
//

import UIKit

enum EmptyStateType {
    case searchResultFail
    case detailInfoFail
}

class EmptyStateView: UIView {
    let type: EmptyStateType
    var defaultMessage: String {
        switch type {
        case .searchResultFail:
            return "검색 결과를 불러올 수 없습니다."
        case .detailInfoFail:
            return "상세 정보를 불러올 수 없습니다."
        }
    }

    private let errorIconImageName: String = "exclamationmark.triangle.fill"

    init(type: EmptyStateType) {
        self.type = type
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var stackView: UIStackView = .init()

    var iconImageView: UIImageView = .init()
    var defaultLabel: UILabel = .init()
    var descriptionLabel: UILabel = .init()

    func setMessage(_ message: String?) {
        defaultLabel.text = defaultMessage
        descriptionLabel.text = message ?? ""
    }

    func set(to superView: UIView) {
        superView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        defaultLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        top().bottom().leading().trailing()

        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leading().trailing()
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(defaultLabel)
        stackView.addArrangedSubview(descriptionLabel)

        iconImageView.image = UIImage(systemName: errorIconImageName)
        iconImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        defaultLabel.text = "\(defaultMessage)"
        defaultLabel.numberOfLines = 2
        defaultLabel.textAlignment = .center
        descriptionLabel.text = ""
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center

        isHidden = true
    }

    func hide() {
        isHidden = true
    }

    func show() {
        isHidden = false
    }
}
