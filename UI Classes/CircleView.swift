import Foundation
import UIKit

class CircleView: UIView {
    var shouldBeWhite: Bool? = true
    init(shouldBeWhite: Bool? = true){
        self.shouldBeWhite = shouldBeWhite
        super.init(frame:.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shouldBeWhite!{
            self.backgroundColor = .white
        }
        let radius: CGFloat = self.bounds.size.width / 2.0
        
        self.layer.cornerRadius = radius
    }
}

class CircleImage: UIImageView{
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
