import UIKit
import Foundation

class GetHelpPopup: AbstractPopup, UITextViewDelegate{
    
    var topLogo: UIImageView!
    var topLabel: AutoAdjustedLabel!
    var emailContact: AutoAdjustedLabel!
    var delegate: FeedbackPopupDelegate!
    
    
    init(){
        super.init(title: "Get Help")
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
        customizeEmailLabel()
        
    }
    
    private func constrainSubviews(){
        constrainTopLogo()
        constrainTopLabel()
        constrainEmailLabel()
    }
    
    private func customizeSelf(){
        self.doneButton.addTarget(self, action: #selector(closeMe), for: .touchUpInside)
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
        let feedbackText = "CoachZone is currently working on the best way to provide our users with help. For now please use the contact information below if you are having difficulties using our product."
        let fontSize = UIScreen.main.bounds.width * 0.2
        topLabel = AutoAdjustedLabel(numberOfLines: 10, fontSize: fontSize, text: feedbackText, color: .black, notBold: true)
        self.containerView.addSubview(topLabel)
    }
    
    private func customizeEmailLabel(){
        let emailContactString = "Email: Tfischer1324@gmail.com"
        let fontSize = UIScreen.main.bounds.width * 0.2
        emailContact = AutoAdjustedLabel(numberOfLines: 1, fontSize: fontSize, text: emailContactString, color: .black, notBold: true)
        self.containerView.addSubview(emailContact)
    }
    

    private func constrainTopLogo(){
        let padding = UIScreen.main.bounds.width * 0.05
        let topLogoPadding: UIEdgeInsets = .init(top: padding, left: padding, bottom: 0, right: padding)
        
        topLogo.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor,height: containerView.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.2), padding: topLogoPadding)
        
    }
    
    private func constrainTopLabel(){
        let padding = UIScreen.main.bounds.width * 0.05
        let topLabelPadding: UIEdgeInsets = .init(top: 0, left: padding, bottom: 0, right: padding)
        topLabel.anchor(top: topLogo.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, height: containerView.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.35), padding: topLabelPadding)
    }
    
    private func constrainEmailLabel(){
        let padding = UIScreen.main.bounds.width * 0.05
        let feedbackInputPadding: UIEdgeInsets = .init(top: padding * 2, left: padding, bottom: 0, right: padding)
        emailContact.anchor(top: topLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, height: containerView.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.25), padding: feedbackInputPadding)
    }
}
