//
//  DTMusicModelController.m
//  iPod
//
//  Created by Daniel Tull on 07.08.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTMusicModelController.h"
#import "DataInformation.h"
#import "Song+Extras.h"

NSString *DTMusicModelWillBeginUpdatingNotification = @"DTMusicModelWillBeginUpdatingNotification";
NSString *DTMusicModelDidBeginUpdatingNotification = @"DTMusicModelDidBeginUpdatingNotification";
NSString *DTMusicModelDidEndUpdatingNotification = @"DTMusicModelDidEndUpdatingNotification";
NSString *DTMusicModelUpdatingProgressNotification = @"DTMusicModelUpdatingProgressNotification";

NSString *DTMusicModelAmountOfTracksToProcessKey = @"DTMusicModelAmountOfTracksToProcessKey";
NSString *DTMusicModelAmountOfTracksFinishedProcessingKey = @"DTMusicModelAmountOfTracksFinishedProcessingKey";
NSString *DTMusicModelAmountOfPlaylistsToProcessKey = @"DTMusicModelAmountOfPlaylistsToProcessKey";
NSString *DTMusicModelAmountOfPlaylistsFinishedProcessingKey = @"DTMusicModelAmountOfPlaylistsFinishedProcessingKey";

@interface DTMusicModelController () // Private Methods

- (NSArray *)sortDescriptorArrayWithDescriptorWithKey:(NSString *)key;

- (NSArray *)fetchAllEntitiesForName:(NSString *)entityName;
- (NSArray *)fetchAllEntitiesForName:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)fetchAllEntitiesForName:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors batchSize:(NSUInteger)batchSize;

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
	return [self fetchAllEntitiesForName:@"Song" sortDescriptors:[self sortDescriptorArrayWithDescriptorWithKey:@"title"] batchSize:6];
}

- (NSArray *)allArtists {
	return [self fetchAllEntitiesForName:@"Artist" sortDescriptors:[self sortDescriptorArrayWithDescriptorWithKey:@"name"] batchSize:6];
}

- (NSArray *)allAlbums {
	return [self fetchAllEntitiesForName:@"Album" sortDescriptors:[self sortDescriptorArrayWithDescriptorWithKey:@"title"] batchSize:6];
}

- (NSArray *)allComposers {
	return [self fetchAllEntitiesForName:@"Composer" sortDescriptors:[self sortDescriptorArrayWithDescriptorWithKey:@"name"] batchSize:6];
}

- (NSArray *)allGenres {
	return [self fetchAllEntitiesForName:@"Genre" sortDescriptors:[self sortDescriptorArrayWithDescriptorWithKey:@"name"] batchSize:6];
}

- (NSArray *)allPlaylists {
	return [self fetchAllEntitiesForName:@"Playlist" sortDescriptors:[self sortDescriptorArrayWithDescriptorWithKey:@"name"] batchSize:6];
}

#pragma mark -
#pragma mark Private

