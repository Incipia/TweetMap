//
//  LeftViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

protocol SidePanelViewControllerDelegate {
    func menuSelected(selected: AnyObject)
}

class SidePanelViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
    
    var delegate: SidePanelViewControllerDelegate?
  
  var menuOptions = ["Settings", "Cities", "Trending Near Me"]
  
  struct TableView {
    struct CellIdentifiers {
      static let MenuCell = "MenuCell"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.reloadData()
  }
  
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuOptions.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.MenuCell, forIndexPath: indexPath) as! MenuCell
    cell.textLabel?.text = menuOptions[indexPath.row]
    cell.textLabel?.textColor = UIColor.whiteColor()
    return cell
  }
  
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let selectedOption = menuOptions[indexPath.row]
    print(selectedOption)
    delegate?.menuSelected(selectedOption)
  }
  
}

class MenuCell: UITableViewCell {
  
//  @IBOutlet weak var animalImageView: UIImageView!
//  @IBOutlet weak var imageNameLabel: UILabel!
//  @IBOutlet weak var imageCreatorLabel: UILabel!
  
//  func configureForAnimal(animal: Animal) {
//    animalImageView.image = animal.image
//    imageNameLabel.text = animal.title
//    imageCreatorLabel.text = animal.creator
//  }
  
}