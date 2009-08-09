//
//  DTMusicModelController.m
//  iPod
//
//  Created by Daniel Tull on 07.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTMusicModelController.h"
#import "DataInformation.h"
#import "Song+MPMediaItemExtras.h"

@interface DTMusicModelController () // Private Methods
- (NSArray *)fetchAllEntitiesForName:(NSString *)entityName;
- (NSManagedObject *)managedObjectOfType:(NSString *)type withPredicate:(NSPredicate *)predicate;

- (void)setupMusicData;

- (NSURL *)storeURL;

- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSString *)applicationDocumentsDirectory;
@end


@implementation DTMusicModelController

@synthesize managedObjectContext, isSettingUp;

- (id)init {
	
	if (!(self = [super init]))
		return nil;
		
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"DataInformation" inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];	
	NSError *error = nil;
	NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:request error:&error];
	
	if (error) {
		NSLog(@"%@ Fetch Error", self);
		return nil;
	}
	
	if ([fetchResult count] == 0)
		[self setupMusicData];
	
	fetchResult = [self.managedObjectContext executeFetchRequest:request error:&error];
	[request release];
	if ([fetchResult count] == 0) {
		return nil;
	}
	DataInformation *dataInfo = [fetchResult objectAtIndex:0];
	
	
	NSDate *libraryLastModified = [[MPMediaLibrary defaultMediaLibrary] lastModifiedDate];
	NSDate *dataLastUpdated = dataInfo.lastUpdated;
	
	NSLog(@"%@:%s library:%@ coredata:%@", self, _cmd, libraryLastModified, dataLastUpdated);
	
	if ([libraryLastModified compare:dataLastUpdated] == NSOrderedDescending)
		[self setupMusicData];
	
	return self;
}

- (void)dealloc {
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	[super dealloc];
}

#pragma mark -
#pragma mark Specific Item Retrieval

- (Album *)albumWithTitle:(NSString *)albumTitle artist:(Artist *)artist {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@ AND artist == %@", albumTitle, artist];
	return (Album *)[self managedObjectOfType:@"Album" withPredicate:predicate];
}

- (Genre *)genreNamed:(NSString *)genreName {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", genreName];
	return (Genre *)[self managedObjectOfType:@"Genre" withPredicate:predicate];	
}

- (Artist *)artistNamed:(NSString *)artistName {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", artistName];
	return (Artist *)[self managedObjectOfType:@"Artist" withPredicate:predicate];
}

- (Composer *)composerNamed:(NSString *)composerName {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", composerName];
	return (Composer *)[self managedObjectOfType:@"Composer" withPredicate:predicate];
}

- (Song *)songWithIdentifier:(NSNumber *)identifier {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
	return (Song *)[self managedObjectOfType:@"Song" withPredicate:predicate];
}

#pragma mark -
#pragma mark Collection Retrieval

- (NSArray *)allSongs {
	return [self fetchAllEntitiesForName:@"Song"];
}

- (NSArray *)allArtists {
	return [self fetchAllEntitiesForName:@"Artist"];
}

- (NSArray *)allAlbums {
	return [self fetchAllEntitiesForName:@"Album"];
}

- (NSArray *)allComposers {
	return [self fetchAllEntitiesForName:@"Composer"];
}

- (NSArray *)allGenres {
	return [self fetchAllEntitiesForName:@"Genre"];
}

- (NSArray *)allPlaylists {
	return [self fetchAllEntitiesForName:@"Playlist"];
}

#pragma mark -
#pragma mark Private
// YOU DON'T NEED THESE

