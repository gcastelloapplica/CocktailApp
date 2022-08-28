//
//  Functions.swift
//  CocktailApp
//
//  Created by Gaspar on 28/08/2022.
//

import UIKit

class Functions: NSObject {
    
    static func setPopUpButton() -> UIMenu {
        let optionClosure = { (action: UIAction) in
            print(action.title)
            // navigates to Details
        }
        var optionsArray = [UIAction]()
        [("by Name"),("by Ingredients")].forEach {
            let action = UIAction(title: $0, state: .off, handler: optionClosure)
            optionsArray.append(action)
        }
        optionsArray[0].state = .on
        let optionsMenu = UIMenu(title: "Search by: ", options: .displayInline, children: optionsArray)
        return optionsMenu
    }

}
