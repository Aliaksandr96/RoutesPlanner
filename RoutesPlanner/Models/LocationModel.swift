import Foundation
import RealmSwift

class Location: Object {
    @Persisted var city: String = ""
    @Persisted var street: String = ""
    @Persisted var building: String = ""
    @Persisted var postCode: String = ""
    @Persisted var subAdminArea: String = ""
    @Persisted var latitude: Double = 0
    @Persisted var longitude: Double = 0
    @Persisted var isComplited: Bool = false
    @Persisted var isFailed: Bool = false
}
