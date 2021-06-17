import UIKit
import AlamofireImage

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ingridientImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        ingridientImageView.rounded(10)
        ingridientImageView.addBorder(.lightGray, 1)
    }
    
    func setup(_ ingridientData: IngridientData) {
        nameLabel.text = ingridientData.name
        print(ingridientData)
        FireStorageManager.getImageUrl(ingridientData.uuid) { [self] url in
            if let url = url {
                ingridientImageView.af.setImage(withURL: url)
            }
        }
    }
}
