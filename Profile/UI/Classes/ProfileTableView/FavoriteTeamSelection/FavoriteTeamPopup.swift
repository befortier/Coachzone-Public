import UIKit
import Foundation

protocol FavoriteTeamPopupDelegate: class {
    func updateChoice(team: NFLTeam)
    func cancelChoice(sender: FavoriteTeamPopup)
}

class FavoriteTeamPopup: AbstractPopup, UITableViewDelegate, UITableViewDataSource{
    var delegate: FavoriteTeamPopupDelegate!
    var teams = NFLTeams().teams
    var tableView: UITableView!
    private let reuseIdentifier = "TeamCell"
    var logo: UIImageView!
    var favorite_team: NFLTeam
    private var oldFavorite:TeamCell!
    private var focusedIndex: IndexPath!
    init(favorite_team: NFLTeam) {
        self.favorite_team = favorite_team
        super.init(title: "Favorite Team")
        customizeSubviews()
        constrainSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func customizeSubviews(){
        customizeSelf()
        customizeLogoView()
        customizeTableView()
        customizeButtonActions()
    }
    
    
    private func constrainSubviews(){
        constrainLogoView()
        constrainTableView()
    }
    private func customizeSelf(){
        let darkGray = UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        self.backgroundColor = darkGray
        self.layer.cornerRadius = cornerRadius
    }
    
    private func customizeLogoView(){
        logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.image = favorite_team.logo
        containerView.addSubview(logo)
    }
    private func customizeTableView(){
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        let whiteBackground = UIView()
        whiteBackground.backgroundColor = .white
        tableView.backgroundView = whiteBackground
        tableView.register(TeamCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.layer.cornerRadius = cornerRadius
        tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        containerView.addSubview(tableView)
        setFocusedIndex()
    }
    
    private func customizeButtonActions(){
        self.doneButton.addTarget(self, action: #selector(updateChoice), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(cancelChoice), for: .touchUpInside)
    }
    
    func setFocusedIndex(){
        var row = favorite_team.id - 2
        if row < 0{
            row = 0
        }
        focusedIndex = IndexPath(row: row, section: 0)
        tableView.scrollToRow(at: focusedIndex, at: .top, animated: true)
    }
    
    
    private func constrainLogoView(){
        let logoHorizantalPadding = UIScreen.main.bounds.width * 0.1
        let logoPadding: UIEdgeInsets = .init(top: 0, left: logoHorizantalPadding, bottom: 0, right: logoHorizantalPadding)
        logo.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, height: containerView.heightAnchor, sizeMultiplier: .init(width: 0, height: 0.3), padding: logoPadding)
    }
    private func constrainTableView(){
        tableView.anchor(top: logo.bottomAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor)
    }
    

    @objc func updateChoice(){
        closeMe()
        delegate.updateChoice(team: self.favorite_team)
    }
    
    @objc func cancelChoice(){
        closeMe()
        delegate.cancelChoice(sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TeamCell
        let team = teams[indexPath.row]
        cell.configure(team: team)
        if team.id == favorite_team.id{
            cell.isFavorite = true
            oldFavorite = cell
        }
        else{
            cell.isFavorite = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight:CGFloat = UIScreen.main.bounds.height * 0.08
        
        return cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TeamCell
        let selectedTeam = cell.team!
        self.favorite_team = selectedTeam
        self.logo.image = selectedTeam.logo
        if oldFavorite != nil{
            oldFavorite.isFavorite = false
        }
        oldFavorite = cell
        cell.isFavorite = true
        focusedIndex = indexPath
    }
    
 

    
 
}

