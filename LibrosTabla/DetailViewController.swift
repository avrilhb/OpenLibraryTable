//
//  DetailViewController.swift
//  LibrosTabla
//
//  Created by Avril  Hernández on 31/05/16.
//  Copyright © 2016 AHB. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var isbnLibro: UILabel!
    @IBOutlet weak var tituloLibro: UILabel!
    @IBOutlet weak var autoresLibro: UILabel!
    @IBOutlet weak var portadaLibro: UIImageView!
    
    var isbn : String = ""
    var titulo : String = ""
    var autores : String = ""
    var portada : UIImage = UIImage()
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        /*if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.valueForKey("timeStamp")!.description
            }
        }*/
        self.isbnLibro.text = isbn
        self.tituloLibro.text = titulo
        self.autoresLibro.text = autores
        self.portadaLibro.image = portada
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

