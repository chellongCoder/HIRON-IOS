//
//  ScrollableStackView.swift
//  Heron
//
//  Created by Longnn on 11/11/2022.
//

import Foundation
import UIKit

public class ScrollableStackView: UIView {

    // MARK: Properties
    private var didSetupConstraints = false

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.layoutMargins = .zero
        scrollView.contentSize = CGSize(width: 200, height: 50)

        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill

        return stackView
    }()

    // MARK: Life Cycle
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        setNeedsUpdateConstraints()
    }
}

// MARK: - ScrollableStackView - Actions
extension ScrollableStackView {
    /// Adds a view to the end of the arranged subviews array.
    ///
    /// - Parameter view: The view to be added to the array of views arranged by the stack.
    public func add(view: UIView) {
        stackView.addArrangedSubview(view)
    }

    /// Adds the provided view to the array of arranged subviews at the specified index.
    ///
    /// - Parameters:
    ///   - view: The view to be added to the array of views arranged by the stack.
    ///   - index: The index where the stack inserts the new view in its arranged subviews array.
    ///     This value must not be greater than the number of views currently in this array.
    ///     If the index is out of bounds, this method throws an `internalInconsistencyException` exception.
    public func insert(view: UIView, at index:  Int) {
        stackView.insertArrangedSubview(view, at: index)
    }

    /// Removes the provided view from the stack’s array of arranged subviews.
    ///
    /// - Parameter view: The view to be removed from the array of views arranged by the stack.
    public func remove(view: UIView) {
        stackView.removeArrangedSubview(view)
    }
}

// MARK: - ScrollableStackView - Configuration
extension ScrollableStackView {
    /// The distance in points between the adjacent edges of the stack view’s arranged views.
    ///
    /// This property defines a strict spacing between arranged views for the `UIStackView.Distribution.fillProportionally` distributions.
    /// It represents the minimum spacing for the `UIStackView.Distribution.equalSpacing` and `UIStackView.Distribution.equalCentering` distributions.
    /// Use negative values to allow overlap.
    /// The default value is `0.0`.
    public var spacing: CGFloat {
        get {
            return stackView.spacing
        }
        set {
            stackView.spacing = newValue
        }
    }

    /// The alignment of the arranged subviews perpendicular to the stack view’s axis.
    ///
    /// This property determines how the stack view lays out its arranged views perpendicularly to its axis.
    /// The default value is `UIStackView.Alignment.fill`.
    /// For a list of possible values, see `UIStackView.Alignment`.
    public var alignment: UIStackView.Alignment {
        get {
            return stackView.alignment
        }
        set {
            stackView.alignment = newValue
        }
    }

    /// The distribution of the arranged views along the stack view’s axis.
    ///
    /// This property determines how the stack view lays out its arranged views along its axis.
    /// The default value is `UIStackView.Distribution.fill`.
    /// For a list of possible values, see `UIStackView.Distribution`.
    public var distribution: UIStackView.Distribution {
        get {
            return stackView.distribution
        }
        set {
            stackView.distribution = newValue
        }
    }
 

    /// A Boolean value that controls whether the vertical scroll indicator is visible.
    ///
    /// The default value is `true`. The indicator is visible while tracking is underway and fades out after tracking.
    public var showsVerticalScrollIndicator: Bool {
        get {
            return scrollView.showsVerticalScrollIndicator
        }
        set {
            scrollView.showsVerticalScrollIndicator = newValue
        }
    }

    /// A Boolean value that controls whether the scroll view bounces past the edge of content and back again.
    ///
    /// If the value of this property is `true`, the scroll view bounces when it encounters a boundary of the content.
    /// Bouncing visually indicates that scrolling has reached an edge of the content.
    /// If the value is `false`, scrolling stops immediately at the content boundary without bouncing.
    /// The default value is `true`.
    public var bounces: Bool {
        get {
            return scrollView.bounces
        }
        set {
            scrollView.bounces = newValue
        }
    }
}
