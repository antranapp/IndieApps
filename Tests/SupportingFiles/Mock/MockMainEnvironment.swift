//
//  Copyright © 2020 An Tran. All rights reserved.
//

@testable import IndieApps
import ComposableArchitecture
import Foundation

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
    
    func setup(with: ConfigurationProtocol) {}
}
