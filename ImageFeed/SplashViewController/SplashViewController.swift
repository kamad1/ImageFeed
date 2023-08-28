import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    //MARK: - Variables
    private let ShowAuthSegueIdentifier = "splashViewControllerID"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private var alertPresenter: AlertPresenterProtocol?
    private let profileImageService = ProfileImageService.shared
    private var authViewController: AuthViewController?
    private struct Keys {
        static let main = "Main"
        static let authViewControllerID = "AuthViewController"
    }
    private let splashScreenImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LaunchScreen"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    //MARK: - Lyfe cycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            self.fetchProfile(token: token)
        } else {
            switchToAuthViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)
        addSubViews()
        configureConstraints()
    }
    
    private func checkAuthToken(_ code: String){
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let token):
                    self.fetchProfile(token: token)
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    showErrorAlert()
                    
                    break
            }
        }
    }
}

//MARK: - AuthViewControllerDelegate
//extension SplashViewController: AuthViewControllerDelegate {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == ShowAuthSegueIdentifier {
//
//            guard let navigationController = segue.destination as? UINavigationController,
//                  let viewController = navigationController.viewControllers[0] as? AuthViewController else {
//                fatalError("Failed to prepare for \(ShowAuthSegueIdentifier)")
//            }
//            viewController.delegate = self
//        } else {
//            super.prepare(for: segue, sender: sender)
//        }
//    }
//}
extension SplashViewController: AuthViewControllerDelegate {
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        authViewController = storyboard.instantiateViewController(withIdentifier: Keys.authViewControllerID) as? AuthViewController
        authViewController?.delegate = self
        guard let authViewController = authViewController else { return }
        
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
}
//MARK: - Functions
extension SplashViewController {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tapBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tapBarController
    }
    
    private func fetchOAuthToken(_ code: String){
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                print("!failure NO TOKEN")
                showErrorAlert(message: "Не удалось войти в систему")
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let data):
                    
                    profileImageService.fetchProfileImageURL(
                        token: token,
                        username: data.username
                    ){ _ in }
                    
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    showErrorAlert()
                    break
            }
        }
        
    }
}

//MARK: - AlertPresenter
extension SplashViewController {
    private func showErrorAlert(message: String = "Не удалось войти в систему"){
        let alert = AlertModel(title: "Что-то пошло не так(",
                               message: message,
                               buttonText: "Ок",
                               completion: { [weak self] in
            guard let self = self else {
                return
            }
            oauth2TokenStorage.token = nil
        })
        //TODO: Найти более изящный вариант
        let topController = UIApplication.topViewController()
        if let topController = topController {
            alertPresenter = AlertPresenter(delagate: topController as? AlertPresentableDelagate)
        } else {
            alertPresenter = AlertPresenter(delagate: self)
        }
        
        alertPresenter?.show(alert)
    }
}

//MARK: - AlertPresentableDelagate
extension SplashViewController: AlertPresentableDelagate {
    func present(alert: UIAlertController, animated flag: Bool) {
        self.present(alert, animated: flag)
    }
}

////MARK: - Layout functions
extension SplashViewController {
    func addSubViews() {
        view.addSubview(splashScreenImageView)
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            splashScreenImageView.heightAnchor.constraint(equalToConstant: 77),
            splashScreenImageView.widthAnchor.constraint(equalToConstant: 74),
            splashScreenImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashScreenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
