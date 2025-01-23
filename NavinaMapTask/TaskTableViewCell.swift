//
//  TaskTableViewCell.swift
//  NavinaMapTask
//
//  Created by selvarani on 22/01/25.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        cardview()
        // Initialization code
    }
    func cardview(){
        mainView.layer.cornerRadius = 20.0
        mainView.layer.shadowColor = UIColor.gray.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        mainView.layer.shadowRadius = 12.0
        mainView.layer.shadowOpacity = 0.7
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
