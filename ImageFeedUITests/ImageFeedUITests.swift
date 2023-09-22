
import XCTest
import ImageFeed


final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 7))
        sleep(3)
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        // указать почту
        sleep(3)
        loginTextField.typeText("")
        sleep(3)
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
      
        XCUIApplication().toolbars.buttons["Done"].tap()
        passwordTextField.tap()
        //указать пароль
        passwordTextField.typeText("")
        sleep(3)
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 8))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let firstCell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        firstCell.swipeUp()
        sleep(3)
        
        let anotherCell = tablesQuery.children(matching: .cell).element(boundBy: 1)
        anotherCell.buttons["LikeButton"].tap()
        sleep(5)
        anotherCell.buttons["LikeButton"].tap()
        sleep(5)
        anotherCell.tap()
        sleep(2)
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        app.buttons["BackButton"].tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        //указать ФИО
        XCTAssertTrue(app.staticTexts[""].exists)
        //указать НИК
        XCTAssertTrue(app.staticTexts[""].exists)
        
        app.buttons["logOutButton"].tap()
        sleep(1)
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(1)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}




























//    func testAuth() throws {
//        app.buttons["Authenticate"].tap()
//        let webView = app.webViews["UnsplashWebView"]
//        XCTAssertTrue(webView.waitForExistence(timeout: 7))
//        let loginTextField = webView.descendants(matching: .textField).element
//        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
//
//        loginTextField.tap()
//        // указать почту
//        loginTextField.typeText("artkamadi@gmail.com")
//        webView.tap()
//        webView.swipeUp()
//        let passwordTextField = webView.descendants(matching: .secureTextField).element
//        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
//
//        passwordTextField.tap()
//        //указать пароль
//        passwordTextField.typeText("Caspersetdd2023")
//        webView.tap()
//        webView.swipeUp()
//
//        webView.buttons["Login"].tap()
//
//        let tablesQuery = app.tables
//        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
//
//        XCTAssertTrue(cell.waitForExistence(timeout: 8))
//    }
