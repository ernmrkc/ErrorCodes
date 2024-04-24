import UIKit

/**
        This class was created to list fault folders and their sub-faults.
 */
class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /**
            This struct was created to store, show and select sub-faults. They are sub-cell of tableview.
     */
    class Section {
        let title: String
        let options: [String]
        var isOpened: Bool = false
        
        init(title: String, options: [String], isOpened: Bool = false){
            self.title = title
            self.options = options
            self.isOpened = isOpened
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var MainFaultCell = String()
    private var SubFaultCell = String()
    
    // Names of the fault folders.
    let MainFaultArray: [String] = ["128", "130", "136", "140", "144", "150", "163", "185", "206", "216", "220", "222", "223", "DCI 420_"]
    
    private var sections = [Section]()
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
            
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        
        // Automatically fills sub-cell of fault folders.
        for mainFaultName in MainFaultArray {
            var SubFaultArray = [String]()
            let assetURL = bundleURL.appendingPathComponent(mainFaultName)
            
            do {
                let contents = try fileManager.contentsOfDirectory(at: assetURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)
                
                for item in contents {
                    SubFaultArray.append(item.lastPathComponent)
                }
            }
            catch let error as NSError {
                print(error)
            }
            // Sorts the sub-faults array alphabetically and numerically.
            SubFaultArray.sort(by: {$0.compare($1, options: .numeric) == .orderedAscending})
            let sec = Section(title: mainFaultName, options: SubFaultArray.compactMap({return "\t\($0)"}))
            sections.append(sec)
        }
    }
    
    /**
            This function returns count of sections.
            Represents the number of cells of the tableview.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    /**
            This function returns count of sub-cell of main cell.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        if section.isOpened {
            return section.options.count + 1
        }
        else {
            return 1
        }
    }
    
    /**
            This function adds cell and sub-cell to tableview.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = sections[indexPath.section].title
        }
        else {
            cell.textLabel?.text = sections[indexPath.section].options[indexPath.row - 1]
        }
        return cell
    }
    
    /**
            It will operate according to the selected cell.
     
            If fault folder cell was selected: Shows the sub-fault cells.
            If sub-fault cell was selected: Shows PDF of the selected fault with a segue.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = self.tableView.cellForRow(at: indexPath)
        
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
            
            MainFaultCell = (cell?.textLabel?.text)!
        }
        else {
            SubFaultCell = (cell?.textLabel?.text)!
            SubFaultCell = SubFaultCell.replacingOccurrences(of: "\t", with: "")
            SubFaultCell = SubFaultCell.replacingOccurrences(of: ".pdf", with: "")
            performSegue(withIdentifier: "toPDFVC", sender: nil)
        }
    }
    
    /**
            Sends the data to the corresponding controller.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPDFVC" {
            let destinationVC = segue.destination as! PDFViewController
            destinationVC.mainFaultPDFName = MainFaultCell
            destinationVC.subFaultPDFName = SubFaultCell
        }
    }
}
