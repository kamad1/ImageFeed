
@testable import ImageFeed
import XCTest

 final class ImageListTests: XCTestCase {
     func testImageListCallsViewDidLoad() {
              let imageListViewController = ImagesListViewController()
              let imageListViewPresenter = ImageListPresenterSpy()
              imageListViewController.configure(imageListViewPresenter)

              _ = imageListViewController.view

              XCTAssertTrue(imageListViewPresenter.configureImageListCalled)

     }
 }
