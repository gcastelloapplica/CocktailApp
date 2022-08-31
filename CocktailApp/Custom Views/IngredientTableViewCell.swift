//
//  IngredientTableViewCell.swift
//  CocktailApp
//
//  Created by Gaspar on 28/08/2022.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var measureLabel: UILabel!
    
    func setupCell(_ data: Ingredient, _ isOnQuery: Bool) {
        if isOnQuery {
            ingredientLabel.textColor = .black}
        ingredientLabel.text = data.name
        measureLabel.text = data.measure
        wrapperView.setCornerRadius(CGFloat(10))
        
    }
    
}
