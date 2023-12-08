//
//  ViewController.swift
//  RoomMeasureApp
//
//

import UIKit
import CoreMotion

class ViewController: UIViewController, ChangeUnitsViewControllerDelegate {
    
    @IBOutlet weak var dimSegment: UISegmentedControl!
    
    @IBOutlet weak var lengthOutputLabel: UILabel!
    @IBOutlet weak var widthOutputLabel: UILabel!
    @IBOutlet weak var heightOutputLabel: UILabel!
    
    @IBOutlet weak var lengthCubeLabel: UILabel!
    @IBOutlet weak var widthCubeLabel: UILabel!
    @IBOutlet weak var heightCubeLabel: UILabel!
    
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    let pedometer = CMPedometer()
    let altimeter = CMAltimeter()
    
    var endingLengthDistance: Double = 0.0
    var endingWidthDistance: Double = 0.0
    var endingHeightDistance: Double = 0.0
    
    var distanceUnitsString = "Meters"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lengthCubeLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 6)

        self.widthCubeLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / -6)
        
        self.heightCubeLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / -2)
        
        self.view.backgroundColor = UIColor(red: 0.56, green: 0.39, blue: 0.39, alpha: 1.00)
    }
    
    @IBAction func startMeasurement(_ sender: UIButton) {
        switch dimSegment.selectedSegmentIndex {
        case 0:
            
            self.endingLengthDistance = 0.0
            pedometer.startUpdates(from: Date()) { pedometerData, error in
                if let distanceData = pedometerData?.distance?.doubleValue {
                    self.endingLengthDistance = distanceData
                }
            }
        case 1:
            
            self.endingWidthDistance = 0.0
            pedometer.startUpdates(from: Date()) { pedometerData, error in
                if let distanceData = pedometerData?.distance?.doubleValue {
                    self.endingWidthDistance = distanceData
                }
            }
        case 2:
            self.endingHeightDistance = 0.0
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { (data, error) in
                if let altimeterData = data?.relativeAltitude.doubleValue {
                    self.endingHeightDistance = altimeterData
                    print(self.endingHeightDistance)
                }
            }
            
        default:
            break
        }
    }
    
    @IBAction func stopMeasurement(_ sender: UIButton) {
        switch dimSegment.selectedSegmentIndex {
        case 0:
            pedometer.stopUpdates()
            
            var endingLengthDistance: Double
            if self.distanceUnitsString == "Meters" {
                endingLengthDistance = round(100 * self.endingLengthDistance) / 100
            } else {
                endingLengthDistance = round(100 * self.endingLengthDistance * 3.28084) / 100
            }
           
            self.lengthOutputLabel.text = String(endingLengthDistance) + " " + self.distanceUnitsString.lowercased()
            self.lengthCubeLabel.text = String(endingLengthDistance)
            
        case 1:
            pedometer.stopUpdates()
            
            var endingWidthDistance: Double
            if self.distanceUnitsString == "Meters" {
                endingWidthDistance = round(100 * self.endingWidthDistance) / 100
            } else {
                endingWidthDistance = round(100 * self.endingWidthDistance * 3.28084) / 100
            }
            self.widthOutputLabel.text = String(endingWidthDistance) + " " + self.distanceUnitsString.lowercased()
            self.widthCubeLabel.text = String(endingWidthDistance)
            
        case 2:
            altimeter.stopRelativeAltitudeUpdates()
            
            var endingHeight: Double
            if self.distanceUnitsString == "Meters" {
                endingHeight = round(100 * self.endingHeightDistance) / 100
            } else {
                endingHeight = round(100 * self.endingHeightDistance * 3.28084) / 100
            }
            self.heightOutputLabel.text = String(endingHeight) + " " + self.distanceUnitsString.lowercased()
            self.heightCubeLabel.text = String(endingHeight)
            
        default:
            break
        }
        
    }
    
    func unitsChanged(distanceUnits: String) {
        self.distanceUnitsString = distanceUnits
        
        var endingLengthDistance: Double
        if self.distanceUnitsString == "Meters" {
            endingLengthDistance = round(100 * self.endingLengthDistance) / 100
        } else {
            endingLengthDistance = round(100 * self.endingLengthDistance * 3.28084) / 100
        }
       
        self.lengthOutputLabel.text = String(endingLengthDistance) + " " + self.distanceUnitsString.lowercased()
        self.lengthCubeLabel.text = String(endingLengthDistance)
        
        var endingWidthDistance: Double
        if self.distanceUnitsString == "Meters" {
            endingWidthDistance = round(100 * self.endingWidthDistance) / 100
        } else {
            endingWidthDistance = round(100 * self.endingWidthDistance * 3.28084) / 100
        }
        self.widthOutputLabel.text = String(endingWidthDistance) + " " + self.distanceUnitsString.lowercased()
        self.widthCubeLabel.text = String(endingWidthDistance)
       
        var endingHeight: Double
        if self.distanceUnitsString == "Meters" {
            endingHeight = round(100 * self.endingHeightDistance) / 100
        } else {
            endingHeight = round(100 * self.endingHeightDistance * 3.28084) / 100
        }
        self.heightOutputLabel.text = String(endingHeight) + " " + self.distanceUnitsString.lowercased()
        self.heightCubeLabel.text = String(endingHeight)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeUnitsSegue" {
            if let dest = segue.destination as? ChangeUnitsViewController {
                dest.delegate = self
                dest.selectionDist = self.distanceUnitsString
            }
        }
    }

}

