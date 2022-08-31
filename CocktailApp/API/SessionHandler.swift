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
    static let cocktailById: String = "\(baseURL)api/json/v1/1/lookup.php?i="
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
                        CocktailViewModel.shared.cocktails = parsedData
                        DispatchQueue.main.async {
                            completion()
                        }
                    } else {
                        CocktailViewModel.shared.cocktails?.removeAll()
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
            return Functions.transformData(decodedData)
        } catch {
            debugPrint(error)
            return nil
        }
    }
}
