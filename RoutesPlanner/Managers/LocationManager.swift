import Foundation
import MapKit

enum Subtitles: String {
    case completed = "Completed"
    case failed = "Failed"
    case empty = ""
}

final class LocationManager {
    
    static let shared = LocationManager()
    
    private init() {}
    
    func localizeCity() -> MKCoordinateRegion {
        let location = CLLocationManager()
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
        let meters: Double = 25000
        guard let coordinateUser = location.location?.coordinate else { return MKCoordinateRegion() }
        let newRegion = MKCoordinateRegion(center: coordinateUser, latitudinalMeters: meters, longitudinalMeters: meters)
        return newRegion
    }
    
    func localizePlace(location: Location) -> MKCoordinateRegion {
        let meters: Double = 1500
        let coordinatePlace = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let newRegion = MKCoordinateRegion(center: coordinatePlace, latitudinalMeters: meters, longitudinalMeters: meters)
        return newRegion
    }
    
    func navigationToSelectPlace(location: Location) {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let destination = MKMapItem(placemark: placemark)
        destination.name = location.street + "," + location.building
        MKMapItem.openMaps(with: [destination])
    }
    
    func addAnnotations(location: Location) -> MKPointAnnotation {
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude,
                                                            longitude: location.longitude)
        pointAnnotation.title = location.street + "," + location.building
        if location.isComplited == true {
            pointAnnotation.subtitle = Subtitles.completed.rawValue
        }
        if location.isFailed == true {
            pointAnnotation.subtitle = Subtitles.failed.rawValue
        }
        return pointAnnotation
    }
    
    func setupFailedAnnotation(mapView: MKMapView, location: Location) {
        let pointAnnatation = MKPointAnnotation()
        pointAnnatation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        pointAnnatation.title = location.street + "," + location.building
        for annotation in mapView.annotations {
            if annotation.title == pointAnnatation.title {
                mapView.removeAnnotation(annotation)
                if location.isFailed == false {
                    pointAnnatation.subtitle = Subtitles.empty.rawValue
                } else {
                    pointAnnatation.subtitle = Subtitles.failed.rawValue
                }
                mapView.addAnnotation(pointAnnatation)
            }
        }
    }
    
    func setupAcceptAnnotation(mapView: MKMapView, location: Location) {
        let pointAnnatation = MKPointAnnotation()
        pointAnnatation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        pointAnnatation.title = location.street + "," + location.building
        for annotation in mapView.annotations {
            if annotation.title == pointAnnatation.title {
                mapView.removeAnnotation(annotation)
                if location.isComplited == false {
                    pointAnnatation.subtitle = Subtitles.empty.rawValue
                } else {
                    pointAnnatation.subtitle = Subtitles.completed.rawValue
                }
                mapView.addAnnotation(pointAnnatation)
            }
        }
    }
}
