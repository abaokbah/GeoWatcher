/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  var list = ["Fuel Stations", "Farms Location", "Nearest Intrest"]
  
  fileprivate let locationManager = CLLocationManager()
  fileprivate var startedLoadingPOIs = false
  fileprivate var places = [Place]()
  fileprivate var arViewController: ARViewController!
  var sampleButton = UIButton()
  var  sampleTextField = UITextField()
  @IBOutlet weak var dropDown: UIPickerView!
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.dropDown.backgroundColor = .white
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.startUpdatingLocation()
    locationManager.requestWhenInUseAuthorization()
    sampleButton = UIButton(frame: CGRect(x: 20, y: 40, width: 40, height: 40))
    sampleButton.setTitle("Test Button", for: .normal)
     sampleTextField = UITextField(frame: CGRect(x: 60, y: 40, width: self.view.bounds.size.width - 80, height: 40))
    sampleTextField.placeholder = "Fuel Stations"
    sampleTextField.font = UIFont.systemFont(ofSize: 15)
    sampleTextField.borderStyle = UITextBorderStyle.roundedRect
    sampleTextField.autocorrectionType = UITextAutocorrectionType.no
    sampleTextField.keyboardType = UIKeyboardType.default
    sampleTextField.returnKeyType = UIReturnKeyType.done
    sampleTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
    sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
    //sampleTextField.delegate = self
    self.view.addSubview(sampleTextField)

    sampleButton.backgroundColor = .white
    sampleButton.setTitleColor(.black, for: .normal)
    //sampleButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    sampleButton.backgroundColor = .white
    sampleButton.layer.cornerRadius = 5
    sampleButton.layer.borderWidth = 1
    sampleButton.layer.borderColor = UIColor.gray.cgColor
    sampleButton.setTitle("⌸", for: .normal)
    sampleButton.addTarget(self, action:#selector(clickMe), for:.touchUpInside)
    self.view.addSubview(sampleButton)
//    let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
//    button.backgroundColor = .green
//    button.setTitle("Test Button", for: .normal)
//    //button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
//    
//    self.view.addSubview(button)
    self.dropDown.dataSource = self
    self.dropDown.delegate = self
  }
  func clickMe(){
    print("hell no ")

      self.dropDown.isHidden = false

  }
  public func numberOfComponents(in pickerView: UIPickerView) -> Int{
    return 1
    
  }
  
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
    
    return list.count
    
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
    self.view.endEditing(true)
    return list[row]
    
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    self.sampleTextField.text = self.list[row]
    self.dropDown.isHidden = true
    
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
    if textField == self.sampleTextField {
      self.dropDown.isHidden = false
      //if you dont want the users to se the keyboard type:
      
      textField.endEditing(true)
    }
    
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func showARController(_ sender: Any) {
    
    arViewController = ARViewController()
    //1
    arViewController.dataSource = self
    //2
    arViewController.maxVisibleAnnotations = 30
    arViewController.headingSmoothingFactor = 0.05
    //3
    arViewController.setAnnotations(places)
    
    self.present(arViewController, animated: true, completion: nil)
  }
  
}

