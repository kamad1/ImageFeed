
import UIKit

final class OAuth2Service: UIViewController {

    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchAuthToken(
            _ code: String,
            complition: @escaping (Result<String,Error>) -> Void
        ) {
//            let request = authTokenRequest(code: code)
//            let task = object(for: request) { [weak self] result in
//                guard let self = self else { return }
//                DispatchQueue.main.async {
//                switch result {
//                case .success(let body):
//                    let authToken = body.accessToken
//                    self.authToken = authToken
//                    complition(.success(authToken))
//                case .failure(let error):
//                    complition(.failure(error))
//                }
//            }
//            }
//            task.resume()
        }
    }



