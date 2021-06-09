import UIKit

extension UIView {
    
    func rounded(_ radius: CGFloat? = nil) {
        layer.masksToBounds = true
        if let radius = radius {
            layer.cornerRadius = radius
        } else {
            layer.cornerRadius = frame.height / 2
        }
    }
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
    }
    
    func addBorder(_ color: UIColor, _ width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func setGradient(_ colors: [UIColor]) {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = [0, 1]
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
    
    func removeGradient() {
        layer.sublayers = layer.sublayers?.filter { layer in
            !layer.isKind(of: CAGradientLayer.classForCoder())
        }
    }
}
