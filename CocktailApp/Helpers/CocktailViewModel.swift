//
//  DataHandler.swift
//  CocktailApp
//
//  Created by Gaspar on 27/08/2022.
//

import Foundation

class CocktailViewModel {
    static let shared = CocktailViewModel()
    
    var Cocktails: [CocktailModel]?

    func getRandom(_ completion: @escaping ()->Void)  {
        RequestHandler.shared.request(with: ApiInfo.cocktailsRandom) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}


