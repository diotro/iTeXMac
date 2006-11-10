/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Apr 12 20:12:28 GMT 2006.
//  Copyright © 2006 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

#import <iTM2Foundation/iTM2TextCompletionKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <iTM2Foundation/iTM2DocumentKit.h>
#import <iTM2Foundation/iTM2TreeKit.h>
#import <iTM2Foundation/iTM2MenuKit.h>

NSString * const iTM2CompletionComponent = @"Completion.localized";
NSString * const iTM2CompletionIdentifier = @"iTM2CompletionIdentifier";
NSString * const iTM2CompletionsExtension = @"xml";

@interface iTM2CompletionServer(PRIVATE)
- (iTM2PatriciaController *)patriciaControllerForTextView:(NSTextView *)aTextView;
- (void)addSelectionToCompletionForTextView:(NSTextView *)aTextView;
- (int)runCompletionForTextView:(NSTextView *)aTextView;
- (BOOL)validateChooseCompletionMode:(id)sender forTextView:(NSTextView *)aTextView;
- (void)updateCompletion;
- (void)cancelCompletion;
- (void)concludeCompletion;
- (void)concludeCompletionAndInsertSpace;
- (void)forwardKeyEvent:(NSEvent *)theEvent;
+ (void)reloadCompletionsAtPath:(NSString *)path;
+ (NSArray *)completionsWithContentsOfURL:(NSURL *)url error:(NSError **)outErrorPtr;
+ (void)addCompletions:(NSArray *)completions forContext:(NSString *)context ofCategory:(NSString *)category;
+ (id)storageForContext:(NSString *)context ofCategory:(NSString *)category;
- (void)editCompletionsForTextView:(NSTextView *)aTextView;
@end

#import <iTM2Foundation/iTM2ContextKit.h>

@interface iTM2CompletionWindow:NSPanel
@end

#import <iTM2Foundation/iTM2TextDocumentKit.h>

