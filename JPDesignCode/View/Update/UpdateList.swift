//
//  UpdateList.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/6/15.
//

import SwiftUI

struct UpdateList: View {
    @ObservedObject var store = UpdateStore()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.updates) { update in
                    // destination：想push的页面
                    NavigationLink(destination: UpdateDetail(update: update)) {
                        // 这里布局cell的内容
                        HStack {
                            Image(update.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .background(Color.black)
                                .cornerRadius(10)
                                .padding(.trailing, 4)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(update.title)
                                    .font(.system(size: 20, weight: .bold))
                                
                                Text(update.text)
                                    .lineLimit(2) // 最多2行
                                    .font(.subheadline)
                                    .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                                
                                Text(update.date)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                // 删除
                .onDelete { indexSet in
                    self.store.updates.remove(at: indexSet.first!)
                }
                // 移动
                .onMove(perform: { source, destination in
                    self.store.updates.move(fromOffsets: source, toOffset: destination)
                })
                // onDelete、onMove等都是ForEach（DynamicViewContent）的函数，List没有，这些函数一起决定了EditButton可提供的功能
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle(Text("Updates"))
            .navigationBarItems(
                leading: Button(action: addUpdate) { Text("Add Update") },
                trailing: EditButton()
            )
//            .animation(workItem != nil ? .default : .none)
        }
        // iOS13的NavigationView在iPad端默认是左右两列的形式展示，需要手动设置回默认样式
        .navigationViewStyle(StackNavigationViewStyle()) 
    }
    
    func addUpdate() {
        store.updates.append(
            Update(image: "Card1",
                   title: "New item",
                   text: "New text",
                   date: "Jun 1")
        )
    }
}

struct UpdateList_Previews: PreviewProvider {
    static var previews: some View {
        UpdateList()
    }
}
