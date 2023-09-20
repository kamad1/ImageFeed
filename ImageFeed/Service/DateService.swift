
import Foundation

final class DateService {
    static let shared = DateService()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "d MMMM y"
        return formatter
    }()
    
    private let dateFormatterIso = ISO8601DateFormatter()
    
    //MARK: - Initialization
    private init() { }
    
    func dateFromString(str: String?) -> Date? {
        guard let str = str,
              let date = dateFormatterIso.date(from: str) else {
            return nil
        }
        return date
    }
    
    func stringFromDate(date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        return dateFormatter.string(from: date)
    }
}



