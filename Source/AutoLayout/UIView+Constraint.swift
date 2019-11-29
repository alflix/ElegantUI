//
//  UIView+Constraint.swift
//  GGUI
//
//  Created by John on 2019/4/24.
//

import UIKit

private var topConstraintKey: Void?
private var bottomConstraintKey: Void?
private var leadingConstraintKey: Void?
private var trailingConstraintKey: Void?
private var widthConstraintKey: Void?
private var heightConstraintKey: Void?

public extension UIView {
    var topConstraint: NSLayoutConstraint? {
        get {
            guard let value = objc_getAssociatedObject(self, &topConstraintKey) as? NSLayoutConstraint else { return nil }
            return value
        }
        set {
            topConstraint?.isActive = false
            if let newValue = newValue {
                newValue.isActive = true
            }
            objc_setAssociatedObject(self, &topConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var bottomConstraint: NSLayoutConstraint? {
        get {
            guard let value = objc_getAssociatedObject(self, &bottomConstraintKey) as? NSLayoutConstraint else { return nil }
            return value
        }
        set {
            bottomConstraint?.isActive = false
            if let newValue = newValue {
                newValue.isActive = true
            }
            objc_setAssociatedObject(self, &bottomConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var leadingConstraint: NSLayoutConstraint? {
        get {
            guard let value = objc_getAssociatedObject(self, &leadingConstraintKey) as? NSLayoutConstraint else { return nil }
            return value
        }
        set {
            leadingConstraint?.isActive = false
            if let newValue = newValue {
                newValue.isActive = true
            }
            objc_setAssociatedObject(self, &leadingConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var trailingConstraint: NSLayoutConstraint? {
        get {
            guard let value = objc_getAssociatedObject(self, &trailingConstraintKey) as? NSLayoutConstraint else { return nil }
            return value
        }
        set {
            trailingConstraint?.isActive = false
            if let newValue = newValue {
                newValue.isActive = true
            }
            objc_setAssociatedObject(self, &trailingConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var widthConstraint: NSLayoutConstraint? {
        get {
            guard let value = objc_getAssociatedObject(self, &widthConstraintKey) as? NSLayoutConstraint else { return nil }
            return value
        }
        set {
            widthConstraint?.isActive = false
            if let newValue = newValue {
                newValue.isActive = true
            }
            objc_setAssociatedObject(self, &widthConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var heightConstraint: NSLayoutConstraint? {
        get {
            guard let value = objc_getAssociatedObject(self, &heightConstraintKey) as? NSLayoutConstraint else { return nil }
            return value
        }
        set {
            heightConstraint?.isActive = false
            if let newValue = newValue {
                newValue.isActive = true
            }
            objc_setAssociatedObject(self, &heightConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension UIView {
    func constraintToSuperview() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topConstraint = topAnchor.constraint(equalTo: superview.topAnchor)
        bottomConstraint = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        leadingConstraint = leadingAnchor.constraint(equalTo: superview.leadingAnchor)
        trailingConstraint = trailingAnchor.constraint(equalTo: superview.trailingAnchor)
    }

    func removeAllConstraints() {
        topConstraint = nil
        bottomConstraint = nil
        leadingConstraint = nil
        trailingConstraint = nil
        widthConstraint = nil
        heightConstraint = nil
    }

    func fillSuperview() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ]
        NSLayoutConstraint.activate(constraints)
    }

    func centerInSuperview() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func constraint(equalTo size: CGSize) {
        guard superview != nil else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @discardableResult
    func addConstraints(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil,
                        bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil,
                        centerY: NSLayoutYAxisAnchor? = nil, centerX: NSLayoutXAxisAnchor? = nil,
                        topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0,
                        rightConstant: CGFloat = 0, centerYConstant: CGFloat = 0, centerXConstant: CGFloat = 0,
                        widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {

        if self.superview == nil {
            return []
        }
        translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()
        if let top = top {
            let constraint = topAnchor.constraint(equalTo: top, constant: topConstant)
            constraint.identifier = "top"
            constraints.append(constraint)
        }

        if let left = left {
            let constraint = leftAnchor.constraint(equalTo: left, constant: leftConstant)
            constraint.identifier = "left"
            constraints.append(constraint)
        }

        if let bottom = bottom {
            let constraint = bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant)
            constraint.identifier = "bottom"
            constraints.append(constraint)
        }

        if let right = right {
            let constraint = rightAnchor.constraint(equalTo: right, constant: -rightConstant)
            constraint.identifier = "right"
            constraints.append(constraint)
        }

        if let centerY = centerY {
            let constraint = centerYAnchor.constraint(equalTo: centerY, constant: centerYConstant)
            constraint.identifier = "centerY"
            constraints.append(constraint)
        }

        if let centerX = centerX {
            let constraint = centerXAnchor.constraint(equalTo: centerX, constant: centerXConstant)
            constraint.identifier = "centerX"
            constraints.append(constraint)
        }

        if widthConstant > 0 {
            let constraint = widthAnchor.constraint(equalToConstant: widthConstant)
            constraint.identifier = "width"
            constraints.append(constraint)
        }

        if heightConstant > 0 {
            let constraint = heightAnchor.constraint(equalToConstant: heightConstant)
            constraint.identifier = "height"
            constraints.append(constraint)
        }

        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}
