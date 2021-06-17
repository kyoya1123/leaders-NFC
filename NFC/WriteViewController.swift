import UIKit
import Firebase
import CoreNFC

class WriteViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var datePickers: [UIDatePicker]!
    @IBOutlet var memoTextView: UITextView!
    @IBOutlet var imageButton: UIButton!
    @IBOutlet var writeButton: UIButton!
    
    var ingridientData = IngridientData(name: "", buyDate: Date().dateString, expirationDate: Date().dateString)
    var ingridientImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupTextView()
        setupButton()
        setupDatePicker()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupTextField() {
        nameTextField.delegate = self
    }
    
    func setupTextView() {
        memoTextView.rounded(10)
        memoTextView.delegate = self
    }
    
    func setupDatePicker() {
        datePickers.forEach { $0.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged) }
    }
    
    @objc func didTapDone() {
        view.endEditing(true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        switch sender.tag {
        case 0:
            ingridientData.buyDate = sender.date.dateString
        case 1:
            ingridientData.expirationDate = sender.date.dateString
        default: break
        }
    }
    
    func setupButton() {
        imageButton.rounded(10)
        imageButton.addTarget(self, action: #selector(didTapImage), for: .touchUpInside)
        writeButton.rounded()
        writeButton.addTarget(self, action: #selector(didTapWrite), for: .touchUpInside)
    }
    
    @objc func didTapImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc func didTapWrite() {
        let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session.alertMessage = "タグに近づけてください"
        session.begin()
    }
}

extension WriteViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        ingridientData.memoText = textView.text
        return true
    }
}

extension WriteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        ingridientData.name = text
    }
}

extension WriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        ingridientImage = image
        imageButton.setImage(nil, for: .normal)
        imageButton.setBackgroundImage(image, for: .normal)
    }
}

extension WriteViewController: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print(messages[0].records[0].payload)
    }
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard tags.count == 1 else {
            session.invalidate(errorMessage: "Can not write to more than one tag.")
            return
        }
        let currentTag = tags.first!
        session.connect(to: currentTag) { [self] error in
            guard error == nil else {
                session.invalidate(errorMessage: "Could not connect to tag.")
                return
            }
            currentTag.queryNDEFStatus { status, capacity, error in
                guard error == nil else {
                    session.invalidate(errorMessage: "Could not query status of tag.")
                    return
                }
                switch status {
                case .notSupported: session.invalidate(errorMessage: "Tag is not supported.")
                case .readOnly:     session.invalidate(errorMessage: "Tag is only readable.")
                case .readWrite:
                    guard let encodedData = try? JSONEncoder().encode(ingridientData) else { return }
                    guard let tmpTextPayload = NFCNDEFPayload.wellKnownTypeTextPayload(string: "", locale: Locale(identifier: "en")) else { return }
                    guard let textPayload = NFCNDEFPayload.wellKnownTypeTextPayload(string: String(data: encodedData, encoding: .utf8)!, locale: Locale(identifier: "en")) else { return }
                    let message = NFCNDEFMessage(records: [tmpTextPayload, textPayload])
                    currentTag.writeNDEF(message) { error in
                        if error != nil {
                            print(error?.localizedDescription ?? "No Data")
                            session.invalidate(errorMessage: NSLocalizedString("fail", comment: ""))
                        } else {
                            session.alertMessage = NSLocalizedString("complete", comment: "")
                            UserDefaultsManager.updateIngridientData(ingridientData)
                            FireStorageManager.postImage(ingridientImage, ingridientData.uuid)
                        }
                        session.invalidate()
                    }
                @unknown default:   session.invalidate(errorMessage: "Unknown status of tag.")
                }
            }
        }
    }
}
