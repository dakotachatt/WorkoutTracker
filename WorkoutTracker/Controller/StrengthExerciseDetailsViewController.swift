//
//  StrengthExerciseDetailsViewController.swift
//  WorkoutTracker
//
//  Created by Dakota Chatt on 2022-03-22.
//

import UIKit

class StrengthExerciseDetailsViewController: UIViewController {

    var exerciseDetailsSets : [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var exerciseDetailsReps : [Int] = [8, 8, 8, 8, 8, 8, 8, 8, 8, 8]
    var exerciseDetailsWeight: [Int] = [40, 40, 40, 40, 40, 40, 40, 40, 40, 40]
    var selectedExercise : Exercise? {
        didSet {
            //XXXXXXXXXXXXXXXXX Add code if needed, delete otherwise
        }
    }
    
    @IBOutlet weak var setDetailsTableView: UITableView!
    @IBOutlet weak var exerciseNotesTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetailsTableView.dataSource = self
        self.title = selectedExercise!.name!
        setDetailsTableView.register(UINib(nibName: "ExerciseSetCell", bundle: nil), forCellReuseIdentifier: "setDetailsCell")
//        self.hideKeyboardTapOutside()
        exerciseNotesTextField.layer.borderWidth = 0.5
        exerciseNotesTextField.layer.borderColor = UIColor.gray.cgColor
        exerciseNotesTextField.layer.cornerRadius = 5.0
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
    }
}

//MARK: - setDetailsTableView Datasource Methods
extension StrengthExerciseDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseDetailsSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setDetailsTableView.dequeueReusableCell(withIdentifier: "setDetailsCell", for: indexPath) as! ExerciseSetCell
        cell.setField.text = String(exerciseDetailsSets[indexPath.row])
        cell.repDurationField.text = String(exerciseDetailsReps[indexPath.row])
        cell.weightField.text = String(exerciseDetailsWeight[indexPath.row])
        
        return cell
    }
}

//MARK: - Keyboard hiding methods
//extension UIViewController {
//    func hideKeyboardTapOutside() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard()))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}
