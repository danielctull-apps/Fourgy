//
//  DTMusicModelController.h
//  iPod
//
//  Created by Daniel Tull on 07.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreData/CoreData.h>

#import "Song.h"
#import "Genre.h"
#import "Artist.h"
#import "Album.h"
#import "Playlist.h"
#import "Composer.h"

extern NSString *DTMusicModelWillBeginUpdatingNotification;
extern NSString *DTMusicModelDidBeginUpdatingNotification;
extern NSString *DTMusicModelDidEndUpdatingNotification;
extern NSString *DTMusicModelUpdatingProgressNotification;

extern NSString *DTMusicModelAmountOfTracksToProcessKey;
extern NSString *DTMusicModelAmountOfTracksFinishedProcessingKey;
extern NSString *DTMusicModelAmountOfPlaylistsToProcessKey;
extern NSString *DTMusicModelAmountOfPlaylistsFinishedProcessingKey;

@interface DTMusicModelController : NSObject {
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	BOOL isSettingUp;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, assign) BOOL isSettingUp;

- (NSArray *)allSongs;
- (NSArray *)allArtists;
- (NSArray *)allAlbums;
- (NSArray *)allComposers;
- (NSArray *)allGenres;
- (NSArray *)allPlaylists;

- (Album *)albumWithTitle:(NSString *)albumTitle artist:(Artist *)artist;
- (Artist *)artistNamed:(NSString *)artistName;
- (Genre *)genreNamed:(NSString *)genreName;
- (Composer *)composerNamed:(NSString *)composerName;
- (Song *)songWithIdentifier:(NSNumber *)identifier;
@end
