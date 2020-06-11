//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import Foundation

protocol MainEnvironmentProtocol {
    var mainQueue: AnySchedulerOf<DispatchQueue> { get }
    
    var configuration: ConfigurationProtocol { get }
    var onboardingService: OnboardingServiceProtocol! { get }
    var gitService: GitServiceProtocol! { get }
    var contentService: ContentServiceProtocol! { get }
    
    func setup(with: ConfigurationProtocol)
}

var configuration = Configuration()

class MainEnvironment: MainEnvironmentProtocol {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var configuration: ConfigurationProtocol
    var onboardingService: OnboardingServiceProtocol!
    var gitService: GitServiceProtocol!
    var contentService: ContentServiceProtocol!
    
    init(
        configuration: ConfigurationProtocol,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.mainQueue = mainQueue
        self.configuration = configuration
        setup(with: configuration)
    }
    
    func setup(with configuration: ConfigurationProtocol) {
        self.configuration = configuration
        contentService = ContentService(
            contentLocation: configuration.contentLocation
        )
        
        gitService = GitService(
            contentLocation: configuration.contentLocation
        )
        
        onboardingService = OnboardingService(
            archiveURL: configuration.archiveURL,
            contentLocation: configuration.contentLocation
        )
    }
}
