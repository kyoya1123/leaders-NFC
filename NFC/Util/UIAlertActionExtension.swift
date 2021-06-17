import UIKit

extension UIAlertAction {
    public convenience init(_ title: String, action: (() -> Void)?) {
        self.init(title: title, style: .default) { _ in
            if let action = action {
                action()
            }
        }
    }
    
    public static var cancel: UIAlertAction {
        return UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
    }
}
