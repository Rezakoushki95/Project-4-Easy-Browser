//
//  ViewController.swift
//  Project4 Easy Browser
//
//  Created by Reza Koushki on 06/02/2023.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var websites = ["apple.com", "hackingwithswift.com"]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.tableView.delegate = self
		self.tableView.dataSource = self

    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showPage" {
			let destinationVC = segue.destination as! DetailViewController
			let selectedIndexPath = tableView.indexPathForSelectedRow
			destinationVC.website = websites[selectedIndexPath!.row]
		}
	}
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return websites.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = websites[indexPath.row]
		return cell
	}
	
	
}
