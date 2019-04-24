//
//  RecTableViewCell.swift
//  RevRecIOS
//
//  Created by Azzy M on 4/23/19.
//  Copyright © 2019 Azzy M. All rights reserved.
//

import UIKit

class RecTableViewCell: UITableViewCell {

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        addSubview(cellView)
        cellView.addSubview(playButton)
        cellView.addSubview(fileLabel)
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        fileLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        fileLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        fileLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        fileLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 100).isActive = true
        
        playButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        playButton.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        playButton.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 0).isActive = true
    }
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        //view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let fileLabel: UILabel = {
        let label = UILabel()
        label.text = "Recording"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
}
