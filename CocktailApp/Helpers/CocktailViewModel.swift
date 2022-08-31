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
    
    var cocktails: [CocktailModel]?
    var cocktailById: CocktailModel?
    
    func getCocktails(query: String, criteria: Criteria? = nil, completion: @escaping() -> Void) {
        var url = ""
        switch criteria {
            case .name:
                url = ApiInfo.cocktailsByName
            case .ingredients:
                url = ApiInfo.cocktailsByIngredients
            default:
                url = ApiInfo.cocktailById
        }
        
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


