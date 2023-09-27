//
//  WebViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Jedi on 13.09.2023.
//
import ImageFeed
import Foundation

final class WebViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    var loadRequestCalled = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func addEstimatedProgressObservtion() {
    
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
