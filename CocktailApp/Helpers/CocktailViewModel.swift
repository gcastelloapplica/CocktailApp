//
//  DataHandler.swift
//  CocktailApp
//
//  Created by Gaspar on 27/08/2022.
//

import Foundation
import UIKit

class CocktailViewModel {
    static let shared = CocktailViewModel()
    
    var Cocktails: [CocktailModel]?
    
    func getCocktails(query: String, criteria: Criteria? = Criteria.Name, completion: @escaping() -> Void) {
        var url = criteria == Criteria.Ingredients ? ApiInfo.cocktailsByIngredients : ApiInfo.cocktailsByName
        url += query
        RequestHandler.shared.request(with: url) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func getRandom(_ completion: @escaping () -> Void)  {
        RequestHandler.shared.request(with: ApiInfo.cocktailsRandom) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}


