

import Foundation

public protocol WebViewPresenterProtocol {
     var view: WebViewViewControllerProtocol? { get set }
     func viewDidLoad()
     func didUpdateProgressValue(_ newValue: Double)
     func code(from url: URL) -> String?
 }

final class WebViewPresenter: WebViewPresenterProtocol {
//     private struct WebKeys {
//         static let clientId = "client_id"
//         static let redirectUri = "redirect_uri"
//         static let responseType = "response_type"
//         static let scope = "scope"
//     }
//     private struct WebConstants {
//         static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
//         static let code = "code"
//     }

    var authHelper: AuthHelperProtocol

         init(authHelper: AuthHelperProtocol) {
             self.authHelper = authHelper
         }
    
     weak var view: WebViewViewControllerProtocol?

     func viewDidLoad() {
//         var urlComponents = URLComponents(string: WebConstants.unsplashAuthorizeURLString)
//         urlComponents?.queryItems = [
//             URLQueryItem(name: WebKeys.clientId, value: AccessKey),
//             URLQueryItem(name: WebKeys.redirectUri, value: RedirectURI),
//             URLQueryItem(name: WebKeys.responseType, value: WebConstants.code),
//             URLQueryItem(name: WebKeys.scope, value: AccessScope)
//         ]
//         guard let url = urlComponents?.url else { return }
//         let request = URLRequest(url: url)
//
//         view?.addEstimatedProgressObservtion()
//
//         view?.load(request: request)
         
         let request = authHelper.authRequest()
                  guard let request = request else { return }
                  view?.load(request: request)

                  view?.addEstimatedProgressObservtion()
     }

     func didUpdateProgressValue(_ newValue: Double) {
         let newProgressValue = Float(newValue)
         view?.setProgressValue(newProgressValue)

         let shouldHideProgress = shouldHideProgress(for: newProgressValue)
         view?.setProgressHidden(shouldHideProgress)
     }

     func shouldHideProgress(for value: Float) -> Bool {
         abs(value - 1.0) <= 0.0001
     }
    
    func code(from url: URL) -> String? {
             authHelper.code(from: url)
         }
    
    
    
//    override func viewDidAppear(_ animated: Bool) {
//            super.viewDidAppear(animated)
//    
//            webView.addObserver(
//                self,
//                forKeyPath: #keyPath(WKWebView.estimatedProgress),
//                options: .new,
//                context: nil)
//            updateProgress()
//        }
//
//        override func viewWillDisappear(_ animated: Bool) {
//            super.viewWillDisappear(animated)
//            webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
//        }
//        
//        override func observeValue(forKeyPath keyPath: String?,
//                                   of object: Any?,
//                                   change: [NSKeyValueChangeKey : Any]?,
//                                   context: UnsafeMutableRawPointer?) {
//            if keyPath == #keyPath(WKWebView.estimatedProgress) {
//                updateProgress()
//            } else {
//                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//            }
//        }
 }


