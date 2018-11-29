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
            self.repository.createUser(with: username, image: nil) { (user, error) in
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
