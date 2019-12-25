import UIKit
import SkyFloatingLabelTextField

extension SkyFloatingLabelTextField{
    //Animates a skyfloatingtextfield to shake
    func animateField(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    //Shakes the field and sets error message to message
    func handleError(message: String){
        self.animateField()
        self.errorMessage = message
    }
}

extension UIViewController{
    func initNavBar() {
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = .white
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        let image = UIImage(named: "coachzone_logo_red")
        imageView.image = image
        self.navigationItem.titleView = imageView
    }
    
    //Presents popup confirming users registered succesfully
    func presentRegistrationFeedback(success: Bool, message: String = "", title:String = ""){
        var animatedImage: UIImage
        var gifString: String
        var messageString = message
        var titleString = title
        success ? (gifString = "ezgif.com-optimize"): (gifString = "greyError")
        if messageString == ""{
            success ? (messageString = "Welcome to CoachZone!") : (messageString = "There was an error registering, please try again")
        }
        if titleString == ""{
            success ? (titleString = "Registered"): (titleString = "Error")
        }
        success ? (animatedImage = UIImage.gif(name: gifString)!): (animatedImage = UIImage(named: gifString)!)
        let iconView = UIImageView(image: animatedImage)
        
        if success{
            iconView.animationImages = animatedImage.images
            iconView.animationDuration = (animatedImage.duration) / 2
        }
        let view = SPAlertView(title: titleString, message: messageString, icon: iconView)
        view.present()
    }
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?,
                leading:NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?,
                height: NSLayoutDimension? = nil,
                width: NSLayoutDimension? = nil,
                sizeMultiplier: CGSize = .zero,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let height = height{
            if sizeMultiplier.height != 0{
                heightAnchor.constraint(equalTo: height, multiplier: sizeMultiplier.height).isActive = true
            }
        }
        if let width = width{
            if sizeMultiplier.width != 0{
                widthAnchor.constraint(equalTo: width, multiplier: sizeMultiplier.width).isActive = true
            }
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func anchor(equalTo: UIView, padding: UIEdgeInsets = .zero, sizeMultiplier: CGSize = .zero){
        self.anchor(top: equalTo.topAnchor, leading: equalTo.leadingAnchor, bottom: equalTo.bottomAnchor, trailing: equalTo.trailingAnchor, padding: padding)
    }
    
    func anchor(height: UIView, width: UIView, sizeMultiplier: CGSize){
        self.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, height: height.heightAnchor, width: width.widthAnchor, sizeMultiplier: sizeMultiplier)
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}


@available(iOS 5.0 ,watchOS 8.0, *)
public extension UIFont {
    
    public enum gillSans: String {
        case sans = "GillSans"
        case bold = "GillSans-Bold"
        case boldItalic = "GillSans-BoldItalic"
        case italic = "GillSans-Italic"
        case light = "GillSans-Light"
        case lightItalic = "GillSans-LightItalic"
        case semiBold = "GillSans-SemiBold"
        public func font(size: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: size)!
        }
    }
}

extension UIView {
    func findCommonSuperWith(_ view:UIView) -> UIView? {
        
        var a:UIView? = self
        var b:UIView? = view
        var superSet = Set<UIView>()
        while a != nil || b != nil {
            print("STUCK")
            if let aSuper = a {
                if !superSet.contains(aSuper) { superSet.insert(aSuper) }
                else { return aSuper }
            }
            if let bSuper = b {
                if !superSet.contains(bSuper) { superSet.insert(bSuper) }
                else { return bSuper }
            }
            a = a?.superview
            b = b?.superview
        }
        return nil
        
    }
}


extension Int{
    func toFormattedString() -> String?{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:self))
        return formattedNumber
    }
}

