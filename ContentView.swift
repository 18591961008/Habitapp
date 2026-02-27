import SwiftUI

struct ContentView: View {
    @StateObject var store = HabitStore()  // 数据管理
    @State private var newHabit = ""       // 新习惯输入框
    
    var body: some View {
        NavigationStack {
            VStack {
                // 添加新习惯的输入框+按钮
                HStack {
                    TextField("输入习惯（如早起、喝水）", text: $newHabit)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(action: addHabit) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                    .disabled(newHabit.isEmpty) // 空内容时按钮禁用
                }
                .padding()
                
                // 习惯列表
                List {
                    ForEach($store.habits) { $habit in
                        HStack {
                            Text(habit.name)
                            Spacer()
                            // 打卡状态图标
                            Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(habit.isCompleted ? .green : .gray)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // 点击切换打卡状态
                            habit.isCompleted.toggle()
                            store.save()
                        }
                    }
                    .onDelete(perform: deleteHabit) // 左滑删除
                }
            }
            .navigationTitle("极简习惯追踪")
        }
    }
    
    // 添加新习惯
    private func addHabit() {
        store.habits.append(Habit(name: newHabit))
        store.save()
        newHabit = "" // 清空输入框
    }
    
    // 删除习惯
    private func deleteHabit(at offsets: IndexSet) {
        store.habits.remove(atOffsets: offsets)
        store.save()
    }
}