- (void)setupMusicData {
	
	
	//[[NSNotificationCenter defaultCenter] postNotificationName:DTMusicModelDidBeginUpdatingNotification object:self];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:DTMusicModelWillBeginUpdatingNotification object:self];
	
	self.isSettingUp = YES;
	
	
	NSInteger progressAmount = 0;
	
	
	NSLog(@"%@:%s starting", self, _cmd);
		
	NSError *removeerror;
	NSURL *storeURL = [self storeURL];
	//[self.persistentStoreCoordinator removePersistentStore:[self.persistentStoreCoordinator persistentStoreForURL:storeURL] error:&removeerror];
	[[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&removeerror];
	//[[NSFileManager defaultManager] createFileAtPath:storeURL.path contents:nil attributes:nil];
	[persistentStoreCoordinator release];
	persistentStoreCoordinator = nil;
	[managedObjectContext release];
	managedObjectContext = nil;
	
	NSManagedObjectContext *theManagedObjectContext = self.managedObjectContext;
	
	MPMediaQuery *mediaQuery = [[MPMediaQuery alloc] init];	
	NSArray *items = mediaQuery.items;
	
	MPMediaQuery *playlistsQuery = [MPMediaQuery playlistsQuery];
	NSArray *mediaPlaylists = [playlistsQuery collections];
	
	NSMutableDictionary *progressDictionary = [[NSMutableDictionary alloc] init];
	
	[progressDictionary setObject:[NSNumber numberWithInt:[items count]] forKey:DTMusicModelAmountOfTracksToProcessKey];
	[progressDictionary setObject:[NSNumber numberWithInt:[mediaPlaylists count]] forKey:DTMusicModelAmountOfPlaylistsToProcessKey];
	[progressDictionary setObject:[NSNumber numberWithInt:0] forKey:DTMusicModelAmountOfTracksFinishedProcessingKey];
	[progressDictionary setObject:[NSNumber numberWithInt:0] forKey:DTMusicModelAmountOfPlaylistsFinishedProcessingKey];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:DTMusicModelDidBeginUpdatingNotification object:self userInfo:progressDictionary];
	
	NSMutableDictionary *artistsDictionary = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *composersDictionary = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *genresDictionary = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *albumsDictionary = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *songsDictionary = [[NSMutableDictionary alloc] init];
	
	NSLog(@"%@:%s %i", self, _cmd, [items count]);
	
	for (MPMediaItem *item in items) {
		
		Song *song = (Song *)[NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:theManagedObjectContext];
		
		song.identifier = [item valueForProperty:MPMediaItemPropertyPersistentID];
		song.title = [item valueForProperty:MPMediaItemPropertyTitle];
		
		Artist *artist = nil;
		NSString *artistName = [item valueForProperty:MPMediaItemPropertyArtist];
		if (artistName && ![artistName isEqualToString:@""]) {
			artist = [artistsDictionary objectForKey:artistName];
			if (!artist) {
				artist = (Artist *)[NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:theManagedObjectContext];
				artist.name = artistName;
				[artistsDictionary setObject:artist forKey:artistName];
			}
			song.artist = artist;
		}
		
		NSString *albumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
		if (albumTitle && ![albumTitle isEqualToString:@""]) {
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
		if (genreName && ![genreName isEqualToString:@""]) {
			Genre *genre = [genresDictionary objectForKey:genreName];
			if (!genre) {
				genre = (Genre *)[NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:theManagedObjectContext];
				genre.name = genreName;
				[genresDictionary setObject:genre forKey:genreName];
			}
			song.genre = genre;
		}
		
		NSString *composerName = [item valueForProperty:MPMediaItemPropertyComposer];
		if (composerName && ![composerName isEqualToString:@""]) {
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
		
		progressAmount++;
		
		[progressDictionary setObject:[NSNumber numberWithInt:progressAmount] forKey:DTMusicModelAmountOfTracksFinishedProcessingKey];
		[[NSNotificationCenter defaultCenter] postNotificationName:DTMusicModelUpdatingProgressNotification object:self userInfo:progressDictionary];
		
		NSError *serror = nil;
		[self.managedObjectContext save:&serror];
		
		if (serror)
			NSLog(@"%@:%s Saving error: %@: %@", self, _cmd, serror, [serror userInfo]);
	}
	
	progressAmount = 0;
	
	NSLog(@"%@:%s Done Songs", self, _cmd);
	
	[mediaQuery release];
		
	for (MPMediaPlaylist *mediaPlaylist in mediaPlaylists) {
		
		Playlist *playlist = (Playlist *)[NSEntityDescription insertNewObjectForEntityForName:@"Playlist" inManagedObjectContext:theManagedObjectContext];
		
		NSArray *items = mediaPlaylist.items;
		playlist.name = [mediaPlaylist valueForProperty:MPMediaPlaylistPropertyName];
		
		NSLog(@"Playlist: %@", playlist.name);
		
		NSMutableSet *playlistSongs = [[NSMutableSet alloc] init];
		
		for (MPMediaItem *item in items)
			[playlistSongs addObject:[songsDictionary objectForKey:[item valueForProperty:MPMediaItemPropertyPersistentID]]];
		
		playlist.songs = playlistSongs;
		
		progressAmount++;
		[progressDictionary setObject:[NSNumber numberWithInt:progressAmount] forKey:DTMusicModelAmountOfPlaylistsFinishedProcessingKey];
		[[NSNotificationCenter defaultCenter] postNotificationName:DTMusicModelUpdatingProgressNotification object:self userInfo:progressDictionary];
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
	[self.managedObjectContext save:&error];
	
	if (error)
		NSLog(@"%@:%s Saving error: %@ : %@", self, _cmd, error, [error userInfo]);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:DTMusicModelDidEndUpdatingNotification object:self userInfo:progressDictionary];
	
	[progressDictionary release];
	
}

#pragma mark -
#pragma mark Generic Core Data Fetching

- (NSArray *)sortDescriptorArrayWithDescriptorWithKey:(NSString *)key {
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
	NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
	[sortDescriptor release];
	return descriptors;
}


- (NSArray *)fetchAllEntitiesForName:(NSString *)entityName {
	return [self fetchAllEntitiesForName:entityName sortDescriptors:nil];
}

- (NSArray *)fetchAllEntitiesForName:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors {
	return [self fetchAllEntitiesForName:entityName sortDescriptors:nil batchSize:0];
}

- (NSArray *)fetchAllEntitiesForName:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors batchSize:(NSUInteger)batchSize {
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	if (batchSize > 0) [request setFetchBatchSize:batchSize];
	
	if (sortDescriptors) [request setSortDescriptors:sortDescriptors];
	
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
	
    if (managedObjectContext != nil)
        return managedObjectContext;
	
	managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
	
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
	
	return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil)
        return persistentStoreCoordinator;
	
	NSLog(@"%@:%s setup", self, _cmd);
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	/*
	if (![[NSFileManager defaultManager] fileExistsAtPath:[self storeURL].path]) {
		NSLog(@"%@:%s OMG NO FILE STORE", self, _cmd);
		[[NSFileManager defaultManager] createFileAtPath:[self storeURL].path contents:nil attributes:nil];
		
	}
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:[self storeURL].path]) {
		NSLog(@"%@:%s OMG REALLY LOOK AT THIS THERE IS NO FILE STORE", self, _cmd);
	} else {
		NSLog(@"%@:%s %@", self, _cmd, [[NSFileManager defaultManager] fileAttributesAtPath:[self storeURL].path traverseLink:NO]);
		//NSLog(@"%@:%s %@", self, _cmd, [[NSFileManager defaultManager] contentsAtPath:[self storeURL].path]);
	}
	*/
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