@interface iTM2CompletionInspector:NSWindowController
{
@private
	IBOutlet NSTableView * _TableView;
	NSString * selectedCompletionSet;
	NSString * newCompletionSet;
	NSMutableDictionary * _CompletionSets;
	NSPanel * panel;
}
+ (id)completionInspector;
- (void)editCompletionsForTextView:(NSTextView *)aTextView;
- (NSString *)selectedCompletionSet;
- (void)setSelectedCompletionSet:(NSString *)newSet;
- (NSArray *)completionSortDescriptors;
- (NSMutableArray *)currentCompletions;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextCompletionKit
static id _iTM2_CompletionServer_Data = nil;
@implementation iTM2CompletionServer
+ (void)initialize;
{
	[super initialize];
	[SUD registerDefaults:
		[NSDictionary dictionaryWithObjectsAndKeys:
			@"Default",iTM2CompletionIdentifier,
			nil]];
	return;
}
static id iTM2SharedCompletionServer = nil;
+ (id)completionServer;
{
	return iTM2SharedCompletionServer?:(iTM2SharedCompletionServer=[[iTM2CompletionServer alloc] initWithWindowNibName:NSStringFromClass([self class])]);
}
- (id)initWithWindow:(NSWindow *)window;
{
	if(iTM2SharedCompletionServer)
	{
		[self release];
		return [iTM2SharedCompletionServer retain];
	}
	NSAssert((iTM2SharedCompletionServer = [super initWithWindow:window]),@"BUG, please report error iTM2 9669-1");
	[_PatriciaControllers autorelease];
	_PatriciaControllers = [[NSMutableDictionary dictionary] retain];
	return iTM2SharedCompletionServer;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithWindowNibName:
- (id)initWithWindowNibName:(NSString *)name;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(self = [super initWithWindowNibName:name])
	{
		NSPanel * window = nil;
		NSAssert((window = (NSPanel *)[self window]),@"BUG, please report error iTM2 9669-2");
		NSView * contentView = [[[window contentView] retain] autorelease];
		[window setContentView:nil];
		NSRect frame = [contentView frame];
		window = [[[iTM2CompletionWindow alloc] initWithContentRect:frame styleMask:NSBorderlessWindowMask|NSUtilityWindowMask backing:NSBackingStoreBuffered defer:NO] autorelease];
		[window setContentView:contentView];
		[self setWindow:window];
		[window setLevel:NSModalPanelWindowLevel];
		[window setHasShadow:YES];
		[window setFloatingPanel:YES];
//		[[self window] addChildWindow:W ordered:NSWindowAbove];
//		[W setFrameOrigin:cellFrame.origin];
//		[W setFrameTopLeftPoint:aPoint];
		// It is not possible to catch all the events because it is not like in a mouse down/drag operation
		// there is a problem of windows not ordering front (at least) when we switch apps
//		[[self window] removeChildWindow:W];
	}
//iTM2_END;
	return self;
}
- (void)dealloc;
{
	[_Candidates autorelease];
	_Candidates = nil;
	[_TextView autorelease];
	_TextView = nil;
	[_OriginalString autorelease];
	_OriginalString = nil;
	[_EditedString autorelease];
	_EditedString = nil;
	[_PatriciaControllers autorelease];
	_PatriciaControllers = nil;
	[DNC removeObserver:self name:NSWindowWillCloseNotification object:nil];
	[super dealloc];
	return;
}
- (iTM2PatriciaController *)patriciaControllerForTextView:(NSTextView *)aTextView;
{
	NSParameterAssert(aTextView);
	NSString * completionIdentifier = [aTextView contextValueForKey:iTM2CompletionIdentifier domain:iTM2ContextAllDomainsMask];
	iTM2PatriciaController * patriciaController = [_PatriciaControllers objectForKey:completionIdentifier];
	if(!patriciaController)
	{
		patriciaController = [[[iTM2PatriciaController allocWithZone:[self zone]] init] autorelease];
		[_PatriciaControllers setObject:patriciaController forKey:completionIdentifier];
		// now read all the completion files
		NSBundle * mainBundle = [NSBundle mainBundle];
		NSArray * allPaths = [mainBundle allPathsForResource:completionIdentifier ofType:@"xml" inDirectory:iTM2CompletionComponent];
		NSEnumerator * E = [allPaths objectEnumerator];
		NSString * path;
		NSURL * url;
		NSError * error = nil;
		while(path = [E nextObject])
		{
			url = [NSURL fileURLWithPath:path];
			NSArray * strings = [[self class] completionsWithContentsOfURL:url error:&error];
			[patriciaController addStrings:strings];
		}
//		NSArray * strings = [NSArray arrayWithObjects:@"\\a",@"\\ab",@"\\abc",nil];
//		[patriciaController addStrings:strings];
	}
	return patriciaController;
}
- (void)addSelectionToCompletionForTextView:(NSTextView *)aTextView;
{
	NSParameterAssert(aTextView);
	iTM2PatriciaController * patriciaController = [self patriciaControllerForTextView:aTextView];
	NSArray * selectedRanges = [aTextView selectedRanges];
	NSString * string = [aTextView string];
	NSMutableArray * stringList = [NSMutableArray arrayWithCapacity:[selectedRanges count]];
	NSEnumerator * E = [selectedRanges objectEnumerator];
	NSValue * V;
	while(V = [E nextObject])
	{
		NSRange range = [V rangeValue];
		NSString * substring = [string substringWithRange:range];
		if([substring length])
		{
			[stringList addObject:substring];
		}
	}
	[patriciaController addStrings:stringList];
//iTM2_LOG(@"[patriciaController stringList]:%@",[patriciaController stringList]);
	return;
}
- (NSArray *)completionsForTextView:(NSTextView *)aTextView partialWordRange:(NSRange)charRange indexOfSelectedItem:(int *)index;
{
	NSParameterAssert(aTextView);
	iTM2PatriciaController * patriciaController = [self patriciaControllerForTextView:aTextView];
	NSString * string = [aTextView string];
	string = [string substringWithRange:charRange];
	return [patriciaController stringListForPrefix:string];
}
- (int)runCompletionForTextView:(NSTextView *)aTextView;
{
	NSParameterAssert(aTextView);
	// clean any previous discussion
	[self cancelCompletion];
	// is there something to complete with?
	int selectedRow = 0;
	_RangeForUserCompletion = [aTextView rangeForUserCompletion];
	_EditedRangeForUserCompletion = _RangeForUserCompletion;
	_Candidates = [[aTextView completionsForPartialWordRange:_RangeForUserCompletion indexOfSelectedItem:&selectedRow] retain];
	unsigned numberOfRows = [_Candidates count];
	if(!numberOfRows)
	{
		[_Candidates autorelease];
		_Candidates = nil;
		return 4;
	}
	if(_TextView = [aTextView retain])
	{
		[DNC addObserver:self selector:@selector(windowWillCloseNotified:) name:NSWindowWillCloseNotification object:[aTextView window]];
		NSUndoManager * undoManager = [_TextView undoManager];
		if(_ShouldEnableUndoRegistration = [undoManager isUndoRegistrationEnabled])
		{
			NSLog(@"disableUndoRegistration");
			[undoManager disableUndoRegistration];
		}
		[_OriginalString autorelease];
		if(_RangeForUserCompletion.length)
		{
			_OriginalString = [_TextView string];
			_OriginalString = [_OriginalString substringWithRange:_RangeForUserCompletion];
			_OriginalString = [_OriginalString copy];
		}
		else
		{
			_OriginalString = @"";
		}
		//where should I draw the window
		NSLayoutManager * layoutManager = [aTextView layoutManager];
		NSRange glyphRange = [layoutManager glyphRangeForCharacterRange:_RangeForUserCompletion actualCharacterRange:nil];
		NSTextContainer * container = [layoutManager textContainerForGlyphAtIndex:glyphRange.location effectiveRange:nil];
		NSRect rect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:container];
		rect = [_TextView convertRect:rect toView:nil];
		NSWindow * textViewWindow = [_TextView window];
		NSPoint aPoint = rect.origin;
		aPoint = [textViewWindow convertBaseToScreen:aPoint];
		aPoint.x-=4;
		aPoint.y-=1;
		NSWindow * W = [self window];
	//	[textViewWindow addChildWindow:W ordered:NSWindowAbove];
		[W setFrameTopLeftPoint:aPoint];
		// where should I put this window
		[_TableView setDataSource:self];
		[_TableView setDelegate:self];
		[_TableView setTarget:self];
		[_TableView setDoubleAction:@selector(_concludeCompletion:)];
		[_TableView setAllowsMultipleSelection:NO];
		[_TableView reloadData];
		NSTableColumn * TC = [_TableView tableColumnWithIdentifier:@"completion"];
		NSAssert(TC,@"Missing in iTM2CompletionController.nib a column with a \"completion\" identifier, report BUG");
		NSCell * cell = nil;
		unsigned row = 0;
		NSSize size = NSZeroSize;
		float maxWidth = 0;
		float maxHeight = 0;
		while(row<numberOfRows)
		{
			cell = [TC dataCellForRow:row];
			NSString * aString = [_Candidates objectAtIndex:row];
			[cell setStringValue:aString];
			size = [cell cellSize];
			if(size.width>maxWidth)
			{
				maxWidth = size.width;
			}
			rect = [_TableView rectOfRow:row];
			if(NSMaxY(rect)>maxHeight)
			{
				maxHeight = NSMaxY(rect);
			}
			++row;
		}
		id aView = [_TableView enclosingScrollView];
		rect = [aView bounds];
		rect = [_TableView convertRect:rect fromView:aView];
		maxWidth += rect.size.width;
		aView = [aView contentView];
		maxWidth -= rect.size.width;
		maxWidth += 2*[_TableView intercellSpacing].width;
		maxWidth += 10;
		rect = [W frame];
		rect.size.width = maxWidth;
		maxHeight += 4;
		rect.size.height = maxHeight;
		[_TableView selectRow:selectedRow byExtendingSelection:NO];
		[self updateCompletion];
#if 0
		aView = [_TableView enclosingScrollView];
		rect = [[aView contentView] bounds];
		rect = [_TableView convertRect:rect fromView:aView];
		NSLog(NSStringFromSize(rect.size));
		rect = [_TableView bounds];
		NSLog(NSStringFromSize(rect.size));
#endif
		[W setFrame:rect display:NO];// one of the latest thing to do
		[W setFrameTopLeftPoint:aPoint];
		[W makeKeyAndOrderFront:self];
	//	return [NSApp runModalForWindow:W];
		return 5;
	}
	return 0;
}
- (void)cancelCompletion;
{
	if(_TextView)
	{
		[_TextView insertCompletion:_OriginalString forPartialWordRange:_RangeForUserCompletion movement:NSCancelTextMovement isFinal:NO];
		_RangeForUserCompletion.length = [_OriginalString length];
		NSUndoManager * undoManager = [_TextView undoManager];
		if(_ShouldEnableUndoRegistration)
		{
			[undoManager enableUndoRegistration];
			NSLog(@"enableUndoRegistration");
			_ShouldEnableUndoRegistration = NO;
		}
		else
		{
			NSLog(@"still disableUndoRegistration");
		}
		if(_EditedString && [_TextView shouldChangeTextInRange:_RangeForUserCompletion replacementString:_EditedString])
		{
			[_TextView replaceCharactersInRange:_RangeForUserCompletion withString:_EditedString];
			[_TextView didChangeText];
		}
		[_TextView autorelease];
		_TextView = nil;
	}
	[_Candidates autorelease];
	_Candidates = nil;
	NSWindow * W = [self window];
	[[W parentWindow] removeChildWindow:W];
	[W orderOut:self];
	[DNC removeObserver:self name:NSWindowWillCloseNotification object:nil];
	return;
}
- (void)windowWillCloseNotified:(NSNotification *)aNotification;
{
	[self cancelCompletion];
	return;
}
- (void)_concludeCompletion:(id)sender;
{
	[self concludeCompletion];
	return;
}
- (void)concludeCompletionAndInsertSpace;
{
	NSString * replacementString = [_TextView string];
	replacementString = [replacementString substringWithRange:_EditedRangeForUserCompletion];
	[_TextView insertCompletion:_OriginalString forPartialWordRange:_RangeForUserCompletion movement:NSCancelTextMovement isFinal:NO];
	NSUndoManager * undoManager = [_TextView undoManager];
	if(_ShouldEnableUndoRegistration)
	{
		[undoManager enableUndoRegistration];
iTM2_LOG(@"now enableUndoRegistration");
		_ShouldEnableUndoRegistration = NO;
	}
	else
	{
iTM2_LOG(@"still disableUndoRegistration");
	}
	replacementString = [replacementString stringByAppendingString:@" "];
	[_TextView insertCompletion:replacementString forPartialWordRange:_RangeForUserCompletion movement:NSReturnTextMovement isFinal:YES];
#if 0
useless?
	if(_EditedString && [_TextView shouldChangeTextInRange:_RangeForUserCompletion replacementString:_EditedString])
	{
		[_TextView replaceCharactersInRange:_RangeForUserCompletion withString:_EditedString];
		[_TextView didChangeText];
	}
#endif
	[_TextView autorelease];
	_TextView = nil;
	[_Candidates autorelease];
	_Candidates = nil;
	NSWindow * W = [self window];
	[[W parentWindow] removeChildWindow:W];
	[W orderOut:self];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  concludeCompletion
- (void)concludeCompletion;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Nov  6 07:59:41 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * replacementString = [_TextView string];
	NSRange fullRange = NSMakeRange(0,[replacementString length]);
	_EditedRangeForUserCompletion = NSIntersectionRange(fullRange,_EditedRangeForUserCompletion);// There is a bug, when the text is edited (chars are removed, but I do not know the exact situation) the _EditedRangeForUserCompletion turns out to be in an inconsistent state
	replacementString = [replacementString substringWithRange:_EditedRangeForUserCompletion];
	[_TextView insertCompletion:_OriginalString forPartialWordRange:_RangeForUserCompletion movement:NSCancelTextMovement isFinal:NO];
	NSUndoManager * undoManager = [_TextView undoManager];
	if(_ShouldEnableUndoRegistration)
	{
		[undoManager enableUndoRegistration];
iTM2_LOG(@"now enableUndoRegistration");
		_ShouldEnableUndoRegistration = NO;
	}
	else
	{
iTM2_LOG(@"still disableUndoRegistration");
	}
	[_TextView insertCompletion:replacementString forPartialWordRange:_RangeForUserCompletion movement:NSReturnTextMovement isFinal:YES];
#if 0
useless?
	if(_EditedString && [_TextView shouldChangeTextInRange:_RangeForUserCompletion replacementString:_EditedString])
	{
		[_TextView replaceCharactersInRange:_RangeForUserCompletion withString:_EditedString];
		[_TextView didChangeText];
	}
#endif
	[_TextView autorelease];
	_TextView = nil;
	[_Candidates autorelease];
	_Candidates = nil;
	NSWindow * W = [self window];
	[[W parentWindow] removeChildWindow:W];
	[W orderOut:self];
	[self updateCompletion];
//iTM2_END;
	return;
}
- (void)forwardKeyEvent:(NSEvent *)theEvent;
{
	if(_RangeForUserCompletion.length == 0)
	{
		return;
	}
	[[_TextView window] sendEvent:theEvent];
	// the text has certainly changed, and the change must be tracked down
	// How can we track the change
	// we have 2 situations
	// either we added a character
	// or we deleted one
	NSRange range = [_TextView rangeForUserCompletion];
	if(!NSEqualRanges(range,_RangeForUserCompletion))
	{
		int selectedRow = 0;
		_Candidates = [[_TextView completionsForPartialWordRange:range indexOfSelectedItem:&selectedRow] retain];
		unsigned numberOfRows = [_Candidates count];
		if(!numberOfRows)
		{
			[self cancelCompletion];
			return;
		}
		_RangeForUserCompletion = range;
		_EditedRangeForUserCompletion = _RangeForUserCompletion;
		[_EditedString autorelease];
		if(_RangeForUserCompletion.length)
		{
			_EditedString = [_TextView string];
			_EditedString = [_EditedString substringWithRange:_RangeForUserCompletion];
			_EditedString = [_EditedString copy];
		}
		else
		{
			_EditedString = @"";
		}
		//where should I draw the window
		NSLayoutManager * layoutManager = [_TextView layoutManager];
		NSRange glyphRange = [layoutManager glyphRangeForCharacterRange:_RangeForUserCompletion actualCharacterRange:nil];
		NSTextContainer * container = [layoutManager textContainerForGlyphAtIndex:glyphRange.location effectiveRange:nil];
		NSRect rect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:container];
		rect = [_TextView convertRect:rect toView:nil];
		NSWindow * textViewWindow = [_TextView window];
		NSPoint aPoint = rect.origin;
		aPoint = [textViewWindow convertBaseToScreen:aPoint];
		aPoint.x-=4;
		aPoint.y-=1;
		NSWindow * W = [self window];
	//	[textViewWindow addChildWindow:W ordered:NSWindowAbove];
		[W setFrameTopLeftPoint:aPoint];
		NSTableColumn * TC = [_TableView tableColumnWithIdentifier:@"completion"];
		NSAssert(TC,@"Missing in iTM2CompletionController.nib a column with a \"completion\" identifier, report BUG");
		NSCell * cell = nil;
		unsigned row = 0;
		NSSize size = NSZeroSize;
		float maxWidth = 0;
		while(row<numberOfRows)
		{
			cell = [TC dataCellForRow:row];
			NSString * aString = [_Candidates objectAtIndex:row];
			[cell setStringValue:aString];
			size = [cell cellSize];
			if(size.width>maxWidth)
			{
				maxWidth = size.width;
			}
			++row;
		}
		id aView = [_TableView enclosingScrollView];
		rect = [aView bounds];
		rect = [_TableView convertRect:rect fromView:aView];
		maxWidth += rect.size.width;
		aView = [aView contentView];
		maxWidth -= rect.size.width;
		maxWidth += 2*[_TableView intercellSpacing].width;
		maxWidth += 10;
		rect = [W frame];
		rect.size.width = maxWidth;
		// where should I put this window
		[_TableView setDataSource:self];
		[_TableView setDelegate:self];
		[_TableView setTarget:self];
		[_TableView setDoubleAction:@selector(_concludeCompletion:)];
		[_TableView setAllowsMultipleSelection:NO];
		[_TableView reloadData];
		[_TableView selectRow:selectedRow byExtendingSelection:NO];
		[self updateCompletion];
#if 0
	aView = [_TableView enclosingScrollView];
	rect = [[aView contentView] bounds];
	rect = [_TableView convertRect:rect fromView:aView];
	NSLog(NSStringFromSize(rect.size));
	rect = [_TableView bounds];
	NSLog(NSStringFromSize(rect.size));
#endif
		[W setFrame:rect display:YES];// one of the latest thing to do
		[W makeKeyAndOrderFront:self];
	}
	return;
}
- (void)updateCompletion;
{
	int row = [_TableView selectedRow];
	NSTableColumn * tableColumn = [_TableView tableColumnWithIdentifier:@"completion"];
	id dataSource = [_TableView dataSource];
	NSString * word = [dataSource tableView:_TableView objectValueForTableColumn:tableColumn row:row];
	if(![word isKindOfClass:[NSString class]])
	{
		word = _OriginalString;
	}
	[_TextView insertCompletion:word forPartialWordRange:_RangeForUserCompletion movement:NSOtherTextMovement isFinal:NO];
	_EditedRangeForUserCompletion.length = [word length];
	return;
#if 0
	NSString * string = [_TextView string];
	NSRange charRange = NSMakeRange(0,[string length]);
	_RangeForUserCompletion = NSIntersectionRange(charRange,_RangeForUserCompletion);
	_EditedRangeForUserCompletion = NSIntersectionRange(charRange,_EditedRangeForUserCompletion);
	NSLayoutManager * layoutManager = [_TextView layoutManager];
	NSNumber * N = [NSNumber numberWithInt:NSUnderlineStyleSingle];
	NSDictionary * attrs = [NSDictionary dictionaryWithObject:N forKey:NSUnderlineStyleAttributeName];
	[layoutManager addTemporaryAttributes:attrs forCharacterRange:charRange];
	#if 0
	enum 3
   NSIllegalTextMovement = 0,
   NSReturnTextMovement  = 0x10,
   NSTabTextMovement     = 0x11,
   NSBacktabTextMovement = 0x12,
   NSLeftTextMovement    = 0x13,
   NSRightTextMovement   = 0x14,
   NSUpTextMovement      = 0x15,
   NSDownTextMovement    = 0x16,
   NSCancelTextMovement  = 0x17,
   NSOtherTextMovement    = 0
	#endif
#endif
	return;
}
- (int)numberOfRowsInTableView:(NSTableView *)tableView;
{
	if(!_TableView)
	{
		_TableView = tableView;
	}
	return [_Candidates count];
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row;
{
	return row>=0?[_Candidates objectAtIndex:row]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableViewSelectionDidChange:
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self updateCompletion];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  reloadCompletions
+ (void)reloadCompletions;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	if(!_iTM2_CompletionServer_Data)
		_iTM2_CompletionServer_Data = [[NSMutableDictionary dictionary] retain];
	// read the built in stuff
	// inside frameworks then bundles.
	NSArray * frameworks = [NSBundle allFrameworks];
	NSMutableArray * plugins = [NSMutableArray arrayWithArray:[NSBundle allBundles]];
	[plugins removeObjectsInArray:frameworks];// plugins are bundles
	NSBundle * mainBundle = [NSBundle mainBundle];
	[plugins removeObject:mainBundle];// plugins are bundles, except the main one
	// sorting the frameworks and plugins
	// separating them according to their domain
	NSString * networkPrefix = [[mainBundle pathForSupportDirectory:@"" inDomain:NSNetworkDomainMask create:NO] stringByAppendingString:iTM2PathComponentsSeparator];
	NSString * localPrefix = [[mainBundle pathForSupportDirectory:@"" inDomain:NSLocalDomainMask create:NO] stringByAppendingString:iTM2PathComponentsSeparator];
	NSString * userPrefix = [[mainBundle pathForSupportDirectory:@"" inDomain:NSUserDomainMask create:NO] stringByAppendingString:iTM2PathComponentsSeparator];
	
	NSMutableArray * networkFrameworks = [NSMutableArray array];
	NSMutableArray * localFrameworks = [NSMutableArray array];
	NSMutableArray * userFrameworks = [NSMutableArray array];
	NSMutableArray * otherFrameworks = [NSMutableArray array];
	NSEnumerator * E = [frameworks objectEnumerator];
	NSBundle * B = nil;
	while(B = [E nextObject])
	{
		NSString * P = [B bundlePath];
		if([P hasPrefix:userPrefix])
			[userFrameworks addObject:B];
		else if([P hasPrefix:localPrefix])
			[localFrameworks addObject:B];
		else if([P hasPrefix:networkPrefix])
			[networkFrameworks addObject:B];
		else
			[otherFrameworks addObject:B];
	}
	NSMutableArray * networkPlugIns = [NSMutableArray array];
	NSMutableArray * localPlugIns = [NSMutableArray array];
	NSMutableArray * userPlugIns = [NSMutableArray array];
	NSMutableArray * otherPlugIns = [NSMutableArray array];
	E = [frameworks objectEnumerator];
	while(B = [E nextObject])
	{
		NSString * P = [B bundlePath];
		if([P hasPrefix:userPrefix])
			[userPlugIns addObject:B];
		else if([P hasPrefix:localPrefix])
			[localPlugIns addObject:B];
		else if([P hasPrefix:networkPrefix])
			[networkPlugIns addObject:B];
		else
			[otherPlugIns addObject:B];
	}
	// reload
	#define RELOAD(ARRAY)\
	E = [ARRAY objectEnumerator];\
	while(B = [E nextObject]) [self reloadCompletionsAtPath:[B pathForResource:iTM2CompletionComponent ofType:nil]];
	RELOAD(otherFrameworks);
	RELOAD(otherPlugIns);
	[self reloadCompletionsAtPath:
		[mainBundle pathForResource:iTM2CompletionComponent ofType:nil]];
	RELOAD(networkFrameworks);
	RELOAD(networkPlugIns);
	[self reloadCompletionsAtPath:
		[mainBundle pathForSupportDirectory:iTM2CompletionComponent inDomain:NSNetworkDomainMask create:NO]];
	RELOAD(localFrameworks);
	RELOAD(localPlugIns);
	[self reloadCompletionsAtPath:
		[mainBundle pathForSupportDirectory:iTM2CompletionComponent inDomain:NSLocalDomainMask create:NO]];
	RELOAD(userFrameworks);
	RELOAD(userPlugIns);
	[self reloadCompletionsAtPath:
		[mainBundle pathForSupportDirectory:iTM2CompletionComponent inDomain:NSUserDomainMask create:YES]];
	#undef RELOAD
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  reloadCompletionsAtPath:
+ (void)reloadCompletionsAtPath:(NSString *)path;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	if(![path length])
		return;
	if(!_iTM2_CompletionServer_Data)
		_iTM2_CompletionServer_Data = [[NSMutableDictionary dictionary] retain];
	//path is expected to be the full path of a "Completions.localized" directory
	iTM2_INIT_POOL;
//iTM2_START;
	// We find all the .iTM2Completions files inside
	// those are xml file wonforming to the iTM2Completions DTD
	// then read them and append the result to the server data base.
	// The first directory level defines the category
	// the second directory level declares the context
	// All files below are merged into one database
	NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:path];
	NSString * category = nil;
	NSArray * RA = nil;
	NSError * localError = nil;
	while(category = [DE nextObject])
	{
		NSString * subpath = [path stringByAppendingPathComponent:category];
		if([[category pathExtension] pathIsEqual:iTM2CompletionsExtension])
		{
			if(RA = [self completionsWithContentsOfURL:[NSURL fileURLWithPath:subpath] error:&localError])
			{
				[self addCompletions:RA forContext:@"" ofCategory:@""];
			}
			else
			{
				iTM2_REPORTERROR(1, ([NSString stringWithFormat:@"Bad completions at path:",subpath]),localError);
			}
		}
		else
		{
			NSDirectoryEnumerator * de = [DFM enumeratorAtPath:subpath];
			NSString * context = nil;
			while(context = [de nextObject])
			{
				subpath = [subpath stringByAppendingPathComponent:context];
				if([[context pathExtension] pathIsEqual:iTM2CompletionsExtension])
				{
					if(RA = [self completionsWithContentsOfURL:[NSURL fileURLWithPath:subpath] error:&localError])
					{
						[self addCompletions:RA forContext:@"" ofCategory:category];
					}
					else
					{
						iTM2_REPORTERROR(1, ([NSString stringWithFormat:@"Bad completions at path:",subpath]),localError);
					}
				}
				else
				{
					NSDirectoryEnumerator * subde = [DFM enumeratorAtPath:subpath];
					NSString * relativePath = nil;
					while(relativePath = [subde nextObject])
					{
						if([[relativePath pathExtension] pathIsEqual:iTM2CompletionsExtension])
						{
							NSString * fullPath = [subpath stringByAppendingPathComponent:relativePath];
							if(RA = [self completionsWithContentsOfURL:[NSURL fileURLWithPath:fullPath] error:&localError])
							{
								[self addCompletions:RA forContext:context ofCategory:category];
							}
							else
							{
								iTM2_REPORTERROR(1, ([NSString stringWithFormat:@"Bad completions at path:",fullPath]),localError);
							}
						}
					}// while(relativePath = [subde nextObject])
				}
			}// while(context = [de nextObject])
		}
	}// while(category = [DE nextObject])
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addCompletions:forContext:ofCategory:
+ (void)addCompletions:(NSArray *)completions forContext:(NSString *)context ofCategory:(NSString *)category;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * MD = [self storageForContext:context ofCategory:category];
	NSMutableDictionary * allCompletions = [MD objectForKey:@"Completions"];
	if(!allCompletions)
	{
		allCompletions = [NSMutableDictionary dictionary];
		[MD setObject:allCompletions forKey:@"Completions"];
	}
	NSEnumerator * E = [completions objectEnumerator];
	NSString * completion = nil;
	while(completion = [E nextObject])
	{
		if([completion length] > 2)
		{
			NSRange R = NSMakeRange(0,2);
			NSString * prefix = [completion substringWithRange:R];
			NSMutableArray * ra = [allCompletions objectForKey:prefix];
			if(!ra)
			{
				ra = [NSMutableArray array];
				[allCompletions setObject:ra forKey:prefix];
			}
			// insert it at the right location
			int index = 0;
once_more_joe:
			if(index < [ra count])
			{
				if([[ra objectAtIndex:index] compare:(id)completion] == NSOrderedDescending)
				{
					[ra insertObject:completion atIndex:index];
				}
				else
				{
					++index;
					goto once_more_joe;
				}
			}
			else
			{
				[ra insertObject:completion atIndex:index];
			}
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= storageForContext:ofCategory:
+ (id)storageForContext:(NSString *)context ofCategory:(NSString *)category;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * MD = [_iTM2_CompletionServer_Data objectForKey:category];
	if(!MD)
	{
		MD = [NSMutableDictionary dictionary];
		[_iTM2_CompletionServer_Data setObject:MD forKey:category];
	}
	NSMutableDictionary * result = [MD objectForKey:context];
	if(!result)
	{
		result = [NSMutableDictionary dictionary];
		[MD setObject:result forKey:context];
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completionsWithContentsOfURL:error:
+ (NSArray *)completionsWithContentsOfURL:(NSURL *)url error:(NSError **)outErrorPtr;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSXMLDocument * doc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLNodeOptionsNone error:outErrorPtr] autorelease];
	NSArray * nodes = [doc nodesForXPath:@"//S" error:outErrorPtr];
	NSEnumerator * E = [nodes objectEnumerator];
	id node;
	NSMutableArray * result = [NSMutableArray array];
	while(node = [E nextObject])
	{
		NSString * string = [node stringValue];
		if([string length]>2)
		{
			[result addObject:string];
		}
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completionsForPartialWord:inContext:ofCategory:
+ (NSArray *)completionsForPartialWord:(NSString *)partialWord inContext:(NSString *)context ofCategory:(NSString *)category;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([partialWord length]<3)
	{
		return [NSArray array];
	}
	NSMutableDictionary * MD = [self storageForContext:context ofCategory:category];
	NSMutableDictionary * allCompletions = [MD objectForKey:@"Completions"];
	NSRange R = NSMakeRange(0, 2);
	NSString * substring = [partialWord substringWithRange:R];
	NSArray * ra = [allCompletions objectForKey:substring];	
	unsigned partialWordLength = [partialWord length];
	R.location = 2;
	R.length = partialWordLength - 2;
	NSEnumerator * E = [ra objectEnumerator];
	NSString * candidate = nil;
	NSMutableArray * result = [NSMutableArray array];
	while(candidate = [E nextObject])
	{
		if([candidate  length] >= partialWordLength)
		{
			NSString * substring = [candidate substringWithRange:R];
			if([substring isEqualToString:partialWord])
			{
				[result addObject:substring];
			}
		}
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editCompletionsForTextView:
- (void)editCompletionsForTextView:(NSTextView *)aTextView;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * completionIdentifier = [aTextView contextValueForKey:iTM2CompletionIdentifier domain:iTM2ContextAllDomainsMask];
	[_PatriciaControllers removeObjectForKey:completionIdentifier];
	[[iTM2CompletionInspector completionInspector] editCompletionsForTextView:aTextView];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseCompletionMode:forTextView:
- (BOOL)validateChooseCompletionMode:(id)sender forTextView:(NSTextView *)aTextView;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender isKindOfClass:[NSMenuItem class]])
	{
		return NO;
	}
	NSMenu * M = [sender menu];
	NSBundle * mainBundle = [NSBundle mainBundle];
	NSArray * allPaths = [mainBundle allPathsForResource:nil ofType:@"xml" inDirectory:iTM2CompletionComponent];
	NSEnumerator * E = [allPaths objectEnumerator];
	NSString * path = nil;
	NSMutableSet * expectedModes = [NSMutableSet set];
	while(path = [E nextObject])
	{
		path = [path lastPathComponent];
		path = [path stringByDeletingPathExtension];
		[expectedModes addObject:path];
	}
	NSArray * itemArray = [M itemArray];
	E = [itemArray objectEnumerator];
	NSMenuItem * MI = nil;
	SEL action = @selector(chooseCompletionMode:);
	NSMutableSet * availableModes = [NSMutableSet set];
	NSString * completionIdentifier = [aTextView contextValueForKey:iTM2CompletionIdentifier domain:iTM2ContextAllDomainsMask];
	while(MI = [E nextObject])
	{
		if([MI action] == action)
		{
			NSString * representedObject = [MI representedObject];
			[availableModes addObject:representedObject];
			[MI setEnabled:([completionIdentifier isEqual:representedObject]?NSOnState:NSOffState)];
		}
	}
	if([availableModes isEqual:expectedModes])
	{
//iTM2_END;
		return YES;
	}
	// the things have changed since the last time it was validated...
	E = [itemArray objectEnumerator];
	while(MI = [E nextObject])
	{
		if([MI action] == action)
		{
			[M removeItem:MI];
		}
	}
	// 
	int index = [M indexOfItem:sender] + 1;
	itemArray = [expectedModes allObjects];
	itemArray = [itemArray sortedArrayUsingSelector:@selector(compare:)];
	E = [itemArray objectEnumerator];
	while(path = [E nextObject])
	{
		MI = [[[NSMenuItem allocWithZone:[M zone]] initWithTitle:path action:action keyEquivalent:@""] autorelease];
		[MI setRepresentedObject:path];
		[MI setIndentationLevel:1];
		[M insertItem:MI atIndex:index++];
		[MI setState:([completionIdentifier isEqual:path]?NSOnState:NSOffState)];
	}
	MI = [NSMenuItem separatorItem];
	[M insertItem:MI atIndex:index++];
	[M cleanSeparators];
//iTM2_END;
	return YES;
}
@end

