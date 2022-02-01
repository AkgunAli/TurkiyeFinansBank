//
//  DocumentListCell.swift
//  TurkiyeFinansBank
//
//  Created by Ali Akgün on 31.01.2022.
//

import UIKit

class DocumentListCell: UITableViewCell {
    let nibName = "DocumentListCell"
    @IBOutlet weak var documentImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistType: UILabel!
    @IBOutlet weak var artistKind: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
