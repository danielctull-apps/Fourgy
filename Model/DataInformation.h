//
//  DataInformation.h
//  iPod
//
//  Created by Daniel Tull on 08.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface DataInformation :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * lastUpdated;

@end



