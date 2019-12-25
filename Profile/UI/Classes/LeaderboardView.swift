import UIKit
import Foundation

class LeaderboardView: UIView{
    private let fontSize = UIScreen.main.bounds.width * 0.04
    private var leaderboardLabel: AutoAdjustedLabel!
    private var franchiseLabel: AutoAdjustedLabel!
    private var overallLabel: AutoAdjustedLabel!
    private var franchisePlaceLabel: AutoAdjustedLabel!
    private var overallPlaceLabel: AutoAdjustedLabel!
    private var user: User

    
    init(user: User){
        self.user = user
        super.init(frame:.zero)
        customizeSubViews()
        constrainSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeSubViews(){
        customizeLeaderboardLabel()
        customizeFranchiseLabel()
        customizeOverallLabel()
        customizeFranchisePlaceLabel()
        customizeOverallPlaceLabel()
    }
    
    private func constrainSubViews(){
        constrainLeaderboardLabel()
        constrainFranchiseLabel()
        constrainOverallLabel()
        constrainFranchisePlaceLabel()
        constrainOverallPlaceLabel()
    }
    
    private func customizeLeaderboardLabel(){
        leaderboardLabel = AutoAdjustedLabel(numberOfLines: 1, fontSize: fontSize, text: "Leaderboard", color: .lightGray, notBold: true)
        leaderboardLabel.textAlignment = .left
        self.addSubview(leaderboardLabel)
        
    }
    private func customizeFranchiseLabel(){
        franchiseLabel = AutoAdjustedLabel(numberOfLines: 1, fontSize: fontSize, text: "Franchise", color: .white, notBold: true)
        franchiseLabel.textAlignment = .left
        self.addSubview(franchiseLabel)
    }
    private func customizeOverallLabel(){
        overallLabel = AutoAdjustedLabel(numberOfLines: 1, fontSize: fontSize, text: "Overall", color: .white, notBold: true)
        overallLabel.textAlignment = .left
        self.addSubview(overallLabel)
    }
    private func customizeFranchisePlaceLabel(){
        let franchisePlace = "124th place"
        franchisePlaceLabel = AutoAdjustedLabel(numberOfLines: 1, fontSize: fontSize * 1.1, text: franchisePlace, color: .white, notBold: false)
        franchisePlaceLabel.textAlignment = .right
        self.addSubview(franchisePlaceLabel)
    }
    private func customizeOverallPlaceLabel(){
        let overallPlace = "1,735th place"
        overallPlaceLabel = AutoAdjustedLabel(numberOfLines: 1, fontSize: fontSize * 1.1, text: overallPlace, color: .white, notBold: false)
        overallPlaceLabel.textAlignment = .right
        self.addSubview(overallPlaceLabel)
    }
    private func constrainLeaderboardLabel(){
        leaderboardLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, height: self.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.25))

    }
    private func constrainFranchiseLabel(){
        let topPad = UIScreen.main.bounds.height * 0.005
        let franchiseLabelPadding: UIEdgeInsets = .init(top: topPad, left: 0, bottom: 0, right: 0)
        franchiseLabel.anchor(top: leaderboardLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, height: self.heightAnchor, width: self.widthAnchor, sizeMultiplier: .init(width: 0.5, height: 0.4), padding: franchiseLabelPadding)
    }
    private func constrainOverallLabel(){
        overallLabel.anchor(top: franchiseLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: franchiseLabel.trailingAnchor, height: self.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.35))
    }
    private func constrainFranchisePlaceLabel(){
        let rightOffset = UIScreen.main.bounds.width * 0.02
        let franchisePlaceLabelPadding: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: rightOffset)
        franchisePlaceLabel.anchor(top: franchiseLabel.topAnchor, leading: franchiseLabel.trailingAnchor, bottom: franchiseLabel.bottomAnchor, trailing: self.trailingAnchor, padding: franchisePlaceLabelPadding)
    }
    private func constrainOverallPlaceLabel(){
        overallPlaceLabel.anchor(top: franchisePlaceLabel.bottomAnchor, leading: franchisePlaceLabel.leadingAnchor, bottom: overallLabel.bottomAnchor, trailing: franchisePlaceLabel.trailingAnchor)
    }
    
    //Takes in the franchise and total place and updates the text
    func configureUI(franchise_place: Int, total_place: Int){
        self.franchisePlaceLabel.text = intToString(franchise_place)
        self.overallPlaceLabel.text = intToString(total_place)
    }
    
    //Turns an int into the place neccesary
    func intToString(_ val: Int) -> String{
        var return_val = val.toFormattedString() ?? String(val)
        if val <= 0{
            return "No Points Scored"
        }
        else if val == 1{
            return_val += "st"
        }
        else if val == 2{
            return_val += "nd"
        }
        else if val == 3{
            return_val += "rd"
        }
        else{
            return_val += "th"
        }
        return return_val + " Place"
    }
    
}
