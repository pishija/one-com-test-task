import Foundation

class LoginViewPresenter: PresenterBase<LoginViewController> {
    
    var repository: CommentsRepository
    
    init(repository: CommentsRepository) {
        self.repository = repository
    }
    
    override func loadData() {
        self.view?.setSlogan(text: "An innovative digital agency")
        self.view?.setLoginButton(text: NSLocalizedString("Login", comment: ""))
    }
    
    func onLoginButtonTapped() {
        self.view?.hideErrorMessage()
        if let username = self.view?.loginView.usernameTextField.text, username.count > 0{
            self.view?.showTakeoverLoading()
            self.view?.loginView.usernameTextField.resignFirstResponder()
            self.view?.loginView.usernameTextField.isEnabled = false
            self.view?.loginView.loginButton.isEnabled = false
            self.view?.loginView.imageView.isUserInteractionEnabled = false
            let image = self.view?.loginView.imageView.image
            self.repository.createUser(with: username, image: image) { (user, error) in
                DispatchQueue.main.async {
                    self.view?.hideTakeoverLoading()
                    self.view?.loginView.usernameTextField.isEnabled = true
                    self.view?.loginView.loginButton.isEnabled = true
                    self.view?.loginView.imageView.isUserInteractionEnabled = true
                }
                guard error == nil else {
                    self.view?.showError(message: error!.localizedDescription)
                    return
                }
                DispatchQueue.main.async {
                    self.view?.delegate?.loginView(controller: self.view!, didLoginWith: user!)
                }
            }
        } else {
            self.view?.showError(message: "Please provide username")
        }

    }
}
