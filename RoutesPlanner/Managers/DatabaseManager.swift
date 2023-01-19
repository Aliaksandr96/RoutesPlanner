import Foundation
import RealmSwift

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {}
    
    let realm = try! Realm()
    
    func saveRoute(route: Route) {
        try! realm.write {
            realm.add(route)
        }
    }
    
    func deleteRoute(route: Route) {
        try! realm.write {
            realm.delete(route)
        }
    }
    
    func getRoute() -> Results<Route> {
        realm.objects(Route.self)
    }
    
    func isCompletedPlace(state: Bool, location: Location) {
        try! realm.write {
            location.isComplited = state
        }
    }

    func isFailedPlace(state: Bool, location: Location) {
        try! realm.write {
            location.isFailed = state
        }
    }
    
    func customerName(name: String, location: Location) {
        try! realm.write {
            location.nameCustomer = name
        }
    }
    func customerFlat(flat: String, location: Location) {
        try! realm.write {
            location.flatCustomer = flat
        }
    }
    func customerTel(tel: String, location: Location) {
        try! realm.write {
            location.telCustomer = tel
        }
    }
    
//    func addCustomerInfo(name: String, flat: String, tel: String, location: Location) {
//        try! realm.write {
//            location.nameCustomer = name
//            location.flatCustomer = flat
//            location.telCustomer = tel
//        }
//    }
}