- (void)setupMusicData {
	
	NSManagedObjectContext *theManagedObjectContext = self.managedObjectContext;
	
	self.isSettingUp = YES;
	NSLog(@"%@:%s starting", self, _cmd);
	
	//[self.managedObjectContext reset];
	/*
	NSError *removeerror;
	NSURL *storeURL = [self storeURL];
	[self.persistentStoreCoordinator removePersistentStore:storeURL error:&removeerror];
	[[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&removeerror];
	persistentStoreCoordinator = nil;
	*/
	
	MPMediaQuery *mediaQuery = [[MPMediaQuery alloc] init];
	
	NSArray *items = mediaQuery.items;
	
	NSMutableDictionary *artistsDictionary = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *composersDictionary = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *genresDictionary = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *albumsDictionary = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *songsDictionary = [[NSMutableDictionary alloc] init];
	
	for (MPMediaItem *item in items) {
		
		Song *song = (Song *)[NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:theManagedObjectContext];
		
		song.identifier = [item valueForProperty:MPMediaItemPropertyPersistentID];
		song.title = [item valueForProperty:MPMediaItemPropertyTitle];
		
		Artist *artist = nil;
		NSString *artistName = [item valueForProperty:MPMediaItemPropertyArtist];
		if (artistName) {
			artist = [artistsDictionary objectForKey:artistName];
			if (!artist) {
				artist = (Artist *)[NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:theManagedObjectContext];
				artist.name = artistName;
				[artistsDictionary setObject:artist forKey:artistName];
			}
			song.artist = artist;
		}
		
		NSString *albumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
		if (albumTitle) {
			NSString *albumKey = [NSString stringWithFormat:@"%@%@", artistName, albumTitle];
			Album *album = [albumsDictionary objectForKey:albumKey];
			if (!album) {
				album = (Album *)[NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:theManagedObjectContext];
				album.title = albumTitle;
				album.artist = artist;
				[albumsDictionary setObject:album forKey:albumKey];
			}
			song.album = album;
		}
		song.album.trackCount = [item valueForProperty:MPMediaItemPropertyAlbumTrackCount];
		song.album.discCount = [item valueForProperty:MPMediaItemPropertyDiscCount];
		song.trackNumber = [item valueForProperty:MPMediaItemPropertyAlbumTrackNumber];
		
		NSString *genreName = [item valueForProperty:MPMediaItemPropertyGenre];
		if (genreName) {
			Genre *genre = [genresDictionary objectForKey:genreName];
			if (!genre) {
				genre = (Genre *)[NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:theManagedObjectContext];
				genre.name = genreName;
				[genresDictionary setObject:genre forKey:genreName];
			}
			song.genre = genre;
		}
		
		NSString *composerName = [item valueForProperty:MPMediaItemPropertyComposer];
		if (composerName) {
			Composer *composer = [composersDictionary objectForKey:composerName];
			if (!composer) {
				composer = (Composer *)[NSEntityDescription insertNewObjectForEntityForName:@"Composer" inManagedObjectContext:theManagedObjectContext];
				composer.name = composerName;
				[composersDictionary setObject:composer forKey:composerName];
			}
			song.composer = composer;
		}
		
		song.lyrics = [item valueForProperty:MPMediaItemPropertyLyrics];
		song.discNumber = [item valueForProperty:MPMediaItemPropertyDiscNumber];
		
		[songsDictionary setObject:song forKey:song.identifier];
	}
	
	NSLog(@"%@:%s Done Songs", self, _cmd);
	
	[mediaQuery release];
	
	MPMediaQuery *playlistsQuery = [MPMediaQuery playlistsQuery];
	NSArray *mediaPlaylists = [playlistsQuery collections];
	
	for (MPMediaPlaylist *mediaPlaylist in mediaPlaylists) {
		
		Playlist *playlist = (Playlist *)[NSEntityDescription insertNewObjectForEntityForName:@"Playlist" inManagedObjectContext:theManagedObjectContext];
		
		NSArray *items = mediaPlaylist.items;
		playlist.name = [mediaPlaylist valueForProperty:MPMediaPlaylistPropertyName];
		
		NSLog(@"Playlist: %@", playlist.name);
		
		NSMutableSet *playlistSongs = [[NSMutableSet alloc] init];
		
		for (MPMediaItem *item in items)
			[playlistSongs addObject:[songsDictionary objectForKey:[item valueForProperty:MPMediaItemPropertyPersistentID]]];
		
		playlist.songs = playlistSongs;
	}
	self.isSettingUp = NO;
	
	DataInformation *dataInfo = (DataInformation *)[NSEntityDescription insertNewObjectForEntityForName:@"DataInformation" inManagedObjectContext:theManagedObjectContext];
	dataInfo.lastUpdated = [NSDate date];
	
	NSLog(@"%@:%s finished", self, _cmd);
	
	
	
	[artistsDictionary release];
	[songsDictionary release];
	[genresDictionary release];
	[composersDictionary release];
	[albumsDictionary release];
	
	NSError *error = nil;
	[theManagedObjectContext save:&error];
	
	if (error)
		NSLog(@"%@:%s Saving error", self, _cmd);
	
}

