//
//  Fourgy.m
//  Fourgy
//
//  Created by Daniel Tull on 18.07.2012.
//  Copyright (c) 2012 Daniel Tull Limited. All rights reserved.
//

#import "Fourgy.h"
#import <CoreText/CoreText.h>

static NSBundle *_bundle = nil;

@implementation Fourgy

+ (CGFloat)rowHeight {
	return 27.0f;
}

+ (UIFont *)fontOfSize:(CGFloat)size {
	
	static dispatch_once_t fontToken;
	dispatch_once(&fontToken, ^{
		NSString *fontPath = [[self bundle] pathForResource:@"Chicago" ofType:@"ttf"];
		NSData *data = [[NSData alloc] initWithContentsOfFile:fontPath];
		CGDataProviderRef fontProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
		CGFontRef cgFont = CGFontCreateWithDataProvider(fontProvider);
		CGDataProviderRelease(fontProvider);
		CTFontManagerRegisterGraphicsFont(cgFont, nil);
		CGFontRelease(cgFont);
	});
	
	return [UIFont fontWithName:@"pixChicago" size:size];
}

+ (NSBundle *)bundle {
	
	static dispatch_once_t bundleToken;
	dispatch_once(&bundleToken, ^{
		NSDirectoryEnumerator *enumerator = [[NSFileManager new] enumeratorAtURL:[[NSBundle mainBundle] bundleURL]
													  includingPropertiesForKeys:nil
																		 options:NSDirectoryEnumerationSkipsHiddenFiles
																	errorHandler:NULL];
		
		for (NSURL *URL in enumerator)
			if ([[URL lastPathComponent] isEqualToString:@"Fourgy.bundle"])
				_bundle = [NSBundle bundleWithURL:URL];
	});
		
	return _bundle;
}

@end
