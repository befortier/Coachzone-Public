import UIKit
import Foundation

class FavoriteTeamSection: UIView{
    private let fontSize = UIScreen.main.bounds.width * 0.045
    private var favoriteTeamLabel: AutoAdjustedLabel!
    private var logoContainer: CircleView!
    private var logoImage: UIImageView!
    private var teamNameLabel: AutoAdjustedLabel!
    var team: NFLTeam!
    
    init(team: NFLTeam){
        self.team = team
        super.init(frame:.zero)
        customizeSubViews()
        constrainSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeSubViews(){
        customizeFavoriteTeamLabel()
        customizeLogoContainer()
        customizeLogoImage()
        customizeTeamNameLabel()
    }
    
    private func constrainSubViews(){
        constrainFavoriteTeamLabel()
        constrainLogoContainer()
        constrainLogoImage()
        constrainTeamNameLabel()
    }
    
    private func customizeFavoriteTeamLabel(){
        favoriteTeamLabel = AutoAdjustedLabel(numberOfLines: 1, fontSize: fontSize, text: "Favorite Team", color: .lightGray, notBold: true)
        favoriteTeamLabel.textAlignment = .left
        self.addSubview(favoriteTeamLabel)
    }
    private func customizeLogoContainer(){
        logoContainer = CircleView()
        self.addSubview(logoContainer)
    }
    private func customizeLogoImage(){
        logoImage = UIImageView()
        logoImage.contentMode = .scaleAspectFit
        logoImage.image = team.logo
        logoContainer.addSubview(logoImage)
    }
    private func customizeTeamNameLabel(){
        teamNameLabel = AutoAdjustedLabel(numberOfLines: 1, fontSize: fontSize, text: team.getFullName(), color: .white)
        teamNameLabel.textAlignment = .left
        self.addSubview(teamNameLabel)
    }
    
    private func constrainFavoriteTeamLabel(){
        favoriteTeamLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, height: self.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.15))
    }
    private func constrainLogoContainer(){
        let verticalPadding = UIScreen.main.bounds.height * 0.025
        let leftPadding = UIScreen.main.bounds.width * 0.04
        let logoContainerPadding: UIEdgeInsets = .init(top: verticalPadding, left: leftPadding, bottom: verticalPadding, right: 0)
        logoContainer.anchor(top: favoriteTeamLabel.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, width: self.logoContainer.heightAnchor, sizeMultiplier: .init(width: 1.0, height: 0), padding: logoContainerPadding)

    }
    private func constrainLogoImage(){
        let padding = UIScreen.main.bounds.height * 0.015
        let logoImagePadding: UIEdgeInsets = .init(top: padding, left: padding, bottom: padding, right: padding)
        logoImage.anchor(equalTo: logoContainer, padding: logoImagePadding, sizeMultiplier: .zero)
    }
    private func constrainTeamNameLabel(){
        let leftPadding = UIScreen.main.bounds.width * 0.06
        let userNameLabelPadding:UIEdgeInsets = .init(top: 0, left: leftPadding, bottom: 0, right: 0)
        teamNameLabel.anchor(top: self.topAnchor, leading: logoContainer.trailingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: userNameLabelPadding)

    }
    
    //Takes an NFLTeam and updates the image and name associated with users favorite team
    func configureUI(team: NFLTeam){
        self.team = team
        DispatchQueue.main.async {
            self.logoImage.image = self.team.logo
            self.teamNameLabel.text = self.team.getFullName()
            self.layoutSubviews()
        }
    }
}