/*"Description forthcoming."*/
@implementation iTM2TextEditor(iTM2TextCompletionKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  complete:
- (void)complete:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![self contextBoolForKey:@"iTM2NoExtendedCompletion" domain:iTM2ContextAllDomainsMask] && ![[iTM2CompletionServer completionServer] runCompletionForTextView:self])
	{
		[super complete:sender];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSelectionToCompletion:
- (void)addSelectionToCompletion:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[iTM2CompletionServer completionServer] addSelectionToCompletionForTextView:self];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSelectionToCompletion:
- (BOOL)validateAddSelectionToCompletion:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self selectedRange].length>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editCompletions:
- (void)editCompletions:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[iTM2CompletionInspector completionInspector] editCompletionsForTextView:self];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completionMode:
- (void)completionMode:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// just a message catcher;
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseCompletionMode:
- (void)chooseCompletionMode:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * representedString = [sender representedString];
	if(representedString)
	{
		[self takeContextValue:representedString forKey:iTM2CompletionIdentifier domain:iTM2ContextAllDomainsMask];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseCompletionMode:
- (BOOL)validateChooseCompletionMode:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * representedString = [sender representedString];
	NSString * completionIdentifier = [self contextValueForKey:iTM2CompletionIdentifier domain:iTM2ContextAllDomainsMask];
	[sender setState:([representedString isEqual:completionIdentifier]?NSOnState:NSOffState)];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateCompletionMode:
- (BOOL)validateCompletionMode:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[iTM2CompletionServer completionServer] validateChooseCompletionMode:sender forTextView:self];
//iTM2_END;
	return NO;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rangeForUserCompletion
