
import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
    
    private struct Keys {
        static let main = "Main"
        static let logoutImageName = "logout_button"
        static let systemLogoutImageName = "ipad.and.arrow.forward"
        static let logOutActionName = "logOut"
        static let systemAvatarImageName = "person.crop.circle.fill"
        static let avatarPlaceholderImageName = "avatar_placeholder"
        static let authViewControllerName = "AuthViewController"
    }
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var label: UILabel?
    private let translucentGradient = TranslucentGradient()
    private var animationLayers = Set<CALayer>()
    
    private var avatarImageView: UIImageView = {
        //        let imageView = UIImageView()
        //        imageView.image = UIImage(named: "avatar")
        let imageView = UIImageView(image: UIImage(systemName: Keys.systemAvatarImageName))
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let labelname = UILabel()
        //        labelname.text = "Екатерина Новикова"
        labelname.textAlignment = .left
        labelname.textColor = .white
        labelname.font = .systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        labelname.translatesAutoresizingMaskIntoConstraints = false
        
        return labelname
    }()
    
    private  var loginNameLabel: UILabel = {
        let loginLabel = UILabel()
        //        loginLabel.text = "@ekaterina_nov"
        loginLabel.textAlignment = .left
        loginLabel.textColor = .lightGray
        loginLabel.font = .systemFont(ofSize: 13)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return loginLabel
    }()
    
    private var descriptionLabel: UILabel = {
        let descriptionText = UILabel()
        //        descriptionText.text = "Hello, World!"
        descriptionText.textColor = .white
        descriptionText.font = .systemFont(ofSize: 13)
        descriptionText.textAlignment = .left
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        
        return descriptionText
    }()
    
    //    lazy var logoutButton: UIButton = {
    //
    //        let button = UIButton.systemButton(
    //            with: UIImage(named: "logout_button") ?? UIImage(),
    //            target: self,
    //            action: #selector(Self.didTapLogoutButton)
    //        )
    //
    //        button.tintColor = #colorLiteral(red: 0.9607843137, green: 0.4196078431, blue: 0.4235294118, alpha: 1)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        if #available(iOS 14.0, *) {
    //
    //                      //TODO: Выход из профиля
    //                    let logOutAction = UIAction(title: "logOut") { (ACTION) in
    //                        ProfileViewController.logOut()
    //                    }
    //                    button.addAction(logOutAction, for: .touchUpInside)
    //                } else {
    //                   button.addTarget(ProfileViewController.self,
    //                                    action: #selector(didTapLogoutButton),
    //                                    for: .touchUpInside)
    //               }
    //        return button
    //    }()
    
    lazy var logoutButton: UIButton = {
        
        let image = UIImage(named: Keys.logoutImageName) ?? UIImage(systemName: Keys.systemLogoutImageName)!
        
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.9607843137, green: 0.4196078431, blue: 0.4235294118, alpha: 1)
        if #available(iOS 14.0, *) {
            
            //TODO: Выход из профиля
            let logOutAction = UIAction(title: Keys.logOutActionName) { (ACTION) in
                ProfileViewController.logOut()
            }
            button.addAction(logOutAction, for: .touchUpInside)
        } else {
            button.addTarget(ProfileViewController.self,
                             action: #selector(didTapLogoutButton),
                             for: .touchUpInside)
        }
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)
        
        view.addSubview(avatarImageView)
        avatarImageSetup()
        
        view.addSubview(nameLabel)
        nameLabelSetup()
        
        view.addSubview(loginNameLabel)
        loginNameSetup()
        
        view.addSubview(descriptionLabel)
        descriptionLabelSetup()
        
        
        view.addSubview(logoutButton)
        logoutButtonSetup()
        
        
        
        updateProfileDetails(profile: profileService.profile)
        
        addGradients()
    }
    
    //     func updateProfileDetails(profile: Profile?) {
    //        guard let profile = profile else { return }
    //        nameLabel.text = profile.name
    //        loginNameLabel.text = profile.loginName
    //        descriptionLabel.text = profile.bio
    //
    //        profileImageServiceObserver = NotificationCenter.default.addObserver(
    //            forName: ProfileImageService.DidChangeNotification,
    //            object: nil,
    //            queue: .main
    //        ) { [weak self] _ in
    //            guard let self = self else { return }
    //            self.updateAvatar()
    //        }
    //        updateAvatar()
    //    }
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    func avatarImageSetup() {
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 35
        
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func nameLabelSetup() {
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    func loginNameSetup() {
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
    }
    
    func descriptionLabelSetup() {
        descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
    }
    
    func logoutButtonSetup() {
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc
    func didTapLogoutButton() {
        ProfileViewController.logOut()
    }
    
}

private extension ProfileViewController {
    func updateAvatar() {
        guard
            let avatarURL = profileImageService.avatarURL,
            let url = URL(string: avatarURL)
        else { return }
        
        let avatarPlaceholderImage = UIImage(named: Keys.avatarPlaceholderImageName)
        
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: avatarPlaceholderImage,
            options: [.processor(processor)]
        ){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.removeGradients()
            case .failure:
                print("!ОШИБКА загрузки аватара")
            }
        }
    }
    
    func addGradients() {
        let avatarGradient = translucentGradient.getGradient(
            size: CGSize(
                width: 70,
                height: 70
            ),
            cornerRadius: avatarImageView.layer.cornerRadius)
        avatarImageView.layer.addSublayer(avatarGradient)
        animationLayers.insert(avatarGradient)
        
        let nameLabelGradient = translucentGradient.getGradient(size: CGSize(
            width: 223,//nameLabel.bounds.width,
            height: 27//nameLabel.bounds.height
        ))
        nameLabel.layer.addSublayer(nameLabelGradient)
        animationLayers.insert(nameLabelGradient)
        
        let descriptionLabelGradient = translucentGradient.getGradient(size: CGSize(
            width: 223,//descriptionLabel.bounds.width,
            height: 20//descriptionLabel.bounds.height
        ))
        descriptionLabel.layer.addSublayer(descriptionLabelGradient)
        animationLayers.insert(descriptionLabelGradient)
        
        let loginLabelGradient = translucentGradient.getGradient(size: CGSize(
            width: 223,//loginNameLabel.bounds.width,
            height: 20
        ))
        loginNameLabel.layer.addSublayer(loginLabelGradient)
        animationLayers.insert(loginLabelGradient)
    }
    
    func removeGradients() {
        for gradient in animationLayers {
            gradient.removeFromSuperlayer()
        }
    }
    
    static func logOut() {
        OAuth2TokenStorage().token = nil
        WebViewViewController.cleanCookies()
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        
        let authViewController = UIStoryboard(name: Keys.main, bundle: .main).instantiateViewController(withIdentifier: Keys.authViewControllerName)
        window.rootViewController = authViewController
    }
    
}

