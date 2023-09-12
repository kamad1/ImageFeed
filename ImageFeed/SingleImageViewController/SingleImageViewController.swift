import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(delagate: self)

        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        UIBlockingProgressHUD.show()

        downloadImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let image = imageView.image {
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        present(activityController, animated: true, completion: nil)

    }
    
    //MARK: - Variables
    var largeImageURL: URL?
    private var alertPresenter: AlertPresenter?
    
    private var activityController = UIActivityViewController(activityItems: [], applicationActivities: nil)
    
//    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        UIView.animate(withDuration: 0.5) { [weak self] in
//
//            guard let self = self,
//                  let image = self.imageView.image  else {
//                return
//            }
//
//            self.rescaleAndCenterImageInScrollView(image: image)
//        }
//    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    func downloadImage() {
             imageView.kf.setImage(with: largeImageURL) { [weak self] result in
                 UIBlockingProgressHUD.dismiss()

                 guard let self = self else { return }

                 switch result {
                     case .success(let imageResult):
                         self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                         activityController = UIActivityViewController(
                             activityItems: [imageResult.image as Any],
                             applicationActivities: nil
                         )
                     case .failure:
                     self.showError()
                 }
             }
         }

         func showError() {
             let alert = AlertModel(title: "Что-то пошло не так.",
                                             message: "Попробовать ещё раз?",
                                             buttonText: "Не надо",
                                             completion: { [weak self] in
                          guard let self = self else { return }
                          self.dismiss(animated: true)
                      },
                                             secondButtonText: "Повторить",
                                             secondCompletion: { [weak self] in
                          guard let self = self else { return }

                          UIBlockingProgressHUD.show()
                          downloadImage()
                      })

                      alertPresenter?.show(alert)
         }
}
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            
            guard let self = self,
                  let image = self.imageView.image  else {
                return
            }
            
            self.rescaleAndCenterImageInScrollView(image: image)
        }
    }
}

extension SingleImageViewController: AlertPresentableDelagate {
    func present(alert: UIAlertController, animated flag: Bool) {
        self.present(alert, animated: flag)
    }
}











// КОД ниже оставил для себя пока как напоминание.
/*Итак, если нам нужно подменять изображение уже после viewDidLoad, мы можем реализовать обработчик didSet для image следующим образом:
 
 final class SingleImageViewController: UIViewController {
 var image: UIImage! {
 didSet {
 guard isViewLoaded else { return } // 1
 imageView.image = image // 2
 }
 }
 
 @IBOutlet var imageView: UIImageView!
 
 override func viewDidLoad() {
 super.viewDidLoad()
 imageView.image = image
 }
 }
 
 
 Прокомментируем то, что мы сделали:
 Сначала мы проверяем, было ли ранее загружено view. Это очень важная проверка, необходимая, чтобы не закрэшиться, если view ещё не было загружено (и, соответственно, аутлет ещё не инициализирован). Именно эта проверка не даст нам закрэшиться из prepareForSegue.
 В эту точку мы не должны попадать из prepareForSegue. Мы можем попасть в неё, например, если был показан SingleImageViewController, а указатель на него был запомнен извне. Далее  — извне (например, по свайпу) в него проставляется новое изображение.
 
 
 */

