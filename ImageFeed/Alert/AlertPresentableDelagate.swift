//
//  AlertPresentableDelagate.swift
//  ImageFeed
//
//  Created by Jedi on 23.08.2023.
//

import Foundation
import UIKit

protocol AlertPresentableDelagate: AnyObject {
    func present(alert: UIAlertController, animated flag: Bool)
}
