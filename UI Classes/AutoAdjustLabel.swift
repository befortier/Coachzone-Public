import UIKit
import Foundation


class AutoAdjustedLabel: UILabel{
    
    
    init(numberOfLines: Int, fontSize: CGFloat, text: String = "", color:UIColor = UIColor.white, notBold:Bool = false){
        var font = UIFont (name: "GillSans-SemiBold", size: fontSize)
        if notBold {
            font = UIFont (name: "GillSans", size: fontSize)
        }
        super.init(frame: .zero)
        self.textColor = color
        self.text = text
        self.font = font
        self.adjustsFontSizeToFitWidth = true
        self.numberOfLines = numberOfLines
        self.minimumScaleFactor = 0.2
        self.clipsToBounds = true;
        self.textAlignment = .center
        self.baselineAdjustment = .alignBaselines
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
