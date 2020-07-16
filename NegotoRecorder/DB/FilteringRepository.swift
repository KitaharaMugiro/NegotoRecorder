import Foundation
import Realm
import RealmSwift

// Define your models like regular Swift classes
class FilteringRealm: Object {
    @objc dynamic var title = "" //結合用
}

class FilteringRepository {
    
    func getFilteringWords() -> [String] {
        let realm = try! Realm()
        let record = realm.objects(FilteringRealm.self)
        return record.compactMap{r in
            return r.title
        }
    }
    
    
    func addFiltering(title : String) {
        let filteringRealm = FilteringRealm()
        filteringRealm.title = title
        autoreleasepool {
            let realm = try! Realm()
            try! realm.write {
                realm.add(filteringRealm)
            }
        }
    }
}
