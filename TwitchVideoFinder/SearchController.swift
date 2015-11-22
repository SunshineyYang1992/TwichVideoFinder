//
//  SearchController.swift
//  TwitchVideoFinder
//
//  Created by Sunshine Yang on 11/21/15.
//  Copyright © 2015 SunshineYang. All rights reserved.
//

import UIKit


class SearchController: UIViewController, UITextFieldDelegate{
	
	@IBOutlet var searchTextField: UITextField!
		
	override func viewDidLoad() {
		super.viewDidLoad()
		searchTextField.alpha = 0
		
		UIView.animateWithDuration(1.5, delay: 0, options: .CurveLinear, animations: { () -> Void in
			self.searchTextField.alpha = 1
			}, completion: nil )
		
	}
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		textField.resignFirstResponder()
		
		return true
	}


}
