//
//  ViewController.swift
//  eMonument
//
//  Created by VIGUIER Julien on 10/01/2019.
//  Copyright © 2019 VIGUIER Julien. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var monuments: [Monument] = []
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let startLocation = CLLocationCoordinate2D(latitude: 48.8534, longitude: 2.3488)
        let mapSpan = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: startLocation, span: mapSpan)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        deleteData(managedCtxt: managedContext)
        createData(managedCtxt: managedContext)
        loadData(managedCtxt: managedContext)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotations(monuments)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthorizationStatus()
    }
    
    func loadData(managedCtxt: NSManagedObjectContext) {
        do {
            let data = try managedCtxt.fetch(Monuments.fetchRequest())
            for tmp in data as! [Monuments] {
                let titleTmp = tmp.value(forKey: "title") as! String
                let locationNameTmp = tmp.value(forKey: "locationName") as! String
                let latitudeTmp = tmp.value(forKey: "latitude") as! CLLocationDegrees
                let longitudeTmp = tmp.value(forKey: "longitude") as! CLLocationDegrees
                let coordTmp = CLLocationCoordinate2D(latitude: latitudeTmp, longitude: longitudeTmp)
                let monumentTmp = Monument(title: titleTmp, locationName: locationNameTmp, coordinate: coordTmp)
                monuments.append(monumentTmp)
            }
        } catch {
            print("Error while fetching data")
        }
    }
    
    func createData(managedCtxt: NSManagedObjectContext) {
        let monumentEntity = NSEntityDescription.entity(forEntityName: "Monuments", in: managedCtxt)
        let monu1 = NSManagedObject(entity: monumentEntity!, insertInto: managedCtxt)
        monu1.setValue("Eiffel Tower", forKey: "title")
        monu1.setValue("Champ de Mars", forKey: "locationName")
        monu1.setValue(48.858093, forKey: "latitude")
        monu1.setValue(2.294694, forKey: "longitude")
        
        let monu2 = NSManagedObject(entity: monumentEntity!, insertInto: managedCtxt)
        monu2.setValue("Louvre Museum", forKey: "title")
        monu2.setValue("Louvre Tuileries", forKey: "locationName")
        monu2.setValue(48.860294, forKey: "latitude")
        monu2.setValue(2.338629, forKey: "longitude")
        
        do {
            try managedCtxt.save()
        } catch let error as NSError {
            print("Error while saving \(error), \(error.userInfo)")
        }
    }
    
    func deleteData(managedCtxt: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Monuments")
        if let result = try? managedCtxt.fetch(fetchRequest) {
            for object in result {
                managedCtxt.delete(object as! NSManagedObject)
            }
        }
        do {
            try managedCtxt.save()
        } catch {
            print(error)
        }
    }
    
    func checkAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.startUpdatingLocation()
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Monument else { return nil }
        let identifier: String = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Monument
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}


