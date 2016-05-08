//
//  TwitterAddData.m
//  TwitterSearch
//
//  Created by Pramod Sharma on 06/05/16.
//  Copyright © 2016 Pramod Sharma. All rights reserved.
//

#import "TwitterAddData.h"

@implementation TwitterAddData

+ (TwitterModel *)storeDataInDatabase:(NSString *)title
     inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    TwitterModel *data = [NSEntityDescription insertNewObjectForEntityForName:@"TwitterResult" inManagedObjectContext:managedObjectContext];
    [data setTitle:title];
    return data;
}

+ (NSArray *)fetchDataFromDB:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TwitterResult"];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    if (error != nil) {
        //error
    }
    else {
        //Deal with success
    }
    return  results;
}

@end
