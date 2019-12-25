import UIKit
import Foundation
import SkyFloatingLabelTextField

class Validate: NSObject {

    let field: TextFieldCheckView!
    init(field: TextFieldCheckView){
        self.field = field
        super.init()
    }
    

    
    func isFilled(showErrorMessage: Bool = false) -> Bool{
        if let text = field.textField.text{
            if text.count == 0 && showErrorMessage{
                field.textField.handleError(message: "Required Field")
            }
            return text.count > 0
        }
        return false
    }
    
    
    func isEmailValid() -> Bool {
        if let email = field.textField.text{
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: email)
        }
        return false
    }
    
    func getPasswordVunerability() -> String{
            var errorMsg: String = ""
            if let text = field.textField.text{
                if text.count < 8 {
                    errorMsg = "Requires eight characters"
                }
                else if text.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil {
                    errorMsg = "Requires one upper case letter"
                }
                else if text.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil {
                    errorMsg = "Requires one lower case letter"
                }
                else if text.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil {
                    errorMsg = "Requires one number"
                }
                
        }
            return errorMsg
        }



func format(phoneNumber sourcePhoneNumber: String) -> String? {
    let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    let length = numbersOnly.count
    let hasLeadingOne = numbersOnly.hasPrefix("1") && length > 10

    guard length > 9 else{
        return "Include Area, Country Code"
    }
    
    guard length < 12 else{
        return "Phone numbers are not that long..."
    }
    
    
    let hasAreaCode = (length >= 10)
    var sourceIndex = 0
    
    // Leading 1
    let leadingOne = "1"
    if hasLeadingOne{
        sourceIndex += 1
    }
    
    // Area code
    var areaCode = ""
    if hasAreaCode {
        let areaCodeLength = 3
        guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
            return nil
        }
        areaCode = String(format: "%@", areaCodeSubstring)
        sourceIndex += areaCodeLength
    }
    
    // Prefix, 3 characters
    let prefixLength = 3
    guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
        return nil
    }
    sourceIndex += prefixLength
    
    // Suffix, 4 characters
    let suffixLength = 4
    guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
        return nil
    }
    
    let returnString = "+" + leadingOne + areaCode + prefix  + suffix
    return returnString
}
    
}

extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}