- (NSRange)rangeForUserCompletion;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super rangeForUserCompletion];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completionsForPartialWordRange:indexOfSelectedItem:
- (NSArray *)completionsForPartialWordRange:(NSRange)charRange indexOfSelectedItem:(int *)index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * RA = [super completionsForPartialWordRange:(NSRange)charRange indexOfSelectedItem:(int *)index];
	// RA contains words no longer that charRange, which is a mess for completion...
	if(charRange.length>0)
	{
		NSString * context = @"";
		NSString * category = @"";
		[self getContext:&context category:&category forPartialWordRange:(NSRange)charRange];
		NSString * partialWord = [[self string] substringWithRange:charRange];
		NSArray * ra = [iTM2CompletionServer
			completionsForPartialWord:partialWord inContext:context ofCategory:category];
		if([ra count])
		{
			if(index)
			{
				*index = 0;
			}
			return [ra arrayByAddingObjectsFromArray:RA];
		}
	}
//iTM2_END;
    return RA;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContext:category:forPartialWordRange:
- (BOOL)getContext:(NSString **)contextPtr category:(NSString **)categoryPtr forPartialWordRange:(NSRange)charRange;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(contextPtr)
	{
		*contextPtr = @"";
	}
	if(categoryPtr)
	{
		*categoryPtr = @"";
	}
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertCompletion:forPartialWordRange:movement:isFinal:
- (void)insertCompletion:(NSString *)word forPartialWordRange:(NSRange)charRange movement:(int)movement isFinal:(BOOL)flag;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
#endif
@end

