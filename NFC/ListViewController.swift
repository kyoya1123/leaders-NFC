import UIKit
import Firebase

class ListViewController: UIViewController {
    
    @IBOutlet var listTableView: UITableView!
    
    var ingridients = [IngridientData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ingridients = UserDefaultsManager.getIngridientData()
        listTableView.reloadData()
    }
    
    func setupTable() {
        listTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil),forCellReuseIdentifier: "Cell")
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let readView = segue.destination as? ReadViewController {
            readView.ingridientData = sender as? IngridientData
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingridients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        cell.setup(ingridients[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ReadViewController", sender: ingridients[indexPath.row])
    }
}
