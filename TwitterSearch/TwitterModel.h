//
//  TwitterModel.h
//  TwitterSearch
//
//  Created by Pramod Sharma on 06/05/16.
//  Copyright © 2016 Pramod Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TwitterModel : NSManagedObject
@property (nonatomic, strong) NSString *title;
@end
