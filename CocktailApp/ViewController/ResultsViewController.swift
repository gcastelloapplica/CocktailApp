//
//  ResultsViewController.swift
//  CocktailLibrary
//
//  Created by Gaspar on 27/08/2022.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var glassLabel: UILabel!
    @IBOutlet weak var cocktailImage: UIImageView!
    @IBOutlet weak var ingredientsView: UIView!
    @IBOutlet weak var ingredientsTable: UITableView!
    @IBOutlet weak var instructionsView: UIView!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    var cocktail: CocktailModel?
    var ingredients: [Ingredient?] { return cocktail?.ingredients.compactMap{$0} ?? [] }
    var query: String?
    var ingredient: Ingredient? { return cocktail?.ingredients.first{$0.name == query} }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTable.register(UINib(nibName: "IngredientTableViewCell", bundle: nil), forCellReuseIdentifier: "IngredientTableViewCell")
        ingredientsTable.delegate = self
        ingredientsTable.dataSource = self
        setupData()
        [cocktailImage, ingredientsView, instructionsView].forEach { $0?.setCornerRadius(CGFloat(10))
        }
    }
    
    func setupData() {
        guard let cocktail = cocktail else { return }
        drinkName.text = cocktail.name
        categoryLabel.text = cocktail.category
        glassLabel.text = cocktail.glass
        cocktailImage.loadFrom(URLAddress: cocktail.imageUrl ?? "")
        instructionsLabel.text = cocktail.instructions
    }
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        tableView.isHidden = ingredients.isEmpty
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableViewCell") as? IngredientTableViewCell,
        let ingredient = ingredients[indexPath.row]
        else { return UITableViewCell() }
        let isOnQuery = ingredient.name == self.ingredient?.name ?? ""
        cell.setupCell(ingredient, isOnQuery)
        return cell
    }
}
