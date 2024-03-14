//
//  Persistence.swift
//  Grouper 2
//
//  Created by 王首之 on 1/14/24.
//

//
//
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let instance = People(context: viewContext)
        instance.myId = UUID()
        instance.name = "Demo Person"
        instance.category = "Class 1"
        instance.grade = "12"
        instance.type = "Student"
        instance.personality = "ESFJ"
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let peopleEntity = NSEntityDescription()
        peopleEntity.name = "People"
        peopleEntity.managedObjectClassName = "People"
        
        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.type = .string
        peopleEntity.properties.append(nameAttribute)
        
        let categoryAttribute = NSAttributeDescription()
        categoryAttribute.name = "category"
        categoryAttribute.type = .string
        peopleEntity.properties.append(categoryAttribute)
        
        let gradeAttribute = NSAttributeDescription()
        gradeAttribute.name = "grade"
        gradeAttribute.type = .string
        peopleEntity.properties.append(gradeAttribute)
        
        let typeAttribute = NSAttributeDescription()
        typeAttribute.name = "type"
        typeAttribute.type = .string
        peopleEntity.properties.append(typeAttribute)
        
        let personalityAttribute = NSAttributeDescription()
        personalityAttribute.name = "personality"
        personalityAttribute.type = .string
        peopleEntity.properties.append(personalityAttribute)
        
        let myIdAttribute = NSAttributeDescription()
        myIdAttribute.name = "myId"
        myIdAttribute.type = .uuid
        peopleEntity.properties.append(myIdAttribute)
        
      
        
        let model = NSManagedObjectModel()
        model.entities = [peopleEntity]
        
        
        let container = NSPersistentContainer(name: "People", managedObjectModel: model)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        self.container = container
    }
    
    
}
