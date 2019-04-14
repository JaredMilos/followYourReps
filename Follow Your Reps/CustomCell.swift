//
//  CustomCell.swift
//  Follow Your Reps
//
//  Created by Jared Milos on 11/19/18.
//  Copyright © 2018 Jared Milos. All rights reserved.
//

import UIKit

protocol CustomCellDelegate {
    func twitterIconPressed(at indexPath: NSIndexPath?)
}

class CustomCell: UITableViewCell {
    var delegate: CustomCellDelegate?
    var indexPath: NSIndexPath?
    
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var repNameLabel: UILabel!
    @IBOutlet weak var repPositionLabel: UILabel!
    @IBOutlet weak var repImage: UIImageView!
    @IBAction func twitterIconPressed(_ sender: UIButton) {
        delegate?.twitterIconPressed(at: indexPath)
    }
    
}
