import UIKit
import Foundation

class AbstractPopup: UIView{
    let cornerRadius = UIScreen.main.bounds.height * 0.02
    var doneButton: UIButton!
    var cancelButton: UIButton!
    var containerView: UIView!
    var titleLabel: AutoAdjustedLabel!
    private var titleString: String
    var dimView: DimView!

    init(title: String){
        self.titleString = title
        super.init(frame: .zero)
        customizeSubviews()
        constrainSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeSubviews(){
        customizeSelf()
        customizeContainerView()
        customizeDoneButton()
        customizeCancelButton()
        customizeTopLabel()
  
    }
    
    
    private func constrainSubviews(){
        constrainDoneButton()
        constrainCancelButton()
        constrainTopLabel()
        constrainContainerView()
    }
    
    private func customizeSelf(){
        let darkGray = UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        self.backgroundColor = darkGray
        self.layer.cornerRadius = cornerRadius
    }
    
    private func customizeContainerView(){
        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = cornerRadius
        self.addSubview(containerView)
    }
    
    private func customizeDoneButton(){
        doneButton = UIButton(frame: .zero)
        let doneImage = UIImage(named: "Confirm")
        doneButton.setImage(doneImage, for: .normal)
        self.addSubview(doneButton)
    }
    
    private func customizeCancelButton(){
        cancelButton = UIButton(frame: .zero)
        let cancelImage = UIImage(named: "Cancel")
        cancelButton.setImage(cancelImage, for: .normal)
        cancelButton.addTarget(self, action: #selector(closeMe), for: .touchUpInside)
        self.addSubview(cancelButton)
    }
    
    private func customizeTopLabel(){
        let fontSize = UIScreen.main.bounds.width * 0.06
        titleLabel = AutoAdjustedLabel(numberOfLines: 1, fontSize: fontSize, text: titleString, color: .white, notBold: false)
        self.addSubview(titleLabel)
    }
    
    private func constrainContainerView(){
        let padding = UIScreen.main.bounds.width * 0.02
        let containerViewPadding:UIEdgeInsets = .init(top: 0, left: padding, bottom: padding, right: padding)
        containerView.anchor(top: titleLabel.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: containerViewPadding)
    }
    
    private func constrainDoneButton(){
        let rightPadding = UIScreen.main.bounds.width * 0.02
        let doneButtonPadding:UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: rightPadding)
        doneButton.anchor(top: self.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, height: self.heightAnchor, width: doneButton.heightAnchor, sizeMultiplier: .init(width: 1.0, height: 0.1), padding: doneButtonPadding)
    }
    
    private func constrainCancelButton(){
        let leftPadding = UIScreen.main.bounds.width * 0.02
        let cancelButtonPadding:UIEdgeInsets = .init(top: 0, left: leftPadding, bottom: 0, right: 0)
        cancelButton.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, height: self.heightAnchor, width: doneButton.heightAnchor, sizeMultiplier: .init(width: 1.0, height: 0.1),padding: cancelButtonPadding)
    }
    
    private func constrainTopLabel(){
        titleLabel.anchor(top: self.topAnchor, leading: cancelButton.trailingAnchor, bottom: cancelButton.bottomAnchor, trailing: doneButton.leadingAnchor)
    }
    
    //Shows the popup
    public func showPopup(){
        self.isHidden = false
        dimView = DimView()
        dimView.dim()
        constrainSelf()
    }
    
    func constrainSelf(){
        dimView.containerView.addSubview(self)
        let verticalOffset = UIScreen.main.bounds.height * 0.15
        let horizantalOffset = UIScreen.main.bounds.width * 0.1
        let containerPadding: UIEdgeInsets = .init(top: verticalOffset, left: horizantalOffset, bottom: verticalOffset, right: horizantalOffset)
        dimView.containerView.anchor(equalTo: dimView, padding: containerPadding, sizeMultiplier: .zero)
        self.anchor(equalTo: dimView.containerView)
    }
    
    //Closes the popup
    @objc func closeMe(){
        dimView.unDim()
        self.isHidden = true
    }
}
