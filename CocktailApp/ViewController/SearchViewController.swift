//
//  SearchViewController.swift
//  CocktailLibrary
//
//  Created by Gaspar on 27/08/2022.
//

import UIKit
import Lottie

class SearchViewController: UIViewController {
    
    @IBOutlet weak var criteriaButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cocktailsTable: UITableView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    
    var cocktails: [CocktailModel] { return CocktailViewModel.shared.cocktails ?? [] }
    var searchTimer: Timer? { willSet { searchTimer?.invalidate() } }
    var observerId: String = UUID().uuidString
    var query = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.register(bidder: self)
        cocktailsTable.isHidden = true
        cocktailsTable.delegate = self
        cocktailsTable.dataSource = self
        cocktailsTable.register(UINib(nibName: "CocktailTableViewCell", bundle: nil), forCellReuseIdentifier: "CocktailTableViewCell")
        searchBar.delegate = self
        setupUI()
        setupAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetUI()
        setupAnimation()
    }
    
    private func setupAnimation() {
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func resetUI() {
        self.cocktailsTable.isHidden = true
        self.searchBar.text = ""
        self.alertLabel.isHidden = true
    }
    
    func setupUI() {
        [cocktailsTable, searchBar].forEach{ $0?.setCornerRadius() }
        criteriaButton.menu = Functions.setPopUpButton({self.resetUI()})
        cocktailsTable.isHidden = cocktails.isEmpty
        alertLabel.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchTimer?.invalidate()
        NetworkMonitor.shared.unregister(bidder: self)
    }
    
    @IBAction func goRandomAction(_ sender: UIButton) {
        CocktailViewModel.shared.getRandom {
            self.cocktailsTable.reloadData()
            self.cocktailsTable.isHidden = false
            self.searchBar.text = ""
            self.alertLabel.isHidden = true
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        searchTimer?.invalidate()
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //search debouncing for req traffic control
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] (timer) in
            guard let self = self,
                  let criteria = Criteria(rawValue: (self.criteriaButton.titleLabel?.text)!) else { return }
            guard searchBar.text?.trimAllSpace() != "", let query = searchBar.text else { return }
            self.query = query
            CocktailViewModel.shared.getCocktails(query: self.query, criteria: criteria) {
                timer.invalidate()
                self.cocktailsTable.isHidden = false
                self.cocktailsTable.reloadData()
                self.cocktailsTable.isHidden = self.cocktails.isEmpty
                self.alertLabel.isHidden = !self.cocktails.isEmpty
                
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
        cell.cleanCell()
        cell.setupCell(cocktails[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let criteria = Criteria(rawValue: criteriaButton.titleLabel?.text ?? "") else {
            return }
        tableView.isUserInteractionEnabled = false
        if criteria == Criteria.ingredients {
            let id = cocktails[indexPath.row].id
            CocktailViewModel.shared.getCocktails(query: id) {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
                vc.cocktail = self.cocktails.first
                vc.query = self.query
                self.navigationController?.pushViewController(vc, animated: true)
                self.cocktailsTable.reloadData()
                tableView.isUserInteractionEnabled = true
            }
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
            vc.cocktail = self.cocktails[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            tableView.isUserInteractionEnabled = true
        }
    }
    
}

extension SearchViewController: BidderProtocol {
    func update(isConnected: Bool) {
        if !isConnected {
            DispatchQueue.main.async {
                self.showAlertView(with: "Ups! Parece que no hay conexión a internet")
            }
        }
    }
}
