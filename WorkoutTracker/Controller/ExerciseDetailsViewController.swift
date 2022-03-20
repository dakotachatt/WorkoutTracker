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
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedRoutine : Routine? = nil
    var typeSelected : String = ""
    var categorySelected : String = ""
    
    let typePickerOptionsStrength : [String] = ["Bodyweight", "Single Dumb Bell", "Double Dumb Bells", "Bar Bell", "Machine", "Yoga", "Other"]
    let typePickerOptionsCardio : [String] = ["Indoor Walk", "Indoor Run", "Outdoor Walk", "Outdoor Run", "Elliptical", "Rowing Machine", "Swimming", "Indoor Cycling", "Outdoor Cycling", "Jump Rope", "Video Games"]
    let categoryPickerOptionsStrength : [String] = ["Full Body", "Chest", "Upper Back", "Lower Back", "Shoulders", "Biceps", "Triceps", "Forearms", "Abdominals", "Glutes", "Thighs", "Calves", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.typePicker.delegate = self
        self.categoryPicker.delegate = self
        self.typePicker.dataSource = self
        self.categoryPicker.dataSource = self
        
        print(selectedRoutine!.name!)
    }
    
    //MARK: - View Field Placeholder Methods
    @IBAction func segmentControlToggled(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        //Tag 0 is for strength related workouts
        case 0:
            categoryLabel.isHidden = false
            categoryPicker.isHidden = false
            resetAllExerciseDetailsPickerViews()
            break
        //Tag 1 is for cardio related workouts
        case 1:
            categoryLabel.isHidden = true
            categoryPicker.isHidden = true
            resetAllExerciseDetailsPickerViews()
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
            newExercise.umbrellaType = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
            newExercise.name = exerciseName.text!
            newExercise.type = typeSelected
            
            switch segmentControl.selectedSegmentIndex {
            //Tag 0 is for strength related workouts
            case 0:
                newExercise.category = categorySelected
                break
            //Tag 1 is for cardio related workouts
            case 1:
                newExercise.category = "Cardio"
                break
            default:
                print("Error occurred with category assignment")
                break
            }
            
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

//MARK: - Picker View Methods
extension ExerciseDetailsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0) {
            switch segmentControl.selectedSegmentIndex {
            //Tag 0 is for strength related workouts
            case 0:
                return typePickerOptionsStrength.count
            //Tag 1 is for cardio related workouts
            case 1:
                return typePickerOptionsCardio.count
            default:
                return 0
            }
        } else if (pickerView.tag == 1) {
            return categoryPickerOptionsStrength.count
        }
        
        return 0
    }
    
    func resetAllExerciseDetailsPickerViews() {
        typePicker.reloadAllComponents()
        categoryPicker.reloadAllComponents()
        typePicker.selectRow(0, inComponent: 0, animated: false)
        categoryPicker.selectRow(0, inComponent: 0, animated: false)
    }
}

extension ExerciseDetailsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            switch segmentControl.selectedSegmentIndex {
            //Tag 0 is for strength related workouts
            case 0:
                return self.typePickerOptionsStrength[row]
            //Tag 1 is for cardio related workouts
            case 1:
                return self.typePickerOptionsCardio[row]
            default:
                return "Could not Retrieve"
            }
        } else if (pickerView.tag == 1) {
            return self.categoryPickerOptionsStrength[row]
        }
        
        return "Could not Retrieve"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0) {
            switch segmentControl.selectedSegmentIndex {
            //Tag 0 is for strength related workouts
            case 0:
                typeSelected = self.typePickerOptionsStrength[row]
                break
            //Tag 1 is for cardio related workouts
            case 1:
                typeSelected = self.typePickerOptionsCardio[row]
                break
            default:
                break
            }
        } else if (pickerView.tag == 1) {
            categorySelected = self.categoryPickerOptionsStrength[row]
        }
    }
}
