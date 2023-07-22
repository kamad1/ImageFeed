//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Jedi on 22.07.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
















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

