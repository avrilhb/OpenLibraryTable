//
//  BusquedaISBNViewController.swift
//  LibrosTabla
//
//  Created by Avril  Hernández on 02/06/16.
//  Copyright © 2016 AHB. All rights reserved.
//

import UIKit
import CoreData

class BusquedaISBNViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var isbn: UITextField!
    @IBOutlet weak var tituloLibro: UILabel!
    @IBOutlet weak var autoresLibro: UILabel!
    @IBOutlet weak var portadaLibro: UIImageView!
    
    var contexto : NSManagedObjectContext? = nil
    
    func sincrono(isbn:String) {
        let libroEntidad = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.contexto!)
        let peticion = libroEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petLibro", substitutionVariables: ["isbn":isbn])
        do{
            let libroEntidad2 = try self.contexto?.executeFetchRequest(peticion!)
            if libroEntidad2?.count > 0 {
                self.isbn.text = nil
                
                let alert = UIAlertController(title: "Error", message: "Este libro ya ha sigo agregado. Intente una nueva bùsqueda", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
        }
        catch{
            
        }
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        let url = NSURL(string: urls)
        let datos: NSData? = NSData(contentsOfURL: url!)
        
        if datos == nil {
            tituloLibro.hidden = true
            autoresLibro.hidden = true
            portadaLibro.hidden = true
            navigationItem.rightBarButtonItem?.enabled = false
            
            let alert = UIAlertController(title: "Error", message: "No hay conexión a Internet", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }else{
            let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            if texto == "{}" {
                tituloLibro.hidden = true
                autoresLibro.hidden = true
                portadaLibro.hidden = true
                navigationItem.rightBarButtonItem?.enabled = false
                
                let alert = UIAlertController(title: "Error", message: "Libro no encontrado.", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                
                do{
                    navigationItem.rightBarButtonItem?.enabled = true
                    tituloLibro.hidden = false
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    
                    let isbnJson = json as! NSDictionary
                    let isbnQuery = isbnJson["ISBN:\(isbn)"] as! NSDictionary
                    //var autores : NSDictionary
                    var autoresString = ""
                    if(isbnQuery["authors"] != nil){
                        let autores = isbnQuery["authors"] as! [NSDictionary]
                        
                        for autor in autores{
                            if autoresString == ""{
                                autoresString += autor["name"] as! NSString as String
                            }else{
                                autoresString += ", "
                                autoresString += autor["name"] as! NSString as String
                            }
                        }
                    }
                    
                    if autoresString == ""{
                        autoresLibro.hidden = false
                        self.autoresLibro.text = "No disponible"
                    }else{
                        autoresLibro.hidden = false
                        self.autoresLibro.text = autoresString
                    }
                   
                    let portada = isbnQuery["cover"] as! NSDictionary?
                    
                    if portada == nil{
                        portadaLibro.hidden = true
                        portadaLibro.image = UIImage(named: "not found")
                    }else{
                        let portadaMedium = portada!["medium"] as! NSString as String
                        
                        if let url  = NSURL(string: portadaMedium),
                            data = NSData(contentsOfURL: url)
                        {
                            portadaLibro.hidden = false
                            portadaLibro.image = UIImage(data: data)
                        }
                    }
                    
                    self.tituloLibro.text = isbnQuery["title"] as! NSString as String
                    
                }catch _{
                    
                    
                }
                
            }
        }
        
    }

    @IBAction func buscarLibro(sender: AnyObject) {
        sender.resignFirstResponder() //Desaparecer el teclado
        sincrono(isbn.text!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.isbn.delegate = self
        tituloLibro.hidden = true
        autoresLibro.hidden = true
        portadaLibro.hidden = true
        navigationItem.rightBarButtonItem?.enabled = false
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "exit" {
            let mvc = segue.destinationViewController as! MasterViewController
            mvc.isbn = self.isbn.text!
            mvc.autores = self.autoresLibro.text!
            mvc.titulo = self.tituloLibro.text!
            if self.portadaLibro.image != nil {
                mvc.portada = self.portadaLibro.image!
            }else{
                let imgVacia : UIImage = UIImage(named: "alert")!
                mvc.portada = imgVacia
            
        }
        
            /*mvc.libro.append([self.tituloLibro.text!, self.isbn.text!, self.autoresLibro.text!])
            if self.portadaLibro.image != nil {
                mvc.portada.append(self.portadaLibro.image!)
            }else{
                let imgVacia : UIImage = UIImage()
                mvc.portada.append(imgVacia)
                
            }*/
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
