//
//  ResultsViewController.swift
//  CocktailLibrary
//
//  Created by Gaspar on 27/08/2022.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var cocktailImage: UIImageView!
    @IBOutlet weak var ingredientsTable: UITableView!
    
    typealias Ingredients = (String,Int)
    var ingredients: [Ingredients] { return [("soda", 1)]}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTable.delegate = self
        ingredientsTable.dataSource = self
    }
    
    
}
extension ResultsViewController: UITextViewDelegate {
    
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        return cell
    }
}
