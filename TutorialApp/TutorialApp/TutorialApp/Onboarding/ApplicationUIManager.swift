//
// TutorialApp
//
// Created by SAP BTP SDK Assistant for iOS v7.0.0 application on 04/01/22
//

import SAPCommon
import SAPFiori
import SAPFioriFlows
import SAPFoundation

class ApplicationUIManager: ApplicationUIManaging {
    // MARK: – Properties
    
    let window: UIWindow
    var isOnboarding = false
    
    private var coveringViews = [UIView]()
    
    // MARK: – Init
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - ApplicationUIManaging
    
    func hideApplicationScreen(completionHandler: @escaping (Error?) -> Void) {
        // Check whether the covering screen is already presented or not
        guard isSplashPresented == false else {
            completionHandler(nil)
            return
        }
        
        coverAppScreen(with: UIViewController().view)
        
        completionHandler(nil)
    }
    
    func showSplashScreenForOnboarding(completionHandler: @escaping (Error?) -> Void) {
        // splash already presented
        guard isSplashPresented == false else {
            completionHandler(nil)
            return
        }
        
        setupSplashScreen()
        
        completionHandler(nil)
    }
    
    func showSplashScreenForUnlock(completionHandler: @escaping (Error?) -> Void) {
        guard isSplashPresented == false else {
            completionHandler(nil)
            return
        }
        
        setupSplashScreen()
        
        completionHandler(nil)
    }
    
    func showApplicationScreen(completionHandler: @escaping (Error?) -> Void) {
        // Check if an application screen has already been presented
        guard isSplashPresented else {
            completionHandler(nil)
            return
        }
        
        // set rootViewController only once ie after onboarding when app screen is about to be shown
        // for restore, remove covering views previously added
        let appViewController: UIViewController
        if isOnboarding {
#if targetEnvironment(macCatalyst)
            let splitViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! UISplitViewController
            
            splitViewController.modalPresentationStyle = .currentContext
            splitViewController.preferredDisplayMode = .allVisible
            appViewController = splitViewController
            
            // If running on iOS show the OverviewTableViewController
#else
            let overviewTVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OverviewTableViewController") as! OverviewTableViewController
            appViewController = overviewTVC
#endif
            
            isOnboarding = false
            coveringViews.removeAll()
            
            // maintain this boolean since no splash screen is present now
            isSplashPresented = false
            window.rootViewController = appViewController
        } else {
            removeCoveringViews()
        }
        
        completionHandler(nil)
    }
    
    func releaseRootFromMemory() {
        guard isOnboarding == false else {
            return
        }
        
        window.rootViewController = FUIInfoViewController.createSplashScreenInstanceFromStoryboard()
        isSplashPresented = false
        isOnboarding = true
    }
    
    // MARK: – Helpers
    
    private var isSplashPresented: Bool = false
    
    private func setupSplashScreen() {
        let splashViewController = FUIInfoViewController.createSplashScreenInstanceFromStoryboard()
        coverAppScreen(with: splashViewController.view)
        
        // Set the splash screen for the specific presenter
        let modalPresenter = OnboardingFlowProvider.modalUIViewControllerPresenter
        if let rootVc = window.rootViewController as? FUIInfoViewController {
            modalPresenter.setSplashScreen(rootVc)
        } else {
            // should never happen but adding as a fail safe
            modalPresenter.setSplashScreen(splashViewController)
        }
        modalPresenter.animated = true
    }
    
    // Hide the application screen by adding a view to the top
    private func coverAppScreen(with view: UIView?) {
        guard let view = view else {
            return
        }
        // always hide the topViewController's screen
        if let rootVc = UIApplication.shared.topViewController() {
            view.frame = rootVc.view.bounds
            rootVc.view.addSubview(view)
            coveringViews.append(view)
            isSplashPresented = true
        }
    }
    
    // Remove covering views when no more required
    private func removeCoveringViews() {
        _ = coveringViews.map { $0.removeFromSuperview() }
        isSplashPresented = false
    }
}

extension UIApplication {
    // Iterate through VC hierarchy up to the top most
    func topViewController(base: UIViewController? = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController,
           let selected = tab.selectedViewController
        {
            return topViewController(base: selected)
        }
        if let split = base as? UISplitViewController {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return split
            }
            let vc = split.viewControllers.first
            return topViewController(base: vc)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
