import UIKit
import Foundation

protocol FeedbackPopupDelegate: class {
    func sendFeedback(feedback: String)
}

class FeedbackPopup: AbstractPopup, UITextViewDelegate{
    
    var topLogo: UIImageView!
    var topLabel: AutoAdjustedLabel!
    var feedbackInput: UITextView!
    var submitFeedbackButton: UIButton!
    var delegate: FeedbackPopupDelegate!

    
    init(){
        super.init(title: "Give Feedback")
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
        customizeFeedbackInputField()
        customizeSubmitFeedbackButton()

    }
 
    private func constrainSubviews(){
        constrainTopLogo()
        constrainTopLabel()
        constrainFeedbackInputField()
        constrainSubmitFeedbackButton()
    }

    private func customizeSelf(){
        self.doneButton.isHidden = true
        let resignResponderGesture = UITapGestureRecognizer(target: self, action: #selector(resignResponder))
        self.addGestureRecognizer(resignResponderGesture)
    }
    
    private func customizeTopLogo(){
        topLogo = UIImageView()
        let logoImage = UIImage(named: "logoHeadphones")!
        topLogo.image = logoImage
        topLogo.contentMode = .scaleAspectFit
        self.containerView.addSubview(topLogo)
    }
    
    private func customizeTopLabel(){
        let feedbackText = "CoachZone is always looking for ways to improve, please let us know what you like or don't like about our product. "
        let fontSize = UIScreen.main.bounds.width * 0.2
        topLabel = AutoAdjustedLabel(numberOfLines: 3, fontSize: fontSize, text: feedbackText, color: .black, notBold: true)
        self.containerView.addSubview(topLabel)
    }
    
    private func customizeFeedbackInputField(){
        let fontSize = UIScreen.main.bounds.width * 0.045
        let textFont = UIFont (name: "GillSans", size: fontSize)
        let borderWidth = UIScreen.main.bounds.height * 0.002
        feedbackInput = UITextView(frame: .zero)
        feedbackInput.text = "Feedback..."
        feedbackInput.font = textFont
        feedbackInput.textColor = UIColor.lightGray
        feedbackInput.textAlignment = .left
        feedbackInput.layer.borderColor = UIColor.black.cgColor
        feedbackInput.layer.borderWidth = borderWidth
        feedbackInput.delegate = self
        feedbackInput.tintColor = .blue
        self.containerView.addSubview(feedbackInput)
    }
    
    private func customizeSubmitFeedbackButton(){
        let fontSize = UIScreen.main.bounds.width * 0.045
        let buttonFont = UIFont (name: "GillSans-SemiBold", size: fontSize)
        let buttonBackgroundColor = UIColor.init(red: 223/255, green: 0/255, blue: 46/255, alpha: 1)
        let cornerRadius = UIScreen.main.bounds.height * 0.01
        submitFeedbackButton = UIButton(frame: .zero)
        submitFeedbackButton.setTitle("Submit Feedback", for: .normal)
        submitFeedbackButton.backgroundColor = buttonBackgroundColor
        submitFeedbackButton.layer.cornerRadius = cornerRadius
        submitFeedbackButton.titleLabel?.font = buttonFont
        submitFeedbackButton.addTarget(self, action: #selector(SubmitFeedback), for: .touchUpInside)
        self.containerView.addSubview(submitFeedbackButton)
    }
    
    private func constrainTopLogo(){
        let padding = UIScreen.main.bounds.width * 0.05
        let topLogoPadding: UIEdgeInsets = .init(top: padding, left: padding, bottom: 0, right: padding)
        
        topLogo.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor,height: containerView.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.2), padding: topLogoPadding)

    }
    
    private func constrainTopLabel(){
        let padding = UIScreen.main.bounds.width * 0.05
        let topLabelPadding: UIEdgeInsets = .init(top: 0, left: padding, bottom: 0, right: padding)
        topLabel.anchor(top: topLogo.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, height: containerView.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.25), padding: topLabelPadding)
    }
    
    private func constrainFeedbackInputField(){
        let padding = UIScreen.main.bounds.width * 0.05
        let feedbackInputPadding: UIEdgeInsets = .init(top: 0, left: padding, bottom: 0, right: padding)
        feedbackInput.anchor(top: topLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, height: containerView.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.25), padding: feedbackInputPadding)
    }
    
    private func constrainSubmitFeedbackButton(){
        let verticalPadding = UIScreen.main.bounds.width * 0.075
        let horizantalPadding = UIScreen.main.bounds.width * 0.1

        let feedbackButtonPadding: UIEdgeInsets = .init(top: verticalPadding, left: horizantalPadding, bottom: verticalPadding, right: horizantalPadding)
        submitFeedbackButton.anchor(top: feedbackInput.bottomAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: feedbackButtonPadding)
    }
    
    
    @objc func resignResponder(){
        feedbackInput.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Feedback..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc func SubmitFeedback(){
        closeMe()
        delegate.sendFeedback(feedback: feedbackInput.text)
    }
    
    override func closeMe() {
        super.closeMe()
        feedbackInput.text = ""
        feedbackInput.resignFirstResponder()
    }
}
