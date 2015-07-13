//
//  DataStore.m
//  Footnotes
//
//  Created by Alan Scarpa on 7/10/15.
//  Copyright (c) 2015 Skytop Designs. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore
@synthesize managedObjectContext = _managedObjectContext;



#pragma mark - Singleton

+ (instancetype)sharedDataStore {
    static DataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[DataStore alloc] init];
    });
    
    return _sharedDataStore;
}


- (void)save
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    
    NSURL *storeURL = [[self dataStoreDirectory] URLByAppendingPathComponent:@"Data.sqlite"];
    
    NSError *error = nil;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Data" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)dataStoreDirectory
{
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.skytopdesigns.Footnotes"];
}


@end
