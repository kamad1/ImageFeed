
@testable import ImageFeed

import XCTest

 final class ProfileViewTests: XCTestCase {
     func testViewControllerCallsViewDidLoad() {
              let profileViewController = ProfileViewController()
              let profileViewPresenter = ProfileViewPresenterSpy()
              profileViewController.configure(profileViewPresenter)

              _ = profileViewController.view

              XCTAssertTrue(profileViewPresenter.viewDidLoadCalled)

     }
 }
