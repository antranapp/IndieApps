//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import Foundation

protocol MainEnvironmentProtocol {
    var mainQueue: AnySchedulerOf<DispatchQueue> { get }
    
    var onboardingService: OnboardingServiceProtocol! { get }
    var gitService: GitServiceProtocol! { get }
    var contentService: ContentServiceProtocol! { get }
}

struct MainEnvironment: MainEnvironmentProtocol {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var configurationProvider: ConfigurationProvider
    var onboardingService: OnboardingServiceProtocol!
    var gitService: GitServiceProtocol!
    var contentService: ContentServiceProtocol!
    
    init(
        configurationProvider: @escaping ConfigurationProvider,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.mainQueue = mainQueue
        self.configurationProvider = configurationProvider
        
        contentService = ContentService(
            contentLocationProvider: { configurationProvider().contentLocation }
        )
        
        gitService = GitService(
            contentLocationProvider: { configurationProvider().contentLocation }
        )
        
        onboardingService = OnboardingService(
            archiveURL: configurationProvider().archiveURL,
            contentLocationProvider: { configurationProvider().contentLocation }
        )
    }
}
