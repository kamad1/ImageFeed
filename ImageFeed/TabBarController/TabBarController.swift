
import UIKit

final class TabBarController: UITabBarController {
    
    private struct Keys {
        static let main = "Main"
        static let imagesListViewController = "ImagesListViewController"
        static let tabBarProfileImageName = "tab_profile_active"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storybord = UIStoryboard(name: Keys.main, bundle: .main)
        let imageListViewController = storybord.instantiateViewController(
            withIdentifier: Keys.imagesListViewController
        ) as? ImagesListViewController
        guard let imageListViewController = imageListViewController else { return }
        let imageListViewPresenter = ImagesListViewPresenter()
        imageListViewController.configure(imageListViewPresenter)
        
        view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter()
        profileViewController.configure(profileViewPresenter)
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        self.viewControllers = [imageListViewController, profileViewController]
    }
}
