import UIKit

extension UIAlertController {
    convenience init(_ title: String, message: String? = nil, defaultActionButtonTitle: String = "OK", action: (() -> Void)? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        addAction(UIAlertAction(defaultActionButtonTitle, action: action))
    }
    
    func show(completion: (() -> Void)? = nil) {
        UIApplication.topViewController()?.present(self, animated: true, completion: completion)
    }
    
    func addOKAction() -> UIAlertController {
        addAction(UIAlertAction("OK", action: nil))
        return self
    }
    
    class func showErrorAlert(_ description: String) {
        print(description)
        UIAlertController("エラー", message: description, action: nil).show()
    }
}
