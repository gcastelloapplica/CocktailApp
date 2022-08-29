//
//  Cocktails.swift
//  CocktailApp
//
//  Created by Gaspar on 27/08/2022.
//

import Foundation
import UIKit

struct CocktailData: Codable {
    let drinks: [DetailedCocktailData]
}

struct DetailedCocktailData: Codable {
    let idDrink: String
    let strCategory: String?
    let strDrink: String
    let strDrinkThumb: String?
    let strGlass: String?
    let strInstructions: String?
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
}

struct Ingredient: Codable {
    let name: String?
    let measure: String?
}

struct CocktailModel {
    let category: String?
    let glass: String?
    let id: String
    let imageUrl: String?
    let instructions: String?
    let ingredients: [Ingredient]
    let name: String
}