@implementation iTM2CompletionWindow
- (BOOL)canBecomeKeyWindow;
{
	return YES;
}
- (void)orderWindow:(NSWindowOrderingMode)place relativeTo:(int)otherWin;
{
	if(place == NSWindowBelow)
	{
		place = NSWindowOut;// force ordering out
	}
	[super orderWindow:place relativeTo:otherWin];
	return;
}
- (void)resignKeyWindow;
{
	[[self windowController] cancelCompletion];
	return;
}
- (void)keyDown:(NSEvent *)theEvent;
{
//	NSLog(@"%@",event);
//	NSLog(@"[event characters]:%@",[event characters]);
//	NSLog(@"[event charactersIgnoringModifiers]:%@",[event charactersIgnoringModifiers]);
	NSString * characters = [theEvent characters];
	if(![characters length])
	{
		[[self windowController] forwardKeyEvent:theEvent];//dead key
		return;
	}
	unichar aCharacter = [characters characterAtIndex:0];
	if([[NSCharacterSet letterCharacterSet] characterIsMember:aCharacter])
	{
		[[self windowController] forwardKeyEvent:theEvent];
		return;
	}
	NSLog(@"characters:%u",aCharacter);
	switch(aCharacter)
	{
		case 0x001B:// escape
			[[self windowController] cancelCompletion];
			return;
		case NSCarriageReturnCharacter:
		case NSEnterCharacter:
			[[self windowController] concludeCompletion];
			return;
		case ' ':
			[[self windowController] concludeCompletionAndInsertSpace];
			return;
		case NSBackspaceCharacter:
        case NSDeleteCharacter:
			[[self windowController] forwardKeyEvent:theEvent];
			return;
		default:break;
#if 0
//		case '\n':NSLog(@"ENTER");break;
//		case '\r':NSLog(@"RETURN");break;
//		case '\t':NSLog(@"TAB");break;
		case 0x2029:NSLog(@"NSParagraphSeparatorCharacter");break;
		case 0x2028:NSLog(@"NSLineSeparatorCharacter");break;
		case 0x0009:NSLog(@"NSTabCharacter");break;
		case 0x000c:NSLog(@"NSFormFeedCharacter");break;
		case 0x000a:NSLog(@"NSNewlineCharacter");break;
		case 0x0019:NSLog(@"NSBackTabCharacter");break;
		case 0xF700:NSLog(@"NSUpArrowFunctionKey");break;
		case 0xF701:NSLog(@"NSDownArrowFunctionKey");break;
		case 0xF702:NSLog(@"NSLeftArrowFunctionKey");break;
		case 0xF703:NSLog(@"NSRightArrowFunctionKey");break;
		case 0xF704:NSLog(@"NSF1FunctionKey");break;
		case 0xF705:NSLog(@"NSF2FunctionKey");break;
		case 0xF706:NSLog(@"NSF3FunctionKey");break;
		case 0xF707:NSLog(@"NSF4FunctionKey");break;
		case 0xF708:NSLog(@"NSF5FunctionKey");break;
		case 0xF709:NSLog(@"NSF6FunctionKey");break;
		case 0xF70A:NSLog(@"NSF7FunctionKey");break;
		case 0xF70B:NSLog(@"NSF8FunctionKey");break;
		case 0xF70C:NSLog(@"NSF9FunctionKey");break;
		case 0xF70D:NSLog(@"NSF10FunctionKey");break;
		case 0xF70E:NSLog(@"NSF11FunctionKey");break;
		case 0xF70F:NSLog(@"NSF12FunctionKey");break;
		case 0xF710:NSLog(@"NSF13FunctionKey");break;
		case 0xF711:NSLog(@"NSF14FunctionKey");break;
		case 0xF712:NSLog(@"NSF15FunctionKey");break;
		case 0xF713:NSLog(@"NSF16FunctionKey");break;
		case 0xF714:NSLog(@"NSF17FunctionKey");break;
		case 0xF715:NSLog(@"NSF18FunctionKey");break;
		case 0xF716:NSLog(@"NSF19FunctionKey");break;
		case 0xF717:NSLog(@"NSF20FunctionKey");break;
		case 0xF718:NSLog(@"NSF21FunctionKey");break;
		case 0xF719:NSLog(@"NSF22FunctionKey");break;
		case 0xF71A:NSLog(@"NSF23FunctionKey");break;
		case 0xF71B:NSLog(@"NSF24FunctionKey");break;
		case 0xF71C:NSLog(@"NSF25FunctionKey");break;
		case 0xF71D:NSLog(@"NSF26FunctionKey");break;
		case 0xF71E:NSLog(@"NSF27FunctionKey");break;
		case 0xF71F:NSLog(@"NSF28FunctionKey");break;
		case 0xF720:NSLog(@"NSF29FunctionKey");break;
		case 0xF721:NSLog(@"NSF30FunctionKey");break;
		case 0xF722:NSLog(@"NSF31FunctionKey");break;
		case 0xF723:NSLog(@"NSF32FunctionKey");break;
		case 0xF724:NSLog(@"NSF33FunctionKey");break;
		case 0xF725:NSLog(@"NSF34FunctionKey");break;
		case 0xF726:NSLog(@"NSF35FunctionKey");break;
		case 0xF727:NSLog(@"NSInsertFunctionKey");break;
		case 0xF728:NSLog(@"NSDeleteFunctionKey");break;
		case 0xF729:NSLog(@"NSHomeFunctionKey");break;
		case 0xF72A:NSLog(@"NSBeginFunctionKey");break;
		case 0xF72B:NSLog(@"NSEndFunctionKey");break;
		case 0xF72C:NSLog(@"NSPageUpFunctionKey");break;
		case 0xF72D:NSLog(@"NSPageDownFunctionKey");break;
		case 0xF72E:NSLog(@"NSPrintScreenFunctionKey");break;
		case 0xF72F:NSLog(@"NSScrollLockFunctionKey");break;
		case 0xF730:NSLog(@"NSPauseFunctionKey");break;
		case 0xF731:NSLog(@"NSSysReqFunctionKey");break;
		case 0xF732:NSLog(@"NSBreakFunctionKey");break;
		case 0xF733:NSLog(@"NSResetFunctionKey");break;
		case 0xF734:NSLog(@"NSStopFunctionKey");break;
		case 0xF735:NSLog(@"NSMenuFunctionKey");break;
		case 0xF736:NSLog(@"NSUserFunctionKey");break;
		case 0xF737:NSLog(@"NSSystemFunctionKey");break;
		case 0xF738:NSLog(@"NSPrintFunctionKey");break;
		case 0xF739:NSLog(@"NSClearLineFunctionKey");break;
		case 0xF73A:NSLog(@"NSClearDisplayFunctionKey");break;
		case 0xF73B:NSLog(@"NSInsertLineFunctionKey");break;
		case 0xF73C:NSLog(@"NSDeleteLineFunctionKey");break;
		case 0xF73D:NSLog(@"NSInsertCharFunctionKey");break;
		case 0xF73E:NSLog(@"NSDeleteCharFunctionKey");break;
		case 0xF73F:NSLog(@"NSPrevFunctionKey");break;
		case 0xF740:NSLog(@"NSNextFunctionKey");break;
		case 0xF741:NSLog(@"NSSelectFunctionKey");break;
		case 0xF742:NSLog(@"NSExecuteFunctionKey");break;
		case 0xF743:NSLog(@"NSUndoFunctionKey");break;
		case 0xF744:NSLog(@"NSRedoFunctionKey");break;
		case 0xF745:NSLog(@"NSFindFunctionKey");break;
		case 0xF746:NSLog(@"NSHelpFunctionKey");break;
		case 0xF747:NSLog(@"NSModeSwitchFunctionKey");break;
		default:NSLog(@"???????");break;
#endif
	}
	[super keyDown:theEvent];
	return;
}
@end

