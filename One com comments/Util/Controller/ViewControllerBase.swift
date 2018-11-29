import UIKit

class ViewControllerBase: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    var keyboardHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = self.scrollView {
            self.registerForKeyboardNotifications()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterForKeyboardNotifications()
    }
    
    func showTakeoverLoading(){
        self.activityIndicator?.isHidden = false
        self.activityIndicator?.startAnimating()
    }
    
    func hideTakeoverLoading(){
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.isHidden = true
    }
    
    func unregisterForKeyboardNotifications(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    func registerForKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillBeShown),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillBeHidden),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    @objc func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets()
        self.scrollView?.contentInset = contentInsets
        self.scrollView?.scrollIndicatorInsets = contentInsets
        self.keyboardHeight = nil
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    @objc func keyboardWillBeShown(sender: NSNotification) {
        let info: NSDictionary = sender.userInfo! as NSDictionary
        let value: NSValue = info.value(forKey: UIResponder.keyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.cgRectValue.size
        self.keyboardHeight = keyboardSize.height
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        self.scrollView?.contentInset = contentInsets
        self.scrollView?.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        
        let firstResponder = UIResponder.currentFirstResponder()
        
        if(firstResponder.isKind(of: UITextField.self)){
            let activeTextField = firstResponder as! UITextField
            let activeTextFieldRect: CGRect? = activeTextField.superview?.convert(activeTextField.frame, to: self.scrollView!)
            let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
            if (!aRect.contains(activeTextFieldOrigin!)) {
                self.scrollView?.scrollRectToVisible(activeTextFieldRect!, animated:true)
            }
        }
    }
}

extension UIResponder{
    private weak static var _currentFirstResponder: UIResponder? = nil
    
    public class func currentFirstResponder() -> UIResponder{
        UIResponder._currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder), to: nil, from: nil, for: nil)
        return UIResponder._currentFirstResponder!
    }
    
    @objc internal func findFirstResponder(sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}

class FeedControllerBase<Item: Equatable>: ViewControllerBase {
    
    private (set) var items: [Item] = []
    
    func set(items: [Item]) {
        self.items = items
    }
    
    func append(items: [Item]) {
        self.items.append(contentsOf: items)
    }
    
    func remove(item: Item) {
        self.items = self.items.filter( { $0 != item })
    }
}

class TableViewFeedControllerBase<Item: Equatable>: FeedControllerBase<Item> {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(refreshControl)
    }

    override func showTakeoverLoading() {
        self.refreshControl.beginRefreshing()
    }

    override func hideTakeoverLoading() {
        self.refreshControl.endRefreshing()
    }
    
    func showPaginatationLoading() {
        //TODO:
    }
    
    func hidePaginationLoading() {
        //TODO: 
    }
    
    @objc func reloadData() {
        //Override
    }
    
    //Overrides
    
    override func set(items: [Item]) {
        super.set(items: items)
        self.tableView.reloadData()
    }
    
    override func append(items: [Item]) {
        super.append(items: items)
        self.tableView.reloadData()
    }
}
