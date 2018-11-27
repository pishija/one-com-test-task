import Foundation

class LoginViewPresenter: PresenterBase<LoginViewController> {
    
    override func loadData() {
        self.view?.setSlogan(text: "An innovative digital agency")
        self.view?.setLoginButton(text: NSLocalizedString("Login", comment: ""))
    }
    
    func onLoginButtonTapped() {

    }
}
