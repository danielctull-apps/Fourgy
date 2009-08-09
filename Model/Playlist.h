//
//  Playlist.h
//  iPod
//
//  Created by Daniel Tull on 08.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Song;

@interface Playlist :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* songs;

@end


@interface Playlist (CoreDataGeneratedAccessors)
- (void)addSongsObject:(Song *)value;
- (void)removeSongsObject:(Song *)value;
- (void)addSongs:(NSSet *)value;
- (void)removeSongs:(NSSet *)value;

@end

