//
//  NoPhotoCustomCell.swift
//  Follow Your Reps
//
//  Created by Jared Milos on 11/21/18.
//  Copyright © 2018 Jared Milos. All rights reserved.
//

import UIKit

protocol NoPhotoCustomCellDelegate {
    func NPtwitterIconPressed(at indexPath: NSIndexPath?)
}

class NoPhotoCustomCell: UITableViewCell {
    var NPdelegate: NoPhotoCustomCellDelegate?
    var indexPath: NSIndexPath?

    @IBOutlet weak var NPButtonOutlet: UIButton!
    @IBOutlet weak var NPRepLabelName: UILabel!
    @IBOutlet weak var NPPositionName: UILabel!
    
    @IBAction func NPTwitterButtonPressed(_ sender: UIButton) {
        NPdelegate?.NPtwitterIconPressed(at: indexPath)
    }
}
