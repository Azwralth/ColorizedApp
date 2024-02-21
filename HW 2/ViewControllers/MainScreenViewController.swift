//
//  MainScreenColorViewController.swift
//  HW 2
//
//  Created by Владислав Соколов on 20.02.2024.
//  Copyright © 2024 Alexey Efimov. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func updateBackgroundColor(_ color: UIColor)
}

final class MainScreenViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingVC = segue.destination as? SettingsViewController
        settingVC?.delegate = self
        settingVC?.backgroundColor = view.backgroundColor
    }
}

// MARK: - SettingsViewControllerDelegate

extension MainScreenViewController: SettingsViewControllerDelegate {
    func updateBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
