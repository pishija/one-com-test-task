import UIKit

class PresenterBase<View>: NSObject where View: UIViewController {
    weak var view: View?
    
    func attach(view: View) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func loadData() {
        //Needs to be overriden
    }
}

class FeedPresenterBase<View>: PresenterBase<View> where View: UIViewController{
    func loadData(for offset: Int) {
        //needs to be overriden
    }
}

protocol View {
    associatedtype Presenter
    var presenter: Presenter { get set }
}

