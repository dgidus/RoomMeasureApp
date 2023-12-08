//
//  ChangeUnitsViewController.swift
//  RoomMeasureApp
//
//

import UIKit

protocol ChangeUnitsViewControllerDelegate {
    func unitsChanged(distanceUnits: String)
}

class ChangeUnitsViewController: UIViewController {
    
    @IBOutlet weak var distanceUnitsLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var pickerDist: UIPickerView!
    
    var pickerDistData: [String] = [String]()
    let dataForDistPicker = ["Meters", "Feet"]
    var selectionDist: String = "Meters"
    var delegate: ChangeUnitsViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerDistData = dataForDistPicker
        self.pickerDist.delegate = self
        self.pickerDist.dataSource = self
        
        if let index = self.pickerDistData.firstIndex(of: self.selectionDist) {
            self.pickerDist.selectRow(index, inComponent: 0, animated: true)
        } else {
            self.pickerDist.selectRow(0, inComponent: 0, animated:true)
        }
        
        self.pickerDist.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(distanceUnitsLabelTapped))
        self.distanceUnitsLabel.addGestureRecognizer(tapGesture)
        
        self.distanceUnitsLabel.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChangeUnitsViewController.dismissPicker))
        
        view.addGestureRecognizer(tap)
        
        distanceUnitsLabel.text = self.selectionDist
    }
    
    @objc func dismissPicker() {
        self.pickerDist.isHidden = true
    }
    
    @objc func distanceUnitsLabelTapped() {
        self.pickerDist.isHidden = false
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let d = self.delegate {
            d.unitsChanged(distanceUnits: selectionDist)
        }
        navigationController?.popViewController(animated: true)
    }

}

extension ChangeUnitsViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDistData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerDistData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectionDist = self.pickerDistData[row]
        distanceUnitsLabel.text = self.pickerDistData[row]
    }
}
