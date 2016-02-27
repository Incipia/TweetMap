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
   
   var menuOptions = ["Contact Us", "Rate Us"]
   
   struct TableView {
      struct CellIdentifiers {
         static let MenuCell = "MenuCell"
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      tableView.reloadData()
      tableView.tableFooterView = UIView()
      tableView.separatorColor = UIColor.clearColor()
      
      let selectionView = UIView()
      selectionView.backgroundColor = UIColor(colorLiteralRed: 0, green: 84.0/255, blue: 139.0/255, alpha: 1)
      MenuCell.appearance().selectedBackgroundView = selectionView
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
      cell.textLabel?.font = UIFont.systemFontOfSize(15, weight: 3)
      cell.backgroundColor = UIColor.clearColor()
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
   
//   func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//      return true
//   }
//   
//   func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
//      let cell = tableView.cellForRowAtIndexPath(indexPath)
//      cell?.contentView.backgroundColor = UIColor.orangeColor()
//   }
//   
//   func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
//      let cell = tableView.cellForRowAtIndexPath(indexPath)
//      cell?.contentView.backgroundColor = UIColor.clearColor()
//      cell?.backgroundColor = UIColor.clearColor()
//   }
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