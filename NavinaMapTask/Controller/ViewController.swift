

//
//  ViewController.swift
//  MapTestNavinaM
//
//  Created by selvarani on 21/01/25.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let viewModel = TaskListViewModel()
    let annotation = MKPointAnnotation()
    
    //MARK- UILifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapView()
        addMapTrackingButton()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }
   
    //MARK- MapviewsetUp
    func setMapView(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    //MARK- MapView_Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
       // let center = CLLocationCoordinate2D(latitude: 37.334921684869514, longitude: -122.0089531250216) // static location for using simulator purpose
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) // real time location
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        for task in viewModel.tasks {
            let annotation = TaskAnnotation(task: task)
            mapView.addAnnotation(annotation)
        }
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            
            showLocationAccessAlert()
        default:
            break
        }
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let location = gesture.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            showAddTaskAlert(at: coordinate)
        }
    }
    func showAddTaskAlert(at coordinate: CLLocationCoordinate2D) {
        let alert = UIAlertController(title: "Add Task", message: "Enter task details", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Title" }
        alert.addTextField { $0.placeholder = "Description" }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self,
                  let title = alert.textFields?[0].text,
                  let description = alert.textFields?[1].text else { return }
            
            self.viewModel.addTask(title: title, description: description, location: coordinate)
            let myViewController = self.storyboard?.instantiateViewController(withIdentifier: "TaskViewController") as! TaskViewController
            self.navigationController?.pushViewController(myViewController, animated: true)
            
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    // Show an alert if location access is denied
    func showLocationAccessAlert() {
        let alert = UIAlertController(
            title: "Location Access Denied",
            message: "Please enable location permissions in Settings to allow live tracking.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    //current location button
    func addMapTrackingButton(){
        let image = UIImage(named: "trackme") as UIImage?
        let button   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.frame = CGRect(origin: CGPoint(x:5, y: 25), size: CGSize(width: 35, height: 35))
        button.setImage(image, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(ViewController.centerMapOnUserButtonClicked), for:.touchUpInside)
        mapView.addSubview(button)
    }
    
    @objc func centerMapOnUserButtonClicked() {
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
    }
    
    // Customize annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil // Skip user location annotation
        }
        
        let identifier = "TaskAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = .blue
            
            // Add a detail disclosure button
            let detailButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = detailButton
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    // Handle pin tap
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let taskAnnotation = view.annotation as? TaskAnnotation else { return }
        
        let alert = UIAlertController(
            title: taskAnnotation.title,
            message: taskAnnotation.subtitle,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}




class TaskAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(task: Task) {
        self.coordinate = task.location
        self.title = task.title
        self.subtitle = task.description
    }
}
