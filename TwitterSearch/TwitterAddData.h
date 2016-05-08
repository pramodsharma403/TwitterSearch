//
//  TwitterAddData.h
//  TwitterSearch
//
//  Created by Pramod Sharma on 06/05/16.
//  Copyright © 2016 Pramod Sharma. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TwitterModel.h"

@interface TwitterAddData : NSManagedObject

+ (TwitterModel *)storeDataInDatabase:(NSString *)title inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSArray *)fetchDataFromDB:(NSManagedObjectContext *)managedObjectContext;

@end
