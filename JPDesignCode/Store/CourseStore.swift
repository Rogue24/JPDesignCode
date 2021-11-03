//
//  CourseStore.swift
//  JPDesignCode
//
//  Created by 周健平 on 2021/8/2.
//

import SwiftUI
import Contentful
import Combine

// https://app.contentful.com/spaces/o4uiqw9bk6r3/api/keys/4OEzxZiPiD7WuoXszLwpP1

let client = Client(spaceId: "o4uiqw9bk6r3", accessToken: "Ne_t4OZHJ3GF3C_gc4vhxjdM5qVibgrMTmXKdruBQTw")

class CourseStore: ObservableObject {
    static let colors = [#colorLiteral(red: 1, green: 0.6381785274, blue: 0.7139522433, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.4881017208, green: 0.4579643607, blue: 0.6242887378, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
    
    @Published var courses: [Course] = courseData
    
    init() {
        getArray { items in
            guard items.count > 0 else { return }
            
            var index = 0
            let courses = items.map { item -> Course in
                let course = Course(title: item.fields["title"] as! String,
                                    subtitle: item.fields["subtitle"] as! String,
                                    image: item.fields.linkedAsset(at: "image")?.url,
                                    logo: #imageLiteral(resourceName: "Logo3"),
                                    color: Self.colors[index],
                                    show: false)
                
                index += 1
                if index >= Self.colors.count {
                    index = 0
                }
                
                return course
            }
            
            self.courses.append(contentsOf: courses)
        }
    }
}

func getArray(id: String = "jpCourse", completion: @escaping ([Entry]) -> ()) {
    let query = Query.where(contentTypeId: id)
    
    client.fetchArray(of: Entry.self, matching: query) { result in
        DispatchQueue.main.async {
            switch result {
            case let .success(entry):
                print("请求成功")
                completion(entry.items)
            case let .failure(error):
                print("请求失败 \(error)")
                completion([])
            }
        }
    }
}
