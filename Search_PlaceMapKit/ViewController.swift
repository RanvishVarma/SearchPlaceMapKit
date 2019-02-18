//
//  ViewController.swift
//  Search_PlaceMapKit
//
//  Created by Allvy on 7/10/18.
//  Copyright © 2018 Allvy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController,UISearchBarDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var displayLoc: UILabel!
    
    @IBOutlet weak var displayCountry: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var myMapView: MKMapView!
    @IBAction func searchButton(_ sender: Any) {
        let searchController=UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate=self
        present(searchController,animated: true,completion: nil)
    }
    let manager=CLLocationManager()
    var location1: String!
    let geoCoder=CLGeocoder()
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let activityIndicator=UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.gray
        activityIndicator.center=self.view.center
        activityIndicator.hidesWhenStopped=true
        activityIndicator.startAnimating()
        self.view .addSubview(activityIndicator)
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest=MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        
        let activeSearch=MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if response==nil{
                print("ERROR")
            }
            else{
                let annotations=self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                let latitude=response?.boundingRegion.center.latitude
                let longitude=response?.boundingRegion.center.longitude
                
                let annotation=MKPointAnnotation()
                annotation.title=searchBar.text
                annotation.coordinate=CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                
                let coordinate:CLLocationCoordinate2D=CLLocationCoordinate2DMake(latitude!, longitude!)
                let span=MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region=MKCoordinateRegionMake(coordinate, span)
                self.myMapView.setRegion(region, animated: true)
            }
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // super.viewDidLoad()
        manager.delegate=self
        manager.desiredAccuracy=kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
       // CLLocationManagerDelegate=self
        // Do any additional setup after loading the view, typically from a nib.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       // let location=locations.last
        let userLocation:CLLocation=locations[0] as CLLocation
        let location = manager.location?.coordinate
        print(location?.latitude)
        print(location?.longitude)
        print(userLocation.timestamp)
        print(userLocation.horizontalAccuracy)
        
       let location1 = locations.first
   
        geoCoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil)
            {
                print("error in reverseGeocode")
            }
            var placemark=placemarks! as [CLPlacemark]
           if placemark.count>0
           {
            let placemark = placemarks![0]
            print(placemark.locality!)
            self.displayLabel.text=placemark.locality!
            print(self.displayLabel.text)
            self.displayCountry.text=placemark.country!
            print(self.displayCountry.text)
            self.displayLoc.text=placemark.administrativeArea!
            print(self.displayLoc.text)
            print(placemark.administrativeArea!)
            print(placemark.country!)
            
            }
          
            /*
             
             let geocoder = CLGeocoder()
             geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
             if (error != nil){
             print("error in reverseGeocode")
             }
             let placemark = placemarks! as [CLPlacemark]
             if placemark.count>0{
             let placemark = placemarks![0]
             print(placemark.locality!)
             print(placemark.administrativeArea!)
             print(placemark.country!)
             //  print(placemark.region)
             //  print(placemark.postalCode)
             let defaults = UserDefaults.standard
             defaults.set(placemark.administrativeArea!, forKey: "State")
             defaults.set(placemark.locality!, forKey: "City")
             defaults.set(placemark.country!, forKey: "Country")
             defaults.set(placemark.postalCode, forKey: "postalCode")
             
             //self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
             }
             }
 */
        
            
        }
       
        
    }
        
        /*
     
     
     if error == nil
     {
     if response != nil
     {
     let address:GMSAddress! = response!.firstResult()
     
     if address != nil
     {
     let addressArray:NSArray! = address.lines! as NSArray
     
     if addressArray.count > 1
     {
     
     print(address.locality)
     print(address.subLocality)
     print(address.locality!)
     print(address.administrativeArea!)
     print(address.country!)
     
     
     print(address.postalCode)
     print(address.thoroughfare)
     print(address.subLocality)
     
     print(address.description)
     var convertAddress:AnyObject! = addressArray.object(at: 0) as AnyObject!
     let space = ","
     let convertAddress1:AnyObject! = addressArray.object(at: 1) as AnyObject!
     let country:AnyObject! = address.country as AnyObject!
     
     convertAddress = (((convertAddress.appending(space) + (convertAddress1 as! String)) + space) + (country as! String)) as AnyObject
     
     print(convertAddress)
     self.defaults.set(convertAddress, forKey: "convertAddress")
     //self.currentlocationlbl.text = "\(convertAddress!)".appending(".")
     }
     else
     {
     //  self.currentlocationlbl.text = "Fetching current location failure!!!!"
     }
     }
     }
     }
     }
     
     }
 */


}


