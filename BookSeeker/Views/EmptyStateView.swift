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

    var iconImageView: UIImageView = .init()
    var descriptionLabel: UILabel = .init()

    func setMessage(_ message: String?) {
        descriptionLabel.text =
            """
                    \(defaultMessage)
                    \(message ?? "")
            """
    }

    func set(to superView: UIView) {
        superView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
        addSubview(iconImageView)
        iconImageView.image = UIImage(systemName: errorIconImageName)
        iconImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            .isActive = true
        addSubview(descriptionLabel)
        descriptionLabel
            .leading().trailing().top(equalTo: iconImageView.bottomAnchor, constant: 20)
        descriptionLabel.text = "\(defaultMessage)"
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
