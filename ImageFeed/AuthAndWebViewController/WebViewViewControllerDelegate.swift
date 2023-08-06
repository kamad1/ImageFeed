//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Jedi on 05.08.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
