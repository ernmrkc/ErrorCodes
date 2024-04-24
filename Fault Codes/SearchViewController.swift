import UIKit

/**
        This class was created to perform searches with the search bar.
 */
class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var MainFaultCell = String()            // Name of fault folder.
    private var SubFaultCell = String()             // Name of fault.
    
    var faulData = FaultData()
    var filteredData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredData = faulData.data
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    // TODO: viewWillLoad
    
    
    /**
            This function returns count of filtered data.
            Represents the number of cells of the tableview.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    /**
            This function adds cells to tableview.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    
    /**
            This function fills mainFaultCell and subFaultCell according to the selected cell.
            And calls corresponding PDF view with segue.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = self.tableView.cellForRow(at: indexPath)
        MainFaultCell = (cell?.textLabel?.text)!
        let PDFName = MainFaultCell.components(separatedBy: "-")
        MainFaultCell = PDFName[0]
        SubFaultCell = PDFName[1]
        performSegue(withIdentifier: "toPDFVC_2", sender: nil)
    
    }
    
    /**
            Ends the editing of the searchbar when tableview was scrolled.
     */
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    /**
            Ends the editing of the searchbar when search button was clicked.
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    /**
            The filtered data is refreshed each time the searchbar text is changed.
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == "" {
            filteredData = faulData.data
        }
        
        for word in faulData.data{
            if word.uppercased().contains(searchText.uppercased()){
                filteredData.append(word)
            }
        }
        self.tableView.reloadData()
    }
    
    /**
            Sends the data to the corresponding controller.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPDFVC_2" {
            let destinationVC = segue.destination as! PDFViewController
            destinationVC.mainFaultPDFName = MainFaultCell
            destinationVC.subFaultPDFName = SubFaultCell
        }
    }
}
