//
//  Album.h
//  iPod
//
//  Created by Daniel Tull on 08.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Artist;
@class Composer;
@class Song;

@interface Album :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * discCount;
@property (nonatomic, retain) NSNumber * trackCount;
@property (nonatomic, retain) Artist * artist;
@property (nonatomic, retain) NSSet* composers;
@property (nonatomic, retain) NSSet* songs;

@end


@interface Album (CoreDataGeneratedAccessors)
- (void)addComposersObject:(Composer *)value;
- (void)removeComposersObject:(Composer *)value;
- (void)addComposers:(NSSet *)value;
- (void)removeComposers:(NSSet *)value;

- (void)addSongsObject:(Song *)value;
- (void)removeSongsObject:(Song *)value;
- (void)addSongs:(NSSet *)value;
- (void)removeSongs:(NSSet *)value;

@end

