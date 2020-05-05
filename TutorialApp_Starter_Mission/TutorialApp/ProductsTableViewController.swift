//
//  ProductsTableViewController.swift
//  TutorialApp
//
//  Created by Muessig, Kevin on 4/29/20.
//  Copyright © 2020 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import SAPFoundation
import SAPOData
import SAPFioriFlows
import SAPCommon

class ProductsTableViewController: UITableViewController, SAPFioriLoadingIndicator {
    
    private let logger = Logger.shared(named: "OverviewTableViewController")
    
    var loadingIndicator: FUILoadingIndicatorView?
    var kpiHeader: FUIKPIHeader!
    
    let destinations = FileConfigurationProvider("AppParameters").provideConfiguration().configuration["Destinations"] as! NSDictionary
    
    var dataService: ESPMContainer<OnlineODataProvider>? {
        guard let odataController = OnboardingSessionManager.shared.onboardingSession?.odataControllers[destinations["com.sap.edm.sampleservice.v2"] as! String] as? Comsapedmsampleservicev2OnlineODataController, let dataService = odataController.espmContainer else {
            AlertHelper.displayAlert(with: NSLocalizedString("OData service is not reachable, please onboard again.", comment: ""), error: nil, viewController: self)
            return nil
        }
        return dataService
    }
    
    private var imageCache = [String: UIImage]()
    private var productImageURLs = [String]()
    private var products = [Product]()
    
    private var searchController: FUISearchController?
    private var searchedProducts = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        
        loadData()
        setupSearchBar()
    }
    
    private func loadData() {
        showFioriLoadingIndicator()
        fetchProducts {
            self.tableView.reloadData()
            self.hideFioriLoadingIndicator()
        }
    }

    // MARK: - Data loading
    
    /**
    Fetch the products and handle it's errors. In case of success set the data and call the completion handler so you can stop the loading indicator.
    */
    private func fetchProducts(completionHandler: @escaping () -> Void) {
        dataService?.fetchProducts() { [weak self] result, error in
            if let error = error {
                AlertHelper.displayAlert(with: NSLocalizedString("Failed to load list of products!", comment: ""), error: error, viewController: self!)
                self?.logger.error("Failed to load list of products!", error: error)
                return
            }
            self?.products.append(contentsOf: result!)
            self?.productImageURLs.append(contentsOf: result!.map { $0.pictureUrl ?? "" })
            completionHandler()
        }
    }

    private func loadImageFrom(_ url: URL, completionHandler: @escaping (_ image: UIImage) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let sapURLSession = appDelegate.sessionManager.onboardingSession?.sapURLSession {
            sapURLSession.dataTask(with: url, completionHandler: { data, _, error in

                if let error = error {
                    self.logger.error("Failed to load image!", error: error)
                    return
                }

                if let image = UIImage(data: data!) {
                    // safe image in image cache
                    self.imageCache[url.absoluteString] = image
                    DispatchQueue.main.async { completionHandler(image) }
                }
            }).resume()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = products[indexPath.row]
        let productCell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier) as! FUIObjectTableViewCell
        productCell.accessoryType = .detailDisclosureButton
        productCell.headlineText = product.name ?? "-"
        productCell.subheadlineText = product.categoryName ?? "-"
        productCell.footnoteText = product.stockDetails?.quantity?.intValue() != 0 ? NSLocalizedString("In Stock", comment: "") : NSLocalizedString("Out", comment: "")
        // set a placeholder image
        productCell.detailImageView.image = FUIIconLibrary.system.imageLibrary

        // This URL is found in Mobile Services
        let baseURL = "https://d061070trial-dev-com-sap-example.cfapps.us10.hana.ondemand.com/SampleServices/ESPM.svc/v2"
        let url = URL(string: baseURL.appending(productImageURLs[indexPath.row]))

        guard let unwrapped = url else {
            logger.info("URL for product image is nil. Returning cell without image.")
            return productCell
        }
        // check if the image is already in the cache
        if let img = imageCache[unwrapped.absoluteString] {
            productCell.detailImageView.image = img
        } else {
            // The image is not cached yet, so download it.
            loadImageFrom(unwrapped) { image in
                productCell.detailImageView.image = image
            }
        }
        // Only visible on regular
        productCell.descriptionText = product.longDescription ?? ""

        return productCell
    }
    
    // MARK: - Search bar
    /**
     Setting up the Search Bar and setting the ProductsTableViewController as delegate.
     */
    private func setupSearchBar() {
        // Search Controller setup
        searchController = FUISearchController(searchResultsController: nil)

        // Handle the search result directly in the ProductsTableViewController
        searchController!.searchResultsUpdater = self
        searchController!.hidesNavigationBarDuringPresentation = false
        searchController!.searchBar.placeholderText = NSLocalizedString("Search for products...", comment: "")
        searchController!.searchBar.isBarcodeScannerEnabled = false

        // Set the search bar to the table header view like we did with the KPI Header.
        self.tableView.tableHeaderView = searchController!.searchBar
    }
    
    /**
     Verify if the search text is empty or not
     */
    private func searchTextIsEmpty() -> Bool {
       return searchController?.searchBar.text?.isEmpty ?? true
    }
    
    /**
     Verify if the user is currently searching or not
     */
    private func isSearching() -> Bool {
        return searchController?.isActive ?? false && !searchTextIsEmpty()
    }
    
    /**
     Actual search logic for finding the correct products for the term the user is searching for
     */
    private func searchProducts(_ searchText: String) {
        searchedProducts = products.filter({( product : Product) -> Bool in
            // Make sure the string is completely lower-cased or upper-cased. Either way makes it easier for you to
            // compare strings.
            return product.name?.lowercased().contains(searchText.lowercased()) ?? false
        })

        // Don't forget to trigger a reload.
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating extension

extension ProductsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {

            // Simply call the search logic method and pass the searched for text here!
            // You could check if the search text's length is at least 3 characters
            // to not trigger the search for each and every single character.
            // if searchText.count >= 3 { searchProducts(searchText) }

            searchProducts(searchText)
            return
        }
    }
}
