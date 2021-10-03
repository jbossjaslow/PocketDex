//
//  NavigationControllerExtensions.swift
//  NavigationControllerExtensions
//
//  Created by Josh Jaslow on 9/19/21.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
	override open func viewDidLoad() {
		super.viewDidLoad()
		interactivePopGestureRecognizer?.delegate = self
		
	}

	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return viewControllers.count > 1
	}
}
