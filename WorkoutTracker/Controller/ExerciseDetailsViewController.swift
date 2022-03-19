//
//  ExerciseDetailsViewController.swift
//  WorkoutTracker
//
//  Created by Dakota Chatt on 2022-03-19.
//

import UIKit

class ExerciseDetailsViewController: UIViewController {

    @IBOutlet weak var exerciseName: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var setsDistanceField: UITextField!
    @IBOutlet weak var repsTimeField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedRoutine : Routine? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedRoutine!.name!)
    }
    
    //MARK: - View Field Placeholder Methods
    @IBAction func segmentControlToggled(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        //Tag 0 is for strength related workouts
        case 0:
            setsDistanceField.placeholder = "Sets"
            repsTimeField.placeholder = "Reps"
            weightField.isHidden = false
            break
        //Tag 1 is for cardio related workouts
        case 1:
            setsDistanceField.placeholder = "Distance"
            repsTimeField.placeholder = "Time"
            weightField.isHidden = true
            break
        default:
            break
        }
    }
    
    //MARK: - Add Exercise Methods
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let newExercise = Exercise(context: self.context)
        
        if(exerciseName.text == "") {
            let alert = UIAlertController(title: "Error", message: "Please enter at least one character in the exercise name", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            newExercise.name = exerciseName.text!
            newExercise.type = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
            newExercise.parentRoutine = self.selectedRoutine
            
            self.saveExercise()
            self.performSegue(withIdentifier: "unwindToExercise", sender: self)
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveExercise() {
        do {
            try context.save()
        } catch {
            print("Error saving exercise: \(error)")
        }
    }
}
