//
//  Song.h
//  iPod
//
//  Created by Daniel Tull on 08.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Album;
@class Artist;
@class Composer;
@class Genre;
@class Playlist;

@interface Song :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * discNumber;
@property (nonatomic, retain) NSNumber * trackNumber;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * lyrics;
@property (nonatomic, retain) NSSet* playlists;
@property (nonatomic, retain) Album * album;
@property (nonatomic, retain) Artist * artist;
@property (nonatomic, retain) Genre * genre;
@property (nonatomic, retain) Composer * composer;

@end


@interface Song (CoreDataGeneratedAccessors)
- (void)addPlaylistsObject:(Playlist *)value;
- (void)removePlaylistsObject:(Playlist *)value;
- (void)addPlaylists:(NSSet *)value;
- (void)removePlaylists:(NSSet *)value;

@end

