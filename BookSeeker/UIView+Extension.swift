//
//  UIView+Extension.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/16/25.
//

import UIKit

extension UIView {
    @discardableResult
    func top(
        equalTo target: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
        constant: CGFloat = 0.0
    ) -> UIView {
        guard let target = target ?? superview?.topAnchor else {
            return self
        }
        topAnchor.constraint(equalTo: target, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func bottom(
        equalTo target: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
        constant: CGFloat = 0.0
    ) -> UIView {
        guard let target = target ?? superview?.bottomAnchor else {
            return self
        }
        let constant = constant * -1
        bottomAnchor.constraint(equalTo: target, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func leading(
        equalTo target: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
        constant: CGFloat = 0.0
    ) -> UIView {
        guard let target = target ?? superview?.leadingAnchor else {
            return self
        }
        leadingAnchor.constraint(equalTo: target, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func trailing(
        equalTo target: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
        constant: CGFloat = 0.0
    ) -> UIView {
        guard let target = target ?? superview?.trailingAnchor else {
            return self
        }
        trailingAnchor.constraint(equalTo: target, constant: constant).isActive = true
        return self
    }
}
