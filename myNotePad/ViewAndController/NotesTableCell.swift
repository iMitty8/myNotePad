//
//  NotesTableCell.swift
//  myNotePad
//
//  Created by Mithun R on 14/04/18.
//  Copyright © 2018 Mithun R. All rights reserved.
//

import UIKit

class NotesTableCell: UITableViewCell {


    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellData(title:String, content:String) {
        self.titleLbl.text = title
        self.contentLbl.text = content
    }

}
