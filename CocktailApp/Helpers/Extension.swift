//
//  Extension.swift
//  CocktailApp
//
//  Created by Gaspar on 28/08/2022.
//

import Foundation
import UIKit

extension UIView {
    func setCornerRadius() {
        self.layer.cornerRadius = 5
    }
    func setCornerRadius(_ rad: CGFloat) {
        self.layer.cornerRadius = rad
    }
    
    func setCircular() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}

extension UIViewController {
    
    func showAlertView(with text: String){
        let vc = AlertViewController(nibName: "AlertViewController", bundle: nil)
        vc.text = text
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}

extension String {
    func trimAllSpace() -> String {
         return components(separatedBy: .whitespacesAndNewlines).joined()
    }
    func trimSpace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

