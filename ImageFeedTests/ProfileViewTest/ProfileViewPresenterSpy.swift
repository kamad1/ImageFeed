
import UIKit
import ImageFeed


final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    
 
     var viewDidLoadCalled: Bool = false

     func viewDidLoad() {
         viewDidLoadCalled = true
     }

     func logOut() {

     }

     func updateAvatar() {

     }


 }
