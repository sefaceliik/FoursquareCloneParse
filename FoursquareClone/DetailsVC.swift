//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Sefa Çelik on 16.05.2020.
//  Copyright © 2020 Sefa Celik. All rights reserved.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var atmosphereLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var chosenPlaceId: String = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDataFromParse()
        mapView.delegate = self
    
    }
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                if objects != nil {
                    let chosenPlaceObject = objects![0]
                        
                    if let placeName = chosenPlaceObject.object(forKey: "name") as? String{
                        self.nameLabel.text = placeName
                    }
                    if let placeType = chosenPlaceObject.object(forKey: "type") as? String{
                        self.typeLabel.text = placeType
                    }
                    if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String{
                        self.atmosphereLabel.text = placeAtmosphere
                    }
                    if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String{
                        if let placeLatitudeDouble = Double(placeLatitude){
                            self.chosenLatitude = placeLatitudeDouble
                        }
                    }
                    if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String{
                        if let placeLongitudeDouble = Double(placeLongitude) {
                            self.chosenLongitude = placeLongitudeDouble
                        }
                    }
                    if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject{
                        imageData.getDataInBackground { (data, error) in
                            if error == nil {
                                if data != nil{
                                    self.imageView.image = UIImage(data: data!)
                                }
                            }
                        }
                    }
                    
                    // maps
                    let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.mapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = self.nameLabel.text
                    self.mapView.addAnnotation(annotation)
                    
                    
                }
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.nameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
   

}
