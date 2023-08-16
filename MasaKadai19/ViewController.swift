//
//  ViewController.swift
//  MasaKadai19
//
//  Created by Mina on 2023/08/15.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var items = Fruits.defaultItems
    private let checkMark = UIImage(named: "check-mark")
    private let itemsKey = "savedItems"
    private var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let navigationController = segue.destination as? UINavigationController,
              let secondViewController = navigationController.topViewController as? SecondViewController else {
            return
        }

        if segue.identifier == "addSegue" {
            prepareForAddSegue(secondVC: secondViewController)
        } else if segue.identifier == "AccessorySegue" {
            prepareForAccessorySegue(secondVC: secondViewController)
        }
    }

    // MARK: - プライベート関数
    // 保存 Data型に変換してから保存
    private func saveItems() {
        if let encodeData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodeData, forKey: itemsKey)
        }
    }
    // 読み込み 読み込み時に元の構造体に戻す
    private func loadItems() {
        if let savedData = UserDefaults.standard.data(forKey: itemsKey),
           let decodedItems = try? JSONDecoder().decode([Item].self, from: savedData) {
            items = decodedItems
        }
    }

    private func prepareForAddSegue(secondVC: SecondViewController) {

        secondVC.delegate = self

        secondVC.mode = .add(AddParameter(
            cancel: { [weak self] in
                self?.dismiss(animated: true)
            }, save: { [weak self] newName in
                self?.items.append(Item(name: newName, isChecked: false))
                self?.tableView.reloadData()

                self?.dismiss(animated: true)
            })
        )
    }

    private func prepareForAccessorySegue(secondVC: SecondViewController) {
        guard let indexPath = selectedIndexPath else { return }

        secondVC.delegate = self

        secondVC.mode = .edit(EditParameter(
            item: items[indexPath.row],
            cancel: { [weak self] in
                self?.dismiss(animated: true)
            }, save: { [weak self] newName in
                guard let strongSelf = self else { return }

                strongSelf.items[indexPath.row].name = newName
                strongSelf.tableView.reloadData()

                strongSelf.dismiss(animated: true)
            })
        )
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.imageView?.image = item.isChecked ? checkMark : nil

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isChecked.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        saveItems()
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "AccessorySegue", sender: nil)
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveItems()
        }
    }
}

extension ViewController: SecondViewControllerDelegate {
    func didUpdateItems() {
        saveItems()
    }
}
