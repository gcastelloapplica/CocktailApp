//
//  SessionHandler.swift
//  CocktailApp
//
//  Created by Gaspar on 27/08/2022.
//

import Foundation
import UIKit

enum EncType {
    case application_json
    case application_x_www_form_urlencoded
    case application_pdf
    case multiPartForm
}

struct ApiInfo {
    static let baseURL: String = "https://www.thecocktaildb.com/"
    static let cocktailsByName: String = "\(baseURL)api/json/v1/1/search.php?s=" // complete query with name
    static let cocktailsByIngredients: String = "\(baseURL)api/json/v1/1/filter.php?i=" // complete query with ingredient
    static let cocktailsRandom: String = "\(baseURL)api/json/v1/1/random.php"
}

class RequestHandler {
    static let shared = RequestHandler()
    
    func request(with urlString: String, completion: @escaping()->Void ) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    debugPrint(error as Any)
                    return
                }
                if let response = response as? HTTPURLResponse {
                    print("---> Response code \(response.statusCode)")
                }
                if let data = data {
                    if let parsedData = self.parseJSON(data) {
                        CocktailViewModel.shared.Cocktails = parsedData
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ cocktailData: Data) -> [CocktailModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CocktailData.self, from: cocktailData)
            return transformData(decodedData)
        } catch {
            debugPrint(error)
            return nil
        }
    }
    
    func transformData(_ data: CocktailData) -> [CocktailModel] {
        var arr = [CocktailModel]()
        data.drinks.forEach {
            let id = $0.idDrink
            let name = $0.strDrink
            let imageUrl = $0.strDrinkThumb
            let glass = $0.strGlass
            let instructions = $0.strInstructions
            let ingredients = [Ingredient(name: $0.strIngredient1, measure: $0.strMeasure1),
                               Ingredient(name: $0.strIngredient2, measure: $0.strMeasure2),
                               Ingredient(name: $0.strIngredient3, measure: $0.strMeasure3),
                               Ingredient(name: $0.strIngredient4, measure: $0.strMeasure4),
                               Ingredient(name: $0.strIngredient5, measure: $0.strMeasure5)]
            
            arr.append(CocktailModel(glass: glass, id: id, imageUrl: imageUrl, instructions: instructions, ingredients: ingredients, name: name))
        }
        
        return arr
    }
}
