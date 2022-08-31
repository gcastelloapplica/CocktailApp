//
//  Functions.swift
//  CocktailApp
//
//  Created by Gaspar on 28/08/2022.
//

import UIKit

class Functions: NSObject {
    
    static func setPopUpButton(_ closure: @escaping()->Void) -> UIMenu {
        let optionClosure = { (action: UIAction) in
            print(action.title)
            closure()
        }
        var optionsArray = [UIAction]()
        for criteria in Criteria.allCases {
            let action = UIAction(title: criteria.rawValue, state: .off, handler: optionClosure)
            optionsArray.append(action)
        }
        optionsArray[0].state = .on
        let optionsMenu = UIMenu(title: "Search by: ", options: .displayInline, children: optionsArray)
        return optionsMenu
    }
    
    static func transformData(_ data: CocktailData) -> [CocktailModel] {
        var arr = [CocktailModel]()
        data.drinks.forEach {
            let category = $0.strCategory
            let id = $0.idDrink
            let name = $0.strDrink
            let imageUrl = $0.strDrinkThumb
            let glass = $0.strGlass
            let instructions = $0.strInstructions
            let filteredIngredients = Functions.filteredIngredients($0)
            arr.append(CocktailModel(category:category, glass: glass, id: id, imageUrl: imageUrl, instructions: instructions, ingredients: filteredIngredients, name: name))
        }
        return arr
    }
    
    static func filteredIngredients(_ drink: DetailedCocktailData) -> [Ingredient] {
        let arr = [Ingredient(name: drink.strIngredient1, measure: drink.strMeasure1),
                   Ingredient(name: drink.strIngredient2, measure: drink.strMeasure2),
                   Ingredient(name: drink.strIngredient3, measure: drink.strMeasure3),
                   Ingredient(name: drink.strIngredient4, measure: drink.strMeasure4),
                   Ingredient(name: drink.strIngredient5, measure: drink.strMeasure5)]
        let filtered = arr.filter{$0.name != nil && $0.measure != nil}
        return filtered
    }

}
