//
//  MyDocument.m
//  Tiny XML Validator
//
//  @version Subversion: $Id$ 
//
//  Created by Coder on 19/04/06.
//  Copyright __MyCompanyName__ 2006 . All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument

-(id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
		error = nil;
		textView = nil;
    }
    return self;
}

-(void)dealloc
{
	[error release];
    [super dealloc];
    return;
}

-(NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

-(void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
	if(error)
	{
		[textView setString:[error localizedDescription]];
	}
}

-(NSData *)dataRepresentationOfType:(NSString *)aType
{
    // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
    
    // For applications targeted for Tiger or later systems, you should use the new Tiger API -dataOfType:error:.  In this case you can also choose to override -writeToURL:ofType:error:, -fileWrapperOfType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    return nil;
}

-(BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError;
{
	[error release];
	NSXMLDocument * doc = [[[NSXMLDocument alloc] initWithContentsOfURL:absoluteURL options:0 error:&error] autorelease];
	if(!error)
	{
		[doc validateAndReturnError:&error];
	}
	[error retain];
	if(textView)
	{
		[textView setString:([error description]?:@"OK")];
	}
    return YES;
}

@end