@interface iTM2PredicateMatchExpressionValidator:NSValueTransformer
@end
@implementation iTM2PredicateMatchExpressionValidator
+ (Class)transformedValueClass;
{
    return [NSString class];
}
+ (BOOL)allowsReverseTransformation;
{
    return YES;   
}
- (id)transformedValue:(id)value;
{
iTM2_LOG(@"value:%@",value);
    return value;
}
- (id)reverseTransformedValue:(id)value;
{
iTM2_LOG(@"value:%@",([value evaluateWithObject:[NSNull null]]?@"Y":@"N"));
    return value;
}
@end

#import <iTM2Foundation/iTM2InstallationKit.h>

@implementation iTM2MainInstaller(iTM2PredicateMatchExpressionValidator);
+ (void)iTM2PredicateMatchExpressionValidatorCompleteInstallation;
{
	iTM2PredicateMatchExpressionValidator * transformer = [[[iTM2PredicateMatchExpressionValidator alloc] init] autorelease];
	[NSValueTransformer setValueTransformer:transformer forName:@"iTM2PredicateMatchExpressionValidator"];
	return;
}
@end

@implementation iTM2CompletionInspector
static id iTM2SharedCompletionInspector = nil;
+ (void)initialize;
{
    [self setKeys:[NSArray arrayWithObjects:@"selectedCompletionSet",nil] triggerChangeNotificationsForDependentKey:@"completions"];
	[iTM2CompletionServer class];
	return;
}
+ (id)completionInspector;
{
	return iTM2SharedCompletionInspector?:(iTM2SharedCompletionInspector=[[iTM2CompletionInspector alloc] initWithWindowNibName:NSStringFromClass([self class])]);
}
- (id)initWithWindow:(NSWindow *)window;
{
	if(iTM2SharedCompletionInspector)
	{
		[self release];
		return [iTM2SharedCompletionInspector retain];
	}
	NSAssert((iTM2SharedCompletionInspector = [super initWithWindow:window]),@"BUG, please report error iTM2 9669-4");
	[_CompletionSets autorelease];
	_CompletionSets = [[NSMutableDictionary dictionary] retain];
	NSBundle * mainBundle = [NSBundle mainBundle];
	NSArray * allPaths = [mainBundle allPathsForResource:nil ofType:@"xml" inDirectory:iTM2CompletionComponent];
	NSEnumerator * E = [allPaths objectEnumerator];
	NSString * path = nil;
	while(path = [E nextObject])
	{
		path = [path lastPathComponent];
		path = [path stringByDeletingPathExtension];
		[_CompletionSets setObject:[NSNull null] forKey:path];
	}
	return iTM2SharedCompletionInspector;
}
- (void)dealloc;
{
	[_CompletionSets autorelease];
	_CompletionSets = nil;
	[newCompletionSet autorelease];
	newCompletionSet = nil;
	[self setSelectedCompletionSet:nil];
	[super dealloc];
}
- (NSString *)selectedCompletionSet;
{
	return selectedCompletionSet;
}
- (void)setSelectedCompletionSet:(NSString *)newSet;
{
	[selectedCompletionSet autorelease];// is it necessary
	selectedCompletionSet = [newSet copy];
	return;
}
- (void)editCompletionsForTextView:(NSTextView *)aTextView;
{
	NSString * completionIdentifier = [aTextView contextValueForKey:iTM2CompletionIdentifier domain:iTM2ContextAllDomainsMask];
	[self setSelectedCompletionSet:completionIdentifier];
	NSWindow * window = [self window];// load the window
	[window makeKeyAndOrderFront:self];
	return;
}
- (int)countOfCompletionSets;
{
	return [_CompletionSets count];
}
-(id)objectInCompletionSetsAtIndex:(int)index;
{
	NSArray * keys = [_CompletionSets allKeys];
	return index<[keys count]?[keys objectAtIndex:index]:@"Default";
}
- (void)insertObject:(id)anObject inCompletionSetsAtIndex:(int)index;
{
iTM2_LOG(@"anObject:%@",anObject);
	return;
}
- (void)removeObjectFromCompletionSetsAtIndex:(int) index;
{
	NSArray * keys = [_CompletionSets allKeys];
	if(index>=0 && index<[keys count])
	{
		[self willChangeValueForKey:@"completionSets"];
		NSString * key = (selectedCompletionSet?:@"Default");
		NSMutableArray * MRA = [_CompletionSets objectForKey:key];
		[MRA removeObjectAtIndex:index];
		[self didChangeValueForKey:@"completionSets"];
	}
	return;
}
- (NSArray *)completionSortDescriptors;
{
	NSSortDescriptor * descriptor = [[[NSSortDescriptor alloc] initWithKey:@"string" ascending:YES] autorelease];
	return [NSArray arrayWithObject:descriptor];
}
- (NSMutableArray *)currentCompletions;
{
	NSString * identifier = (selectedCompletionSet?:@"Default");
	id result = [_CompletionSets objectForKey:identifier];
	if(![result isKindOfClass:[NSArray class]])
	{
		result = [NSMutableArray array];
		[_CompletionSets setObject:result forKey:identifier];
		// I must load some strings
		// first we load the application support ressource
		NSArray * ra = [[NSBundle mainBundle] pathsForSupportResource:identifier ofType:@"xml" inDirectory:iTM2CompletionComponent domains:NSUserDomainMask];
		NSEnumerator * E = [ra objectEnumerator];
		NSString * component;
		while(component = [E nextObject])
		{
			NSURL * url = [NSURL fileURLWithPath:component];
			NSError * error = nil;
			NSXMLDocument * document = [[[NSXMLDocument allocWithZone:[self zone]] initWithContentsOfURL:url options:0 error:&error] autorelease];
			if(error)
			{
				[NSApp presentError:error];
			}
			else
			{
				NSArray * nodes = [document nodesForXPath:@"//S" error:&error];
				if(error)
				{
					[NSApp presentError:error];
				}
				else
				{
					NSEnumerator * E = [nodes objectEnumerator];
					NSXMLElement * element;
					while(element = [E nextObject])
					{
						NSMutableDictionary * D = [NSMutableDictionary dictionary];
						[D setObject:element forKey:@"XMLElement"];
						[element detach];
						NSString * string = [element stringValue];
						[D setObject:string forKey:@"initial"];
						[D setObject:@"" forKey:@"original"];// no original data
						[D setObject:string forKey:@"string"];
						[D setObject:[NSNumber numberWithBool:YES] forKey:@"isMutable"];
						[result addObject:D];
					}
				}
			}
		}
	}
	return result;
}
- (int)countOfCompletions;
{
	return [[self currentCompletions] count];
}
- (id)objectInCompletionsAtIndex:(int)index;
{
	return [[self currentCompletions] objectAtIndex:index];
}
- (void)insertObject:(id)anObject inCompletionsAtIndex:(int)index;
{
	[self willChangeValueForKey:@"completions"];
	[anObject setObject:@"" forKey:@"string"];
	[anObject setObject:@"" forKey:@"original"];
	[anObject setObject:@"" forKey:@"initial"];
	[anObject setObject:[NSNumber numberWithBool:YES] forKey:@"isMutable"];
	NSMutableArray * MRA = [self currentCompletions];
	[MRA insertObject:anObject atIndex:index];
	NSArray * sortDescriptors = [self completionSortDescriptors];
	[MRA sortUsingDescriptors:sortDescriptors];
	[self didChangeValueForKey:@"completions"];
	return;
}
- (void)removeObjectFromCompletionsAtIndex:(int) index;
{
	[self willChangeValueForKey:@"completions"];
	NSMutableArray * MRA = [self currentCompletions];
	[MRA removeObjectAtIndex:index];
	[self didChangeValueForKey:@"completions"];
	return;
}
- (IBAction)OK:(id)sender;
{
	//save?
	NSLog(@"OK (%i)",selectedCompletionSet);
	NSArray * sortDescriptors = [self completionSortDescriptors];
	NSEnumerator * E = [_CompletionSets keyEnumerator];
	NSString * key;
	while(key = [E nextObject])
	{
		NSMutableArray * MRA = [_CompletionSets objectForKey:key];
		NSEnumerator * e = [MRA objectEnumerator];
		NSDictionary * D;
		MRA = [NSMutableArray array];
		BOOL shouldSave = NO;
		NSString * string = nil;
		while(D = [e nextObject])
		{
			NSString * original = [D objectForKey:@"original"];// from various Library/Application Support
			string = [D objectForKey:@"string"];// the "visible" string
			NSString * initial = [D objectForKey:@"initial"];// the string read from the HD
			if(![string isEqual:original])
			{
				[MRA addObject:D];
			}
			if(!shouldSave && ![string isEqual:initial])
			{
				shouldSave = YES;
			}
		}
		if([MRA count])
		{
			[MRA sortUsingDescriptors:sortDescriptors];
			if(shouldSave)
			{
				NSXMLElement * root = [NSXMLElement elementWithName:@"STRINGLIST"];
				e = [MRA objectEnumerator];
				NSXMLElement * child = nil;
				while(D = [e nextObject])
				{
					string = [D objectForKey:@"string"];
					if(child = [D objectForKey:@"XMLElement"])
					{
						[child setStringValue:string];
					}
					else
					{
						child = [NSXMLElement elementWithName:@"S" stringValue:string];
					}
					[root addChild:child];
				}
				NSXMLDocument * doc = [[[NSXMLDocument allocWithZone:[self zone]] initWithRootElement:root] autorelease];
				[doc setCharacterEncoding:@"UTF-8"];
				key = [key stringByAppendingPathExtension:@"xml"];
				NSString * path = [[NSBundle mainBundle] pathForSupportDirectory:iTM2CompletionComponent inDomain:NSUserDomainMask create:YES];
				key = [path stringByAppendingPathComponent:key];
				NSURL * url = [NSURL fileURLWithPath:key];
				if(![[doc XMLDataWithOptions:NSXMLNodePrettyPrint] writeToURL:url atomically:YES])
				{
					NSLog(@"****  FAILURE: %@",url);
				}
				e = [MRA objectEnumerator];
				while(D = [e nextObject])
				{
					child = [D objectForKey:@"XMLElement"];
					[child detach];
				}
			}
		}
	}
	[self close];
}
- (IBAction)cancel:(id)sender;
{
	NSLog(@"cancel");
	[self close];
	return;
}
- (NSString *)newCompletionSet;
{
	return newCompletionSet;
}
- (void)setNewCompletionSet:(NSString *)aNewCompletionSet;
{
	[newCompletionSet autorelease];
	newCompletionSet = [aNewCompletionSet copy];
	[NSApp endSheet:panel returnCode:([newCompletionSet length]>0?NSOKButton:NSCancelButton)];
	return;
}
- (IBAction)addCompletionSet:(id)sender;
{
	[NSApp beginSheet:panel modalForWindow:[self window] modalDelegate:self didEndSelector:@selector(newCompletionSetPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
	return;
}
- (void)newCompletionSetPanelDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;
{
    [sheet orderOut:self];
	if(returnCode == NSOKButton)
	{
		[self willChangeValueForKey:@"completionSets"];
		[_CompletionSets setObject:[NSMutableArray array] forKey:newCompletionSet];
		[self didChangeValueForKey:@"completionSets"];
		[self setSelectedCompletionSet:newCompletionSet];
	}
	return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextCompletionKit

