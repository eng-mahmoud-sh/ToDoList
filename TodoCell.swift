//
//  TodoCell.swift
//  ToDoList
//
//  Created by Apple on 30/10/2023.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var todoTitle:UILabel!
    
    @IBOutlet weak var todoDate: UILabel!
    
    @IBOutlet weak var todoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
