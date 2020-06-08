//
//  Copyright © 2020 An Tran. All rights reserved.
//

#if DEBUG
import Combine
import Foundation

struct MockContentSevice: ContentServiceProtocol {
    static let appList = [
        App(
            version: 1,
            id: UUID().uuidString,
            name: "Twitter",
            shortDescription: "Twitter is cool",
            description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.",
            links: [
                .homepage("https://antran.app"),
                .testflight("https://antran.app"),
                .appstore("https://antran.app")
            ],
            previews: [
                .web(["https://ph-files.imgix.net/0b48f11b-858b-431e-94c7-5a8dbead8bbe.png", "https://ph-files.imgix.net/0b48f11b-858b-431e-94c7-5a8dbead8bbe.png"]),
                .iOS(["https://is2-ssl.mzstatic.com/image/thumb/Purple123/v4/a4/0d/57/a40d573a-5621-e0e7-c051-34d9487a7e77/pr_source.jpg/460x0w.jpg", "https://is2-ssl.mzstatic.com/image/thumb/Purple123/v4/a4/0d/57/a40d573a-5621-e0e7-c051-34d9487a7e77/pr_source.jpg/460x0w.jpg"])
            ],
            releaseNotes: [
                ReleaseNote(version: "1.0.0 (1)", note: "Fix a lot of bugs"),
                ReleaseNote(version: "1.0.0 (2)", note: "Fix a lot of bugs"),
            ]
        )
    ]
    static let categoryList = [
        Category(name: "Movies", numberOfApps: 1),
        Category(name: "Photography", numberOfApps: 2)
    ]

    func fetchCategoryList() -> AnyPublisher<[Category], Never> {
        return Just(MockContentSevice.categoryList)
            .eraseToAnyPublisher()
    }
    
    func fetchAppList(in category: Category) -> AnyPublisher<[App], Never> {
        return Just(MockContentSevice.appList)
            .eraseToAnyPublisher()
    }
}
#endif
