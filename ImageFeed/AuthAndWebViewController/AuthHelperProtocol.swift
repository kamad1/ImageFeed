
import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest? {
        let url = authUrl()
        guard let url = url else { return nil }
        
        return URLRequest(url: url)
    }
    
    func authUrl() -> URL? {
        var urlComponents = URLComponents(string: configuration.authURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: configuration.clientId, value: configuration.accessKey),
            URLQueryItem(name: configuration.redirectUriName, value: configuration.redirectURI),
            URLQueryItem(name: configuration.responseType, value: configuration.code),
            URLQueryItem(name: configuration.scope, value: configuration.accessScope)
        ]
        
        return urlComponents?.url
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == configuration.authPath,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == configuration.code })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
