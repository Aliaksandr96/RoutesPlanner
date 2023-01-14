import Foundation
import RealmSwift

class Route: Object {
    @Persisted var nameRoute: String?
    @Persisted var dateSaving: String?
    let location = RealmSwift.List<Location>()
}
