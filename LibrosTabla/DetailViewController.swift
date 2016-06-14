//
//  DetailViewController.swift
//  LibrosTabla
//
//  Created by Avril  Hernández on 31/05/16.
//  Copyright © 2016 AHB. All rights reserved.
//

import UIKit
import CoreData

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
    
    var contexto : NSManagedObjectContext? = nil

    
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
        }
        self.isbnLibro.text = isbn
        self.tituloLibro.text = titulo
        self.autoresLibro.text = autores
        self.portadaLibro.image = portada*/
        
        let libroEntidad = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.contexto!)
        let peticion = libroEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petLibro", substitutionVariables: ["isbn": isbn])
        
        do{
            let libroEntidad2 = try self.contexto?.executeFetchRequest(peticion!)
            for libroResultadoEntidad in libroEntidad2!{
                let titulo = libroResultadoEntidad.valueForKey("titulo") as! String
                let autores = libroResultadoEntidad.valueForKey("autores") as! String
                let portada : UIImage? = UIImage(data: libroResultadoEntidad.valueForKey("portada") as! NSData)
                
                self.isbnLibro.text = isbn
                self.tituloLibro.text = titulo
                self.autoresLibro.text = autores
                self.portadaLibro.image = portada
                
            }
        }
        catch {
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        self.configureView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

