//
//  ViewController.swift
//  MusicApp
//
//  Created by Eprem Sargsyan on 10.05.23.
//


import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        performSearch()
    }
    
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
    
    var searchResults = [SearchResult]()
    var hasSearched = false
    var isLoading = false
    var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVIew.contentInset = UIEdgeInsets(top: 91, left: 0, bottom: 0, right: 0)
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell,
                            bundle: nil)
        tableVIew.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableVIew.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        searchBar.becomeFirstResponder()
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableVIew.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
    }
    
    func iTunesURL(searchText: String, category: Int) -> URL {
        let kind: String
        switch category {
            case 1: kind = "musicTrack"
            case 2: kind = "software"
            case 3: kind = "ebook"
            default: kind = ""
        }
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/search?" + "term=\(encodedText)&limit=200&entity=\(kind)"
        let url = URL(string: urlString)
        return url!
    }
    
    func performStoreRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Download Error \(error.localizedDescription)")
            showNetworkError()
            return nil
        }
    }
    
    func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder() 
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    func showNetworkError() {
        let alert = UIAlertController(
                title: "Whoopss...",
                message: "There was an error accessing the iTunes Store." +
                " Please try again.",
                preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func performSearch() {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            isLoading = true
            tableVIew.reloadData()
            dataTask?.cancel()
            hasSearched = true
            searchResults = []
            
            let queue = DispatchQueue.global()
            
            queue.async { [self] in
                let url = self.iTunesURL(searchText: searchBar.text!,
                                         category: segmentedControl.selectedSegmentIndex)
                let session = URLSession.shared
                self.dataTask = session.dataTask(with: url, completionHandler: {data, response, error in
                    if let error = error as NSError?, error.code == -999 {
                        print("Failure! \(error.localizedDescription)")
                    }
                    else if let httpResponse = response as? HTTPURLResponse,
                        httpResponse.statusCode == 200 {
                        if let data = data {
                            self.searchResults = self.parse(data: data)
                            self.searchResults.sort(by: <)
                            DispatchQueue.main.async {
                                self.isLoading = false
                                self.tableVIew.reloadData()
                            }
                            return
                        }
                    } else {
                        print("Success! \(response!)")
                    }
                    
                    DispatchQueue.main.async {
                        self.hasSearched = false
                        self.isLoading = false
                        self.tableVIew.reloadData()
                        self.showNetworkError()
                    }
                })
                self.dataTask?.resume()
                
                if let data = self.performStoreRequest(with: url) {
                    self.searchResults = self.parse(data: data)
                    self.searchResults.sort(by: <)
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.tableVIew.reloadData()
                    }
                    return
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        }
        else if !hasSearched {
            return 0
        }
        else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            
            return cell
        }
        else if searchResults.isEmpty {
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell,
                for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:
                    TableView.CellIdentifiers.searchResultCell,
                    for: indexPath) as! SearchResultCell
            let searchResult = searchResults[indexPath.row]
            cell.configure(for: searchResult)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return searchResults.isEmpty || isLoading ? nil : indexPath
    }
}

