import UIKit
import CoreNFC

class ReadViewController: UIViewController {
    
    @IBOutlet var ingridientImage: UIImageView!
    @IBOutlet var buyDateLabel: UILabel!
    @IBOutlet var expirationDateLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        read()
    }
    

    @objc func read() {
        let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session.alertMessage = NSLocalizedString("alertMessage", comment: "")
        session.begin()
    }
}

extension ReadViewController: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        if messages[0].records.isEmpty
        {
            DispatchQueue.main.async {
//                UIAlertController(NSLocalizedString("empty", comment: "")).show()
            }
        } else {
            if let data = messages[0].records[1].wellKnownTypeTextPayload().0?.data(using: .utf8), let ingridientData = try? JSONDecoder().decode(IngridientData.self, from: data) {
                    DispatchQueue.main.async { [self] in
                        title = ingridientData.name
                        buyDateLabel.text = ingridientData.buyDate
                        expirationDateLabel.text = ingridientData.expirationDate
                    }
            } else {
                DispatchQueue.main.async {
//                    UIAlertController(NSLocalizedString("readingError", comment: "")).show()
//                    self.formView.subviews.forEach {
//                        $0.removeFromSuperview()
//                    }
                }
            }
        }
    }
}
