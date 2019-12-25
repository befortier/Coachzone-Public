import UIKit
import Foundation

class TeamCell: UITableViewCell{
    var cellView: TeamCellView!
    var team: NFLTeam!
    var isFavorite = false{
        didSet{
            if isFavorite {
                self.cellView.backgroundColor = .lightGray
                self.cellView.nameLabel.textColor = .white
            }
            else{
                self.cellView.backgroundColor = .white
                self.cellView.nameLabel.textColor = .black
            }
            self.cellView.logoImageContainer.backgroundColor = .white

        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initCellView()
        customizeSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initCellView(){
        cellView = TeamCellView()
        self.contentView.addSubview(cellView)
        cellView.anchor(equalTo: self.contentView)
    }
    
    private func customizeSelf(){
        if isFavorite {
            self.backgroundColor = .lightGray
            self.cellView.backgroundColor = .lightGray
            self.cellView.nameLabel.textColor = .white
        }
    }
    
    func configure(team: NFLTeam){
        DispatchQueue.main.async {
            self.team = team
            self.cellView.nameLabel.text = team.getFullName()
            self.cellView.logoImage.image = team.logo
        }
    }
    
}

class TeamCellView: UIView{
    let fontSize = UIScreen.main.bounds.width * 0.045
    var logoImageContainer: CircleView!
    var logoImage: UIImageView!
    var nameLabel: AutoAdjustedLabel!
    var team: NFLTeam!
    
    init() {
        super.init(frame: .zero)
        customizeViews()
        constrainViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeViews(){
        customizeSelf()
        customizeLogoImageContainer()
        customizeLogoImage()
        customizeNameLabel()
    }
    
    private func constrainViews(){
        constrainLogoImageContainer()
        constrainLogoImage()
        constrainNameLabel()
    }
    
    private func customizeSelf(){
        self.backgroundColor = .white
    }
    
    private func customizeLogoImageContainer(){
        logoImageContainer = CircleView()
        self.addSubview(logoImageContainer)
    }
    
    private func customizeLogoImage(){
        logoImage = UIImageView()
        logoImage.contentMode = .scaleAspectFit
        logoImageContainer.addSubview(logoImage)
    }
    
    private func customizeNameLabel(){
        nameLabel = AutoAdjustedLabel(numberOfLines: 1, fontSize: fontSize, text: "", color: .black, notBold: true)
        nameLabel.textAlignment = .left
        self.addSubview(nameLabel)
    }
    
    private func constrainLogoImage(){
        let padding = UIScreen.main.bounds.height * 0.01
        let logoImagePadding: UIEdgeInsets = .init(top: padding, left: padding, bottom: padding, right: padding)
        logoImage.anchor(equalTo: logoImageContainer, padding: logoImagePadding, sizeMultiplier: .zero)
    }

  
    
    private func constrainLogoImageContainer(){
        let verticalPadding = UIScreen.main.bounds.height * 0.0055
        let leftPadding = UIScreen.main.bounds.width * 0.053
        let profilePicturePadding: UIEdgeInsets = .init(top: verticalPadding, left: leftPadding, bottom: verticalPadding, right: 0)
        logoImageContainer.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, width: logoImageContainer.heightAnchor, sizeMultiplier: .init(width: 1.0, height: 0), padding: profilePicturePadding)
    }
    
    private func constrainNameLabel(){
        let leftPadding = UIScreen.main.bounds.width * 0.08
        let nameLabelPadding:UIEdgeInsets = .init(top: 0, left: leftPadding, bottom: 0, right: 0)
        nameLabel.anchor(top: self.topAnchor, leading: logoImage.trailingAnchor, bottom: self.bottomAnchor, trailing: nil, width: self.widthAnchor, sizeMultiplier: .init(width: 0.5, height: 0), padding: nameLabelPadding)
    }
    
}
