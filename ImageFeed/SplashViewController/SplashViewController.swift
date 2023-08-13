import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    //MARK: - Variables
    private let ShowAuthSegueIdentifier = "splashViewControllerID"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    //MARK: - Lyfe cycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oauth2TokenStorage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: ShowAuthSegueIdentifier, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthSegueIdentifier {
            
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers[0] as? AuthViewController else {
                fatalError("Failed to prepare for \(ShowAuthSegueIdentifier)")
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - Functions
extension SplashViewController {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        ProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchAuthToken(code)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tapBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tapBarController
    }
    
    private func fetchAuthToken(_ code: String){
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.switchToTabBarController()
                ProgressHUD.dismiss()
            case .failure:
                ProgressHUD.dismiss()
                print("!failure NO TOKEN")
                break
            }
        }
    }
}

