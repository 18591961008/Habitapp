import SwiftUI
import Foundation

// 习惯数据模型
struct Habit: Identifiable, Codable {
    let id = UUID()          // 唯一ID
    var name: String         // 习惯名称
    var isCompleted = false  // 是否打卡
}

// 本地存储管理
class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    
    // 初始化时读取本地数据
    init() {
        habits = UserDefaults.standard.load(forKey: "habits") ?? []
    }
    
    // 保存数据到本地
    func save() {
        UserDefaults.standard.save(habits, forKey: "habits")
    }
}

// UserDefaults扩展：简化存储/读取
extension UserDefaults {
    func load<T: Decodable>(forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func save<T: Encodable>(_ value: T, forKey key: String) {
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: key)
    }
}