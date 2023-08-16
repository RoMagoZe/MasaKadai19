//
//  SecondViewController.swift
//  MasaKadai19
//
//  Created by Mina on 2023/08/15.
//

import UIKit

protocol SecondViewControllerDelegate: AnyObject {
    func didUpdateItems()
}

class SecondViewController: UIViewController {

    enum Mode {
        case add(AddParameter)
        case edit(EditParameter)
    }

    @IBOutlet private weak var inputTextField: UITextField!

    var mode: Mode?
    weak var delegate: SecondViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let mode = mode else { return }

        switch mode {
        case .add:
            inputTextField.text = ""

        case .edit(let parameter):
            inputTextField.text = parameter.item.name
        }
    }

    @IBAction private func didTapCancel(_ sender: Any) {
        guard let mode = mode else { return }

        switch mode {
        case .add(let parameter):
            parameter.cancel()

        case .edit(let parameter):
            parameter.cancel()
        }
    }

    @IBAction private func didTapSave(_ sender: Any) {
        guard let mode = mode else { return }

        switch mode {
        case .add(let parameter):
            parameter.save(inputTextField.text ?? "")

        case .edit(let parameter):
            parameter.save(inputTextField.text ?? "")
        }

        delegate?.didUpdateItems()
    }
}
