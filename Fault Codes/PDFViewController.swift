import UIKit
import PDFKit                           // This package is imported to use PDF actions.

class PDFViewController: UIViewController {

    private var pdfView: PDFView?
    private var pdfDocument: PDFDocument?
    
    public var mainFaultPDFName = String()
    public var subFaultPDFName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Adds a button to the right of the navigation bar for sharing functionality.
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(sendDocButton))
        
        showPDFFile()
    }

    /**
            This function shows corresponding PDF file according to the subFaultPDFName and mainFaultPDFName variables.
     */
    func showPDFFile() {
        pdfView = PDFView(frame: self.view.bounds)
        self.view.addSubview(pdfView!)
        
        guard let path = Bundle.main.url(forResource: subFaultPDFName, withExtension: "pdf", subdirectory: mainFaultPDFName) else {
            print("unable to locate file")
            return
        }
        
        pdfDocument = PDFDocument(url: path)
        pdfView!.document = pdfDocument
    }
    
    /**
            This function share corresponding PDF file via any application.
     */
    @objc func sendDocButton(){
        guard let path = Bundle.main.url(forResource: subFaultPDFName, withExtension: "pdf", subdirectory: mainFaultPDFName) else {
            print("unable to locate file")
            return
        }
        
        let uiActivity = UIActivityViewController(activityItems: [subFaultPDFName, path], applicationActivities: nil)
        if(uiActivity.responds(to: #selector(getter: uiActivity.completionWithItemsHandler))){
            uiActivity.completionWithItemsHandler = {(type, isCompleted, items, error) in
                if isCompleted {
                    print("Completed")
                }
            }
        }
        self.present(uiActivity, animated: true, completion: nil)
    }
}