extension ViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    //1
    if locations.count > 0 {
      let location = locations.last!
      print("Accuracy: \(location.horizontalAccuracy)")
      
      //2
      if location.horizontalAccuracy < 100 {
        //3
        manager.stopUpdatingLocation()
        //

        let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.region = region
        // More code later...
        
        if !startedLoadingPOIs {
          startedLoadingPOIs = true
          //2
          let loader = PlacesLoader()
          //
          //let lat = 41.888673//Double(apiData["latitude"] as! String)!
          //let lon = 87.975371//Double(apiData["longitude"] as! String)!
          //
          loader.loadPOIS(location: location, radius: 1000) { placesDict, error in
            //3
            
            if let dict = placesDict {
              print(dict.count)
              for fuel in dict{
                let apiData = fuel as! Dictionary<String, Any>
                print(apiData["station_name"]!)
                  //for placeDict in placesArray {
                  //3
//                  let latitude = (fuel as AnyObject).value(forKeyPath: "latitude") as! CLLocationDegrees
//                  let longitude = (fuel as AnyObject).value(forKeyPath: "longitude") as! CLLocationDegrees
                
                  let reference = apiData["station_name"]! as! String
                  let name = apiData["station_name"]! as! String
                  let address = apiData["street_address"]! as! String
//                  
//                  let location = CLLocation(latitude: latitude, longitude: longitude)
//                  //4
//                  let place = Place(location: location, reference: reference, name: name, address: address)
//                  self.places.append(place)
//                  //5
                let lat = Double(apiData["latitude"] as! String)!
                let lon = Double(apiData["longitude"] as! String)!
                print(lat)
                let location = CLLocation(latitude: lat, longitude: lon)
                  let annotation = PlaceAnnotation(location: location.coordinate, title: apiData["station_name"]! as! String)
                let place = Place(location: location, reference: reference, name: name, address: address)
                                self.places.append(place)
                  //6
                  DispatchQueue.main.async {
                    self.mapView.addAnnotation(annotation)
                  }
                  //              //1
                  //              //guard let placesArray = dict.object(forKey: "results") as? [NSDictionary]  else { return }
                  //              guard let placesArray = dict.object(forKey: "results") as? [NSDictionary]  else { return }
                  //              //2
                  //              for placeDict in placesArray {
                  //                //3
                  //                let latitude = placeDict.value(forKeyPath: "geometry.location.lat") as! CLLocationDegrees
                  //                let longitude = placeDict.value(forKeyPath: "geometry.location.lng") as! CLLocationDegrees
                  //                let reference = placeDict.object(forKey: "reference") as! String
                  //                let name = placeDict.object(forKey: "name") as! String
                  //                let address = placeDict.object(forKey: "vicinity") as! String
                  //
                  //                let location = CLLocation(latitude: latitude, longitude: longitude)
                  //                //4
                  //                let place = Place(location: location, reference: reference, name: name, address: address)
                  //                self.places.append(place)
                  //                //5
                  //                let annotation = PlaceAnnotation(location: place.location!.coordinate, title: place.placeName)
                  //                //6
                  //                DispatchQueue.main.async {
                  //                  self.mapView.addAnnotation(annotation)
                  //                }
                  //              }
                  
                }
              }
            }
          }
        }
        
        
      }
      
  }
}

    extension ViewController: ARDataSource {
      func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView = AnnotationView()
        annotationView.annotation = viewForAnnotation
        annotationView.delegate = self
        annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        
        return annotationView
      }
    }
    extension ViewController: AnnotationViewDelegate {
      func didTouch(annotationView: AnnotationView) {
        //1
        if let annotation = annotationView.annotation as? Place {
          //2
          let placesLoader = PlacesLoader()
          //placesLoader.loadDetailInformation(forPlace: annotation) { resultDict, error in
//
//            //3
////            if let infoDict = resultDict?.object(forKey: "result") as? NSDictionary {
////              annotation.phoneNumber = infoDict["station_name"]! as? String
////              annotation.website = infoDict["station_name"]! as? String
////              
//////              if let dict = placesDict {
//////                print(dict.count)
//////                for fuel in dict{
//////                  let apiData = fuel as! Dictionary<String, Any>
//////
//////              let name = apiData["station_name"]! as! String
//////              let address = apiData["station_name"]! as! String
////              
////              
////              //4
////              self.showInfoView(forPlace: annotation)
////            }
          //}
print(annotation.placeName)
          print(annotation.address)
//          
//          let alert = UIAlertController(title: annotation.placeName , message: annotation.address, preferredStyle: UIAlertControllerStyle.alert)
//          alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//          //2
//          arViewController.present(alert, animated: true, completion: nil)

          let model = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! PopupViewController
          model.modalPresentationStyle = .overCurrentContext
          model.message = "\(annotation.placeName)\n\(annotation.address)"
          switch annotation.placeName{
          case _ where annotation.placeName.hasPrefix("Hicksgas"):
            model.imageName = "Hicksgas"
          case _ where annotation.placeName.hasPrefix("Menards"):
            model.imageName = "Menards"
          case _ where annotation.placeName.hasPrefix("AmeriGas"):
            model.imageName = "Amerigas"
          default:
            model.imageName = "UHaul.jpg"
            
            
          }
          arViewController.present(model, animated: true, completion: nil)
        }
        

      }
      
      func showInfoView(forPlace place: Place) {
        //1
        let alert = UIAlertController(title: place.placeName , message: place.infoText, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        //2
        arViewController.present(alert, animated: true, completion: nil)
      }
}

