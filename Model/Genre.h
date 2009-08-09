//
//  Genre.h
//  iPod
//
//  Created by Daniel Tull on 08.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Artist;
@class Song;

@interface Genre :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* songs;
@property (nonatomic, retain) NSSet* artists;

@end


@interface Genre (CoreDataGeneratedAccessors)
- (void)addSongsObject:(Song *)value;
- (void)removeSongsObject:(Song *)value;
- (void)addSongs:(NSSet *)value;
- (void)removeSongs:(NSSet *)value;

- (void)addArtistsObject:(Artist *)value;
- (void)removeArtistsObject:(Artist *)value;
- (void)addArtists:(NSSet *)value;
- (void)removeArtists:(NSSet *)value;

@end