#pragma mark -
#pragma mark Generic Core Data Fetching

- (NSArray *)fetchAllEntitiesForName:(NSString *)entityName {

	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	NSError *error = nil;
	NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:request error:&error];
	[request release];
	
	if (error) {
		return nil;
	}
	
	return fetchResult;
}

- (NSManagedObject *)managedObjectOfType:(NSString *)type withPredicate:(NSPredicate *)predicate {
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:type inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	[request setPredicate:predicate];
	
	NSError *error = nil;
	
	NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:request error:&error];
	[request release];
	
	if ([fetchResult count] == 0) return nil;
	
	return [fetchResult objectAtIndex:0];
}

#pragma mark -
#pragma mark Object Generation
// These will retrieve the ManagedObject if it exists or create a new one if it doesn't

- (Composer *)generateComposerNamed:(NSString *)composerName {
	
	//Composer *composer = [self composerNamed:composerName];
	
	//if (!composer) {
	Composer *composer = (Composer *)[NSEntityDescription insertNewObjectForEntityForName:@"Composer" inManagedObjectContext:self.managedObjectContext];
	composer.name = composerName;
		//[self.managedObjectContext insertObject:composer];
//	}
	
	return composer;
	
}

- (Album *)generateAlbumWithTitle:(NSString *)albumTitle artist:(Artist *)artist {
	
	//Album *album = [self albumWithTitle:albumTitle artist:artist];
	
	//if (!album) {
	Album *album = (Album *)[NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:self.managedObjectContext];
	album.title = albumTitle;
	album.artist = artist;
	
	return album;
	
}

- (Genre *)generateGenreNamed:(NSString *)genreName {
	//Genre *genre = [self genreNamed:genreName];
	
	//if (!genre) {
	Genre *genre = (Genre *)[NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:self.managedObjectContext];
	genre.name = genreName;
	//}
	
	return genre;
}

- (Artist *)generateArtistNamed:(NSString *)artistName {
	//Artist *artist = [self artistNamed:artistName];
	
	//if (!artist) {
	Artist *artist = (Artist *)[NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:self.managedObjectContext];
	artist.name = artistName;
	
	return artist;
}











#pragma mark -
#pragma mark Core Data Stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
	
	//NSLog(@"%@:%s MOC: %@", self, _cmd, managedObjectContext);
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
	
	//NSLog(@"%@:%s MOC: %@", self, _cmd, managedObjectContext);
	
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil)
		return managedObjectModel;
	
	//managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"DTMusicModel" ofType:@"xcdatamodel"]]];    
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];   
	
	//NSLog(@"%@:%s MOM: %@", self, _cmd, managedObjectModel);
	
	return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error]) {
		NSLog(@"%@:%s %@", self, _cmd, error);
    }
	
    return persistentStoreCoordinator;
}


- (NSURL *)storeURL {
	return [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"DTMusicModel.sqlite"]];
}

#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


@end
