import UIKit
import Foundation

enum RegisterButtonType{
    case login
    case register
    case confirm
    case facebook
    case google
}

class RegistrationButton: UIButton{
    private var registerType: RegisterButtonType
    private let invert: Bool
    
    init(type: RegisterButtonType, invert: Bool){
        self.registerType = type
        self.invert = invert
        super.init(frame:.zero)
        customizeSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeSelf(){
        let white = UIColor.white
        let fontSize = UIScreen.main.bounds.width * 0.05
        let coachZoneRed = UIColor.init(red: 223/255, green: 0/255, blue: 46/255, alpha: 1)
        let font = UIFont (name: "GillSans-SemiBold", size: fontSize)
        let cornerRadius = UIScreen.main.bounds.width * 0.02
        let titleString: String = getTitleString()
        let titleColor = invert ? white : coachZoneRed
        let backgroundColor = invert ? coachZoneRed : white
        self.setTitleColor(titleColor, for: .normal)
        self.setTitle(titleString, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
    }
    
    func updateType(type: RegisterButtonType){
        self.registerType = type
        let titleString: String = getTitleString()
        self.setTitle(titleString, for: .normal)
    }
    
    private func getTitleString() -> String{
        switch registerType{
        case .login:
            return "LOGIN"
        case .register:
            return "REGISTER"
        case .confirm:
            return "CONFIRM"
        case .facebook:
            return "LOGIN WITH FACEBOOK"
        case .google:
            return "LOGIN WITH GOOGLE"
        }
    }
    
}
