//
//  TicTacToeViewController.swift
//  TicTacToe
//
//  Created by Christopher Schepman on 9/10/20.
//  Copyright © 2020 Christopher Schepman. All rights reserved.
//

import UIKit

class TicTacToeViewController: UIViewController {
    let game = TicTacToeGame()

    var buttons = [UIButton]()

    let resetButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("RESET?", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        b.setTitleColor(.label, for: .normal)
        b.layer.borderColor = UIColor.black.cgColor
        b.layer.borderWidth = 2.0
        b.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        b.alpha = 0
        return b
    }()

    let statusLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        l.text = "GAME ON"
        l.textAlignment = .center
        l.textColor = .label
        return l
    }()

    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        resetButton.layer.borderColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.cgColor

        game.onGameStateChange = { state in
            var showReset = false
            switch state {
            case .xWin(let winners):
                self.statusLabel.text = "X WINS"
                showReset = true
                for winner in winners {
                    self.buttons[winner].setTitleColor(.red, for: .normal)
                }
            case .oWin(let winners):
                self.statusLabel.text = "O WINS"
                showReset = true
                for winner in winners {
                    self.buttons[winner].setTitleColor(.red, for: .normal)
                }
            case .tie:
                self.statusLabel.text = "TIE"
                showReset = true
            case .inProgress:
                break
            }

            if showReset {
                UIView.animate(withDuration: 0.5) {
                    self.resetButton.alpha = 1.0
                }
            }
        }

        view.backgroundColor = .systemBackground

        for x in (0...TicTacToeGame.sideLength - 1) {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually

            for y in (0...TicTacToeGame.sideLength - 1) {
                let index = (x * TicTacToeGame.sideLength) + (y % TicTacToeGame.sideLength)
                let button = UIButton(type: .system)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                button.setTitleColor(.label, for: .normal)
                button.layer.borderColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
                button.layer.borderWidth = 2.0
                setTitle(on: button, for: game.board[index])
                button.tag = index
                button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)

                buttons.append(button)

                row.addArrangedSubview(button)
            }

            stackView.addArrangedSubview(row)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        statusLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        resetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetButton)
        resetButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5).isActive = true
        resetButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        for button in buttons {
            button.layer.borderColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
        }
        resetButton.layer.borderColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
    }

    private func setTitle(on button: UIButton, for marker: TicTacToeGame.Marker) {
        switch marker {
        case .x:
            button.setTitle("X", for: .normal)
        case .o:
            button.setTitle("O", for: .normal)
        case .empty:
            button.setTitle("", for: .normal)
        }
    }

    private func resetGameButtons() {
        for button in buttons {
            button.setTitle("", for: .normal)
            button.setTitleColor(.label, for: .normal)
        }
    }

    @objc func resetTapped() {
        game.reset()
        resetGameButtons()
        statusLabel.text = "GAME ON"
        UIView.animate(withDuration: 0.3) {
            self.resetButton.alpha = 0
        }
    }

    @objc func buttonTapped(sender: UIButton) {
        if let marker = game.makeMove(index: sender.tag) {
            setTitle(on: sender, for: marker)
        }
    }
}
