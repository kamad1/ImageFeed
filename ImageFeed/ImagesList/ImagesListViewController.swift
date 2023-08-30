
import UIKit

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListService: ImagesListService?
    private var imagesServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
//    private let photosName: [String] = Array(0..<20).map{ "\($0)" }//1
    
//    private lazy var dateFormatter: DateFormatter = {  //
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd MMMM yyyy"
//            formatter.locale = Locale(identifier: "ru_RU")
//            return formatter
//        }() //
//    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        configureImageList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {   //3
//        if segue.identifier == showSingleImageSegueIdentifier {
//            let viewController = segue.destination as! SingleImageViewController
//            let indexPath = sender as! IndexPath
//            let image = UIImage(named: photosName[indexPath.row])
//            //            это хак и оставил для себя как напоминание
//            //            _ = viewController.view
//            viewController.image = image
//        } else {
//            super.prepare(for: segue, sender: sender)
//        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("ERROR! Ошибка привдения типов, создана пустая ячейка")
            return UITableViewCell()
        }
        
        let thumbnailURL = photos[indexPath.row].thumbImageURL
        let statusOfConfiguringCell = imageListCell.configCell(using: thumbnailURL, with: indexPath)
        if statusOfConfiguringCell {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return imageListCell
    }
}

//extension ImagesListViewController {  //4
//    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
//        guard let image = UIImage(named: photosName[indexPath.row]) else {
//            return
//        }
//
//        cell.cellImage.image = image
//        cell.dateLabel.text = dateFormatter.string(from: Date())
//
//        let isLiked = indexPath.row % 2 == 0
//        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
//        cell.likeButton.setImage(likeImage, for: .normal)
//    }
//}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath
    ) {
        guard let imagesListService = imagesListService else { return }
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let image = UIImage(named: photosName[indexPath.row]) else {
//            return 0
//        }
//        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
//        let imageWidth = image.size.width
//        let scale = imageViewWidth / imageWidth
//        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
//        return cellHeight
//    }
}

private extension ImagesListViewController {
    func configureImageList() {
        imagesListService = ImagesListService()
        guard let imagesListService = imagesListService else { return }
        imagesListService.fetchPhotosNextPage()
        
        imagesServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        updateTableViewAnimated()
    }
    
    func updateTableViewAnimated() {
        guard let imagesListService = imagesListService else { return }
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}
