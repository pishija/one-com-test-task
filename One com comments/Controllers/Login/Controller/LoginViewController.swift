import UIKit

#if canImport(TTTAttributedLabel)
import TTTAttributedLabel
#endif

#if canImport(MBProgressHUD)
import MBProgressHUD
#endif


class LoginViewController: ViewControllerBase, View, LoginViewDelegate {

    typealias Presenter = LoginViewPresenter
    
    var presenter: LoginViewPresenter
    
    var loginView: LoginView {
        return self.view as! LoginView
    }

    //MARK: Initializor
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, presenter: LoginViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(presenter: LoginViewPresenter) {
        self.init(nibName: nil, bundle: nil, presenter: presenter)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginView.delegate = self
        self.presenter.attach(view: self)
        self.presenter.loadData()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: LoginView
    
    func setSlogan(text: String) {
        self.loginView.sloganLabel.text = text
    }
    
    func setLoginButton(text: String) {
        self.loginView.loginButton.setTitle(text, for: .normal)
    }
    
    func showError(message : String) {
        self.loginView.errorLabel.text = message
    }
    
    func hideErrorMessage() {
        self.loginView.errorLabel.text = ""
    }
    
    //MARK: LoginViewDelegate
    
    func loginView(loginView: LoginView, didTapLogin button: UIButton) {
        self.presenter.onLoginButtonTapped()
    }
    
    private var mediaCaptureFlow: MediaCaptureSelectionFlow?
    
    func loginView(loginView: LoginView, didTapImageView view: UIImageView) {
        let mediaCaptureFlow = MediaCaptureSelectionFlow()
        mediaCaptureFlow.startImageCaptureSelectionFlow(from: self) { (image, success) in
            if let anImage = image {
                self.loginView.imageView.image = anImage
            }
        }
        self.mediaCaptureFlow = mediaCaptureFlow
    }
}

#if canImport(TTTAttributedLabel)

extension LoginViewController: TTTAttributedLabelDelegate {
    //MARK: - TTTAttributedLabelDelegate
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!)
    {
        if let _ = self.urlOpeningFlow{
            self.urlOpeningFlow?.open(url: url, inApplicationFrom: self)
        }
    }
}

#endif

