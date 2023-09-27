import Foundation
import ImageFeed

final class ImageListPresenterSpy: ImagesListViewPresenterProtocol {
    func getCellHeight(indexPath: IndexPath, tableViewWidth: CGFloat, imageInsetsLeft: CGFloat, imageInsetsRight: CGFloat, imageInsetsTop: CGFloat, imageInsetsBottom: CGFloat) -> CGFloat {
        return CGFloat()
    }
    
     var view: ImageFeed.ImagesListViewControllerProtocol?
     var configureImageListCalled: Bool = false

     func configureImageList() {
         configureImageListCalled = true
     }

     func updateTableView() {

     }

     func getLargeImageURL(from indexPath: IndexPath) -> URL? {
         return nil
     }

     func getPhotosCount() -> Int {
         return 0
     }

     func getPhoto(indexPath: IndexPath) -> ImageFeed.Photo? {
         return nil
     }

     func fetchPhotosNextPage(indexPath: IndexPath) {

     }

     func changeLike(indexPath: IndexPath?, cell: ImageFeed.ImagesListCell) {

     }


 }
//     func getCellHeight(indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
//         return CGFloat()
//     }
