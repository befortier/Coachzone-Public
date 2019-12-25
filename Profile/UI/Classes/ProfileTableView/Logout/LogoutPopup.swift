import UIKit
import Foundation
protocol LogoutPopupDelegate: class {
    func logout()
}

class LogoutPopup: AbstractPopup, UITextViewDelegate{
    
    var topLogo: UIImageView!
    var topLabel: AutoAdjustedLabel!
    var logoutButton: RegistrationButton!
    var stayLoggedInButton: RegistrationButton!
    var delegate: LogoutPopupDelegate!
    
    
    init(){
        super.init(title: "Logout")
        customizeSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeSubviews(){
        customizeSelf()
        customizeTopLogo()
        customizeTopLabel()
        customizeLogoutButton()
        customizeStayLoggedInButton()
        
    }
    
    private func constrainSubviews(){
        constrainTopLogo()
        constrainTopLabel()
        constrainLogoutButton()
        constrainStayLoggedInButton()
    }
    
    private func customizeSelf(){
        self.doneButton.isHidden = true
        self.cancelButton.isHidden = true
    }
    
    
    private func customizeTopLogo(){
        topLogo = UIImageView()
        let logoImage = UIImage(named: "logoHeadphones")!
        topLogo.image = logoImage
        topLogo.contentMode = .scaleAspectFit
        self.containerView.addSubview(topLogo)
    }
    
    private func customizeTopLabel(){
        let feedbackText = "Are you sure you want to logout?"
        let fontSize = UIScreen.main.bounds.width * 0.08
        topLabel = AutoAdjustedLabel(numberOfLines: 2, fontSize: fontSize, text: feedbackText, color: .black, notBold: true)
        self.containerView.addSubview(topLabel)
    }
    
    private func customizeLogoutButton(){
        logoutButton = RegistrationButton(type: .login, invert: false)
        logoutButton.setTitle("Logout", for: .normal)
        self.containerView.addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    private func customizeStayLoggedInButton(){
        stayLoggedInButton = RegistrationButton(type: .login, invert: true)
        stayLoggedInButton.setTitle("Nevermind", for: .normal)
        self.containerView.addSubview(stayLoggedInButton)
        stayLoggedInButton.addTarget(self, action: #selector(closeMe), for: .touchUpInside)
    }
    
    
    private func constrainTopLogo(){
        let padding = UIScreen.main.bounds.width * 0.05
        let topLogoPadding: UIEdgeInsets = .init(top: 3*padding, left: padding, bottom: 0, right: padding)
        topLogo.anchor(top: topLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor,height: containerView.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.2), padding: topLogoPadding)
        
    }
    
    private func constrainTopLabel(){
        let padding = UIScreen.main.bounds.width * 0.05
        let topLabelPadding: UIEdgeInsets = .init(top: padding, left: padding, bottom: 0, right: padding)
        topLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, height: containerView.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.2), padding: topLabelPadding)
    }
    
    private func constrainLogoutButton(){
        let horizantalPadding = UIScreen.main.bounds.width * 0.025
        let topPadding = UIScreen.main.bounds.height * 0.08
        let stayLoggedInButtonPadding: UIEdgeInsets = .init(top: topPadding, left: horizantalPadding, bottom: 0, right: horizantalPadding)
        stayLoggedInButton.anchor(top: self.topLogo.bottomAnchor, leading: self.containerView.leadingAnchor, bottom: nil, trailing: self.containerView.trailingAnchor, height: self.containerView.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.1), padding: stayLoggedInButtonPadding)
    }
    
    private func constrainStayLoggedInButton(){
        logoutButton.anchor(top: stayLoggedInButton.bottomAnchor, leading: stayLoggedInButton.leadingAnchor, bottom: nil, trailing: stayLoggedInButton.trailingAnchor, height: stayLoggedInButton.heightAnchor, sizeMultiplier: .init(width: 0, height: 1))
    }
    
    @objc func logout(){
        closeMe()
        delegate.logout()
    }
}
