//
//  UIButton+Extension.swift
//  Yacare
//
//  Created by Leandro Berli on 02/09/2021.
//

import Foundation
import UIKit

extension UIView {
    func setCornerRadius() {
        self.layer.cornerRadius = 5
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

