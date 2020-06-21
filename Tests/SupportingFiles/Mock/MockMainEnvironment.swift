//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import Foundation
@testable import IndieApps

class MockMainEnvironment: MainEnvironmentProtocol {
    var configuration: ConfigurationProtocol

    var mainQueue: AnySchedulerOf<DispatchQueue>

    var onboardingService: OnboardingServiceProtocol!

    var gitService: GitServiceProtocol!

    var contentService: ContentServiceProtocol!

    init(
        mainQueue: AnySchedulerOf<DispatchQueue>,
        configuration: ConfigurationProtocol = MockConfiguration(),
        onboardingService: OnboardingServiceProtocol = MockOnboardingService(),
        gitService: GitServiceProtocol = MockGitService(),
        contentService: ContentServiceProtocol = MockContentSevice()
    ) {
        self.mainQueue = mainQueue
        self.configuration = configuration
        self.onboardingService = onboardingService
        self.gitService = gitService
        self.contentService = contentService
    }

    func setup(with _: ConfigurationProtocol) {}
}
