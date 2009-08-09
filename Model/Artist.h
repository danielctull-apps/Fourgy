//
//  Artist.h
//  iPod
//
//  Created by Daniel Tull on 08.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Album;
@class Genre;
@class Song;

@interface Artist :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* genres;
@property (nonatomic, retain) NSSet* albums;
@property (nonatomic, retain) NSSet* songs;

@end


@interface Artist (CoreDataGeneratedAccessors)
- (void)addGenresObject:(Genre *)value;
- (void)removeGenresObject:(Genre *)value;
- (void)addGenres:(NSSet *)value;
- (void)removeGenres:(NSSet *)value;

- (void)addAlbumsObject:(Album *)value;
- (void)removeAlbumsObject:(Album *)value;
- (void)addAlbums:(NSSet *)value;
- (void)removeAlbums:(NSSet *)value;

- (void)addSongsObject:(Song *)value;
- (void)removeSongsObject:(Song *)value;
- (void)addSongs:(NSSet *)value;
- (void)removeSongs:(NSSet *)value;

@end

