//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Jedi on 23.08.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
    var secondButtonText: String? = nil
    var secondCompletion: () -> Void = {}
}
