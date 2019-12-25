import UIKit
import Foundation

class DimView: UIView{
    var containerView: UIView!
    init(){
        super.init(frame: .zero)
        customizeSelf()
        customizeContainerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeSelf(){
        self.isHidden = false
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.addSubview(self)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.anchor(equalTo: currentWindow!)
       
    }
    private func customizeContainerView(){
        containerView = UIView()
        self.addSubview(containerView)
        self.anchor(equalTo: self)
    }
    
    func dim(){
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
    
    func unDim(){
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0

        }
    }
}
