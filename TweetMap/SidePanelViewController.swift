//
//  LeftViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

protocol SidePanelViewControllerDelegate {
   func locationSelected(location: TweetMapLocation)
}

class SidePanelViewController: UIViewController {
   
   @IBOutlet weak var tableView: UITableView!
   
   var delegate: SidePanelViewControllerDelegate?
   
   var selectedLocation: TweetMapLocation?
   var menuOptions: [TweetMapLocation] = [
      .Anchorage,
      .Atlanta,
      .Austin,
      .Chicago,
      .Detroit,
      .Honolulu,
      .LasVegas,
      .LosAngeles,
      .Miami,
      .NewYorkCity,
      .SanFransisco,
      .Seattle,
      .Washington
   ]
   
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
      
      let location = menuOptions[indexPath.row]
      cell.textLabel?.text = location.fullName
      cell.textLabel?.textColor = UIColor.whiteColor()
      cell.textLabel?.font = UIFont.systemFontOfSize(14, weight: 2)
      
      let color = location == selectedLocation ? UIColor(colorLiteralRed: 0, green: 84.0/255, blue: 139.0/255, alpha: 1) : UIColor.clearColor()
      cell.backgroundColor = color
      return cell
   }
   
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate
{   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      let location = menuOptions[indexPath.row]
      delegate?.locationSelected(location)
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