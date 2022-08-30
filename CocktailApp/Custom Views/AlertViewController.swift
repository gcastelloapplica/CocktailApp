//
//  AlertViewController.swift
//  CocktailApp
//
//  Created by Gaspar on 28/08/2022.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var atentionLabel: UILabel!
    
    var text: String?
    var atentionText: String?
    var accept: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        containerView.layer.cornerRadius = 10
    }
    
    func setupView() {
        self.textLabel.text = text
        self.atentionLabel?.text = atentionText
    }

    @IBAction func acceptButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: accept)
    }
}
