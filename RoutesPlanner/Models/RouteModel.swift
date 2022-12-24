import Foundation
import RealmSwift

class Route: Object {
    @objc dynamic var nameRoute: String?
    @objc dynamic var dateSaving: String?
    let location = RealmSwift.List<Location>()
}
