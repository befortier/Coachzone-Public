import UIKit
import Foundation

class ProfileTableCell: UITableViewCell{
    
    private var icon: UIImageView!
    private var title: AutoAdjustedLabel!
    var info: ProfileTableCellInfo!
    private let fontSize = UIScreen.main.bounds.width * 0.0475

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customizeSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeSubviews(){
        customizeSelf()
        customizeIcon()
        customizeTitle()
    }
    
    private func constrainSubviews(){
        constrainIcon()
        constrainTitle()
    }
    
    private func customizeSelf(){
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    private func customizeIcon(){
        icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .white
        self.addSubview(icon)
    }
    
    private func customizeTitle(){
        title = AutoAdjustedLabel(numberOfLines: 1, fontSize: fontSize, text: "", color: .white, notBold: true)
        title.textAlignment = .left
        self.addSubview(title)
    }
    
    private func constrainIcon(){
        let padding = UIScreen.main.bounds.height * 0.02
        let iconPadding:UIEdgeInsets = .init(top: padding, left: padding, bottom: padding, right: 0)
        icon.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, width: icon.heightAnchor, sizeMultiplier: .init(width: 1.0, height: 0), padding: iconPadding)
    }
    
    private func constrainTitle(){
        let leftPad = UIScreen.main.bounds.width * 0.035
        let titlePadding:UIEdgeInsets = .init(top: 0, left: leftPad, bottom: 0, right: 0)
        title.anchor(top: self.topAnchor, leading: icon.trailingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: titlePadding)
    }
    
    func configure(info: ProfileTableCellInfo){
        DispatchQueue.main.async {
            self.info = info
            self.icon.image = info.logo
            self.title.text = info.title
        }
    }

}
