//
//  ExerciseSetCell.swift
//  WorkoutTracker
//
//  Created by Dakota Chatt on 2022-03-23.
//

import UIKit

class ExerciseSetCell: UITableViewCell {

    @IBOutlet weak var setField: UITextField!
    @IBOutlet weak var repDurationField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
