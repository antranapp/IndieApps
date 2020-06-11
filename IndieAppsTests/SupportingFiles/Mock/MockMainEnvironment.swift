//
//  Copyright © 2020 An Tran. All rights reserved.
//

@testable import IndieApps
import ComposableArchitecture
import Foundation

class MockMainEnvironment: MainEnvironmentProtocol {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    var onboardingService: OnboardingServiceProtocol!
    
    var gitService: GitServiceProtocol!
    
    var contentService: ContentServiceProtocol!
    
    init(
        mainQueue: AnySchedulerOf<DispatchQueue>,
        onboardingService: OnboardingServiceProtocol = MockOnboardingService(),
        gitService: GitServiceProtocol = MockGitService(),
        contentService: ContentServiceProtocol = MockContentSevice()
    ) {
        self.mainQueue = mainQueue
        self.onboardingService = onboardingService
        self.gitService = gitService
        self.contentService = contentService
    }
    
    func setup(with: ConfigurationProtocol) {}
}
