//
//  SearchViewController.swift
//  CocktailLibrary
//
//  Created by Gaspar on 27/08/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var cocktailsTable: UITableView!
    @IBOutlet weak var searchByMenu: UIMenu!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchByButton: UIButton!
    
    var cocktails: [CocktailModel] { return CocktailViewModel.shared.Cocktails ?? [] }
    var searchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cocktailsTable.delegate = self
        cocktailsTable.dataSource = self
        cocktailsTable.register(UINib(nibName: "CocktailTableViewCell", bundle: nil), forCellReuseIdentifier: "CocktailTableViewCell")
        searchBar.delegate = self
        [cocktailsTable, searchBar].forEach{ $0?.setCornerRadius() }
        searchByButton.menu = Functions.setPopUpButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchTimer?.invalidate()
    }

    @IBAction func searchByAction(_ sender: UIButton) {
        
    }
    
    @IBAction func goRandomAction(_ sender: UIButton) {
        CocktailViewModel.shared.getRandom {
            self.cocktailsTable.reloadData()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        searchTimer?.invalidate()
        //validaciones de caracteres,etc
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //search debouncing for req traffic control
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] (timer) in
            guard let self = self else { return }
            CocktailViewModel.shared.getRandom {
                timer.invalidate()
                self.cocktailsTable.reloadData()
            }
        })
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cocktails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailTableViewCell") as? CocktailTableViewCell else { return UITableViewCell() }
        cell.setupCell(cocktails[indexPath.row])
        return cell
    }
    
}
