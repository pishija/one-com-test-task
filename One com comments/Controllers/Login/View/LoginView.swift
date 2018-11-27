import UIKit

protocol LoginViewDelegate: class {
    func loginView(loginView: LoginView, didTapLogin button: UIButton)
}

class LoginView: UIView {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField?
    
    @IBOutlet weak var loginButton: UIButton!
    
    weak var delegate: LoginViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
    }
    
    //MARK: Private
    
    func setupUI() {
        self.passwordTextField?.isSecureTextEntry = true
        self.passwordTextField?.placeholder = NSLocalizedString("Password", comment: "")
        self.usernameTextField.placeholder = NSLocalizedString("Username", comment: "")        
    }
    
    @IBAction
    private func loginButtonTapped(_ sender: UIButton) {
        self.delegate?.loginView(loginView: self, didTapLogin: sender)
    }
    
}

//MARL: Appearance

extension LoginView {
    
    @objc dynamic var sloganTextColor: UIColor {
        set {
            self.sloganLabel.textColor = newValue
        }
        get {
            return sloganLabel.textColor
        }
    }
    
    @objc dynamic var sloganFont: UIFont {
        set {
            self.sloganLabel.font = newValue
        }
        get {
            return sloganLabel.font
        }
    }
    
    @objc dynamic var errorTextColor: UIColor {
        set {
            self.errorLabel.textColor = newValue
        }
        get {
            return errorLabel.textColor
        }
    }
    
    @objc dynamic var errorFont: UIFont {
        set {
            self.errorLabel.font = newValue
        }
        get {
            return errorLabel.font
        }
    }
    
    @objc dynamic var loginButtonColor: UIColor? {
        set {
            self.loginButton.backgroundColor = newValue
        }
        get {
            return self.loginButton.backgroundColor
        }
    }

    @objc dynamic var loginButtonTextColor: UIColor? {
        set {
            self.loginButton.setTitleColor(newValue, for: .normal)
        }
        get {
            return self.loginButton.titleColor(for: .normal)
        }
    }
    
    @objc dynamic var loginButtonFont: UIFont? {
        set {
            self.loginButton.titleLabel?.font = newValue
        }
        get {
            return self.loginButton.titleLabel?.font
        }
    }

    @objc dynamic var textFieldTextColor: UIColor? {
        set {
            self.usernameTextField.textColor = newValue
            self.passwordTextField?.textColor = newValue
        }
        get {
            return self.usernameTextField.textColor
        }
    }
}
