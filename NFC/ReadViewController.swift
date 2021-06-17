import UIKit
import CoreNFC
import AlamofireImage
import EventKit

class ReadViewController: UIViewController {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ingridientImage: UIImageView!
    @IBOutlet var buyDateLabel: UILabel!
    @IBOutlet var expirationDateLabel: UILabel!
    @IBOutlet var memoTextView: UITextView!
    @IBOutlet var addToRemingderButton: UIButton!
    
    let store = EKEventStore()
    
    var ingridientData: IngridientData!

    override func viewDidLoad() {
        super.viewDidLoad()
        ingridientImage.rounded(10)
        backgroundView.rounded(10)
        memoTextView.rounded(10)
        addToRemingderButton.rounded(10)
        addToRemingderButton.addTarget(self, action: #selector(didTapAddToReminder), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let ingridientData = ingridientData {
            self.ingridientData = ingridientData
            displayData()
        } else {
            read()
        }
    }
    
    @objc func didTapAddToReminder() {
        guard let ingridientData = ingridientData else { return }
        askForPermission { [self] in
            let newReminder = EKReminder(eventStore: store)
            newReminder.title = ingridientData.name
            try! store.save(newReminder, commit: true)
            UIAlertController("リマインダーに追加されました！").show()
        }
    }
    
    func askForPermission(grantedAction: @escaping () -> Void) {
        store.requestAccess(to: .reminder) { (granted, error) in
            if let error = error {
                print(error)
                return
            }

            if granted {
                grantedAction()
            }
        }
    }

    @objc func read() {
        let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session.alertMessage = "タグに近づけてください"
        session.begin()
    }
    
    func displayData() {
        nameLabel.text = ingridientData.name
        buyDateLabel.text = ingridientData.buyDate
        expirationDateLabel.text = ingridientData.expirationDate
        memoTextView.text = ingridientData.memoText
        FireStorageManager.getImageUrl(ingridientData.uuid) { [self] url in
            if let url = url {
                ingridientImage.af.setImage(withURL: url)
            }
        }
    }
}

extension ReadViewController: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        if messages[0].records.isEmpty
        {
        } else {
            if let data = messages[0].records[1].wellKnownTypeTextPayload().0?.data(using: .utf8), let ingridientData = try? JSONDecoder().decode(IngridientData.self, from: data) {
                    DispatchQueue.main.async { [self] in
                        self.ingridientData = ingridientData
                        displayData()
                        UserDefaultsManager.updateIngridientData(ingridientData)
                    }
            }
        }
    }
}
