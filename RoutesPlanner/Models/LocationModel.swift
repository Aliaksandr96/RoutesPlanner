import Foundation
import RealmSwift

class Location: Object {
    @objc dynamic var city: String = ""
    @objc dynamic var street: String = ""
    @objc dynamic var building: String = ""
    @objc dynamic var postCode: String = ""
    @objc dynamic var subAdminArea: String = ""
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var isComplited: Bool = false
    @objc dynamic var isFailed: Bool = false
    @objc dynamic var nameCustomer: String = ""
    @objc dynamic var flatCustomer: String = ""
    @objc dynamic var telCustomer: String = ""
}
