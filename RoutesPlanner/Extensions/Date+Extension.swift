import Foundation

extension Date {
    static func formating(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy 'at' H:mm"
        return formatter.string(from: date)
    }

    static func routeDay() -> String {
        let formatter = DateFormatter()
        let date = Date()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
