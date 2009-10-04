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
#import <iTM2Foundation/iTM2MacroKit.h>
#import <iTM2Foundation/iTM2MacroKit_Tree.h>
#import <iTM2Foundation/iTM2TextKit.h>

NSString * const iTM2CompletionComponent = @"Completion.localized";

@interface iTM2CompletionServer(PRIVATE)
- (NSArray *)completionModes;
- (iTM2PatriciaController *)patriciaControllerForTextView:(NSTextView *)aTextView;
- (void)addSelectionToCompletionForTextView:(NSTextView *)aTextView;
- (int)runCompletionForTextView:(NSTextView *)aTextView;
- (void)updateCompletion;
- (void)showCompletionWindow;
- (void)updateCompletionWindow;
- (void)cancelCompletion;
- (void)concludeCompletionAndInsertSpace:(BOOL)yorn;
- (void)forwardKeyEvent:(NSEvent *)theEvent;
+ (void)addCompletions:(NSArray *)completions forContext:(NSString *)context ofCategory:(NSString *)category;
+ (id)storageForContext:(NSString *)context ofCategory:(NSString *)category;
@end

#import <iTM2Foundation/iTM2ContextKit.h>

@interface iTM2CompletionWindow:NSPanel
@end

@interface iTM2CompletionFormatter:NSFormatter
@end
@implementation iTM2CompletionFormatter
- (NSString *)stringForObjectValue:(id)obj;//obj must be an attributed string!!
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [obj isKindOfClass:[NSString class]]?
		[obj stringByRemovingPlaceholderMarks]:
		[[obj string] stringByRemovingPlaceholderMarks];
}
- (NSAttributedString *)attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary *)attrs;
{
	NSString * str = [self stringForObjectValue:obj];
	return [[[NSAttributedString alloc] initWithString:(NSString *)str attributes:(NSDictionary *)attrs] autorelease];
}
- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString **)error;
{
	if(error)
	{
		*error = nil;
	}
	return NO;
}
@end

@interface NSTextView(iTM2TextCompletionKit)
- (NSRange)proposedRangeForUserCompletion:(NSRange)range;
- (NSRange)SWZ_iTM2_rangeForUserCompletion;
@end

@interface NSObject(PRIVATE)
- (id)keyBindingTree;
- (id)objectInChildrenWithDomain:(NSString *)key;
- (id)objectInChildrenWithCategory:(NSString *)key;
- (id)objectInChildrenWithContext:(NSString *)key;
- (id)objectInChildrenWithKey:(NSString *)key;
- (id)objectInChildrenWithAltKey:(NSString *)key;
- (NSArray *)availableIDs;
- (void)insertObject:(id)object inAvailableMacrosAtIndex:(int)index;
@end

#import "iTM2MacroKit_Tree.h"
#import "iTM2MacroKit_Controller.h"

@implementation iTM2MacroController(Completion)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= IDsForContext:ofCategory:inDomain:
- (NSArray *)IDsForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MacroRootNode * rootNode = [self macroTree];
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	iTM2MacroCategoryNode * categoryNode = [domainNode objectInChildrenWithCategory:category];
	iTM2MacroContextNode * contextNode = [categoryNode objectInChildrenWithContext:context];
//iTM2_END;
	return [[contextNode macros] allKeys];
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextCompletionKit
static id _iTM2_CompletionServer_Data = nil;
@implementation iTM2CompletionServer
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
//		[W setFrameTopLeftPoint:bottomLeft];
		// It is not possible to catch all the events because it is not like in a mouse down/drag operation
		// there is a problem of windows not ordering front (at least) when we switch apps
//		[[self window] removeChildWindow:W];
	}
//iTM2_END;
	return self;
}
- (void)dealloc;
{
	[_LongCandidates autorelease];
	_LongCandidates = nil;
	[_TextView autorelease];
	_TextView = nil;
	[_Tab autorelease];
	_Tab = nil;
	[_OriginalString autorelease];
	_OriginalString = nil;
	[_EditedString autorelease];
	_EditedString = nil;
	[_ShortCompletionString autorelease];
	_ShortCompletionString = nil;
	[_LongCompletionString autorelease];
	_LongCompletionString = nil;
	[_ReplacementLines autorelease];
	_ReplacementLines = nil;
	[_OriginalSelectedString autorelease];
	_OriginalSelectedString = nil;
	[_PatriciaControllers autorelease];
	_PatriciaControllers = nil;
	[DNC removeObserver:self name:NSWindowWillCloseNotification object:nil];
	[super dealloc];
	return;
}
- (NSArray *)completionModes;
{
	return [_PatriciaControllers allKeys];
}
- (iTM2PatriciaController *)patriciaControllerForTextView:(NSTextView *)aTextView;
{
	NSString * macroDomain = aTextView?[aTextView macroDomain]:@"";
	NSString * completionMode = aTextView?[aTextView macroCategory]:@"";
	NSString * macroContext = aTextView?[aTextView macroContext]:@"";
	iTM2PatriciaController * patriciaController = [_PatriciaControllers objectForKey:completionMode];
	if(![patriciaController isKindOfClass:[iTM2PatriciaController class]])
	{
		patriciaController = [[[iTM2PatriciaController allocWithZone:[self zone]] init] autorelease];
		[_PatriciaControllers setObject:patriciaController forKey:completionMode];
		// read all the macros identifiers
		NSArray * strings = [SMC IDsForContext:macroContext ofCategory:completionMode inDomain:macroDomain];
		[patriciaController addStrings:strings];
		// now read all the completion files
	}
	return patriciaController;
}
#warning FAILED: addSelectionToCompletionForTextView broken
#if 0
- (void)addSelectionToCompletionForTextView:(NSTextView *)aTextView;
{
	NSParameterAssert(aTextView);
	iTM2PatriciaController * patriciaController = [self patriciaControllerForTextView:aTextView];
	NSArray * selectedRanges = [aTextView selectedRanges];
	NSString * string = [aTextView string];
	NSMutableArray * stringList = [NSMutableArray arrayWithCapacity:[selectedRanges count]];
	NSEnumerator * E = [selectedRanges objectEnumerator];
	NSValue * V;
	id node = [SMC macroTree];
	node = [node objectInChildrenWithDomain:[aTextView macroDomain]];
	node = [node objectInChildrenWithCategory:[aTextView macroCategory]];
	node = [node objectInChildrenWithContext:[aTextView macroContext]];
	NSArray * availableIDs = [node availableIDs];
	while(V = [E nextObject])
	{
		NSRange range = [V rangeValue];
		NSString * substring = [string substringWithRange:range];
		if([substring length] && ![availableIDs containsObject:substring])
		{
			id object = [[[iTM2MacroNode allocWithZone:[node zone]] init] autorelease];
			[object setMacroID:substring];
			[node insertObject:object inAvailableMacrosAtIndex:0];
			[stringList addObject:substring];
		}
	}
	[patriciaController addStrings:stringList];
	// save the modification
	node = [SMC macroTree];
	[SMC saveMacroTree:node];
//iTM2_LOG(@"[patriciaController stringList]:%@",[patriciaController stringList]);
	return;
}
#endif
- (NSArray *)completionsForTextView:(NSTextView *)aTextView partialWordRange:(NSRange)charRange indexOfSelectedItem:(int *)indexPtr;
{
	NSParameterAssert(aTextView);
	iTM2PatriciaController * patriciaController1 = [self patriciaControllerForTextView:aTextView];
	NSString * string = [aTextView string];
	string = [string substringWithRange:charRange];
	id result1 = [patriciaController1 stringListForPrefix:string];
	iTM2PatriciaController * patriciaController2 = [self patriciaControllerForTextView:nil];
	if(indexPtr)
	{
		*indexPtr = 0;
	}
	if([patriciaController1 isEqual:patriciaController2])
	{
		return result1;
	}
	NSArray * result2 = [patriciaController2 stringListForPrefix:string];
	if([result1 count])
	{
		if([result2 count])
		{
			result1 = [[result1 mutableCopy] autorelease];
			// now merging the two arrays
			int idx1 = [result1 count] - 1;
			int idx2 = [result2 count] - 1;
			NSString * S1 = [result1 objectAtIndex:idx1];
			NSString * S2 = [result2 objectAtIndex:idx2];
			int compare;
grosbois:
			compare = [S1 compare:S2];
			if(compare == NSOrderedDescending)
			{
				// S2 should be inserted before S1
				if(idx1)
				{
					--idx1;
					S1 = [result1 objectAtIndex:idx1];
				}
				else
				{
					// S1 is the first object
					[result1 insertObject:S2 atIndex:idx1];
					while(idx2--)
					{
						S2 = [result2 objectAtIndex:idx2];
						[result1 insertObject:S2 atIndex:idx1];
					}
				}
			}
			else if(compare == NSOrderedAscending)
			{
				[result1 insertObject:S2 atIndex:idx1+1];
				if(idx2--)
				{
					S2 = [result2 objectAtIndex:idx2];
					goto grosbois;
				}
			}
			else if(idx2--)
			{
				S2 = [result2 objectAtIndex:idx2];
				goto grosbois;
			}
		}
		return result1;
	}
	else
	{
		return result2;
	}
}
- (int)runCompletionForTextView:(NSTextView *)aTextView;
{
	NSParameterAssert(aTextView);
	// clean any previous discussion
	NSWindow * completionWindow = [self window];
	if([completionWindow parentWindow])
	{
		[self cancelCompletion];
		return 2;
	}
	[self cancelCompletion];
	
	// is there something to complete with?
	_RangeForUserCompletion = [aTextView rangeForUserCompletion];
	_RangeForUserCompletion = [aTextView proposedRangeForUserCompletion:_RangeForUserCompletion];
	if(!_RangeForUserCompletion.length)
	{
		return 3;
	}
	_TextView = [aTextView retain];
	int selectedRow = 0;
	_LongCandidates = [_TextView completionsForPartialWordRange:_RangeForUserCompletion indexOfSelectedItem:&selectedRow];
	unsigned numberOfRows = [_LongCandidates count];
	if(!numberOfRows)
	{
		_LongCandidates = nil;
		return 4;
	}
	[_LongCandidates retain];
//iTM2_LOG(@"%@:_LongCandidates",_LongCandidates);
	int idx = [_TextView numberOfSpacesPerTab];
	if(idx<=0)
	{
		_Tab = @"\t";
	}
	else
	{
		NSMutableString * MS = [NSMutableString string];
		while(idx--)
		{
			[MS appendString:@" "];
		}
		_Tab = [MS copy];
	}
	_SelectedRange = [_TextView selectedRange];
	NSString * S = [_TextView string];
	_OriginalSelectedString = [S substringWithRange:_SelectedRange];
	_OriginalSelectedString = [_OriginalSelectedString copy];
	// Get the indentation level at the line where we are going to insert things
	int numberOfSpacesPerTab = [_TextView numberOfSpacesPerTab]?:4;
	numberOfSpacesPerTab = abs(numberOfSpacesPerTab);
	unsigned start, contentsEnd;
	NSRange R = _RangeForUserCompletion;
	R.length = 0;
	[S getLineStart:&start end:nil contentsEnd:&contentsEnd forRange:R];
	_IndentationLevel = 0;
	unsigned currentLength = 0;
	while(start<contentsEnd)
	{
		unichar theChar = [S characterAtIndex:start++];
		if(theChar == ' ')
		{
			++currentLength;
		}
		else if(theChar == '\t')
		{
			++_IndentationLevel;
			_IndentationLevel += (2*currentLength)/numberOfSpacesPerTab;
			currentLength = 0;
		}
		else
		{
			break;
		}
	}
	_IndentationLevel += (2*currentLength)/numberOfSpacesPerTab;
	
	// get the indentation in the original selected string, starting at the second line
	// then split the selection into lines in order to manage the indentation
	// ensuring that the white prefix is of the apropriate format
	NSMutableArray * replacementLines = [NSMutableArray array];
	R = NSMakeRange(0,0);
	[_OriginalSelectedString getLineStart:nil end:&R.location contentsEnd:nil forRange:R];
	NSString * blackString = [_OriginalSelectedString substringWithRange:NSMakeRange(0,R.location)];
	[replacementLines addObject:blackString];
	NSMutableArray * whitePrefixes = [NSMutableArray array];
	NSMutableArray * blackStrings = [NSMutableArray array];
	unsigned indentationOfTheSelectedString = 0;
	NSNumber * N;
	unsigned end;
	unsigned lineIndentation = 0;
	if(R.location < [_OriginalSelectedString length])
	{
		indentationOfTheSelectedString = UINT_MAX;
		do
		{
			[_OriginalSelectedString getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
			lineIndentation = 0;
			while(R.location<contentsEnd)
			{
				unichar theChar = [_OriginalSelectedString characterAtIndex:R.location++];
				if(theChar == ' ')
				{
					++currentLength;
				}
				else if(theChar == '\t')
				{
					++lineIndentation;
					lineIndentation += (2*currentLength)/numberOfSpacesPerTab;
					currentLength = 0;
				}
				else
				{
					break;
				}
			}
			lineIndentation += (2*currentLength)/numberOfSpacesPerTab;
			if(lineIndentation<indentationOfTheSelectedString)
			{
				indentationOfTheSelectedString = lineIndentation;
			}
			N = [NSNumber numberWithUnsignedInt:lineIndentation];
			[whitePrefixes addObject:N];
			blackString = [_OriginalSelectedString substringWithRange:NSMakeRange(R.location,end-R.location)];
			[blackStrings addObject:blackString];
			R.location = end;
		}
		while(R.location < [_OriginalSelectedString length]);
	}
	NSEnumerator * whiteE = [whitePrefixes objectEnumerator];
	NSEnumerator * blackE = [blackStrings objectEnumerator];
	while((N = [whiteE nextObject]) && (blackString = [blackE nextObject]))
	{
		lineIndentation = [N unsignedIntValue];
		lineIndentation -= indentationOfTheSelectedString;
		if(lineIndentation)
		{
			NSMutableString * MS = [NSMutableString string];
			while(lineIndentation--)
			{
				[MS appendString:_Tab];
			}
			[MS appendString:blackString];
			[replacementLines addObject:MS];
		}
		else
		{
			[replacementLines addObject:blackString];
		}
	}
	_ReplacementLines = [replacementLines copy];
//iTM2_LOG(@"%@:_ReplacementLines",_ReplacementLines);

	_EditedRangeForUserCompletion = _RangeForUserCompletion;
	NSUndoManager * undoManager = [_TextView undoManager];
	if(_ShouldEnableUndoRegistration = [undoManager isUndoRegistrationEnabled])
	{
		NSLog(@"disableUndoRegistration");
		[undoManager disableUndoRegistration];
	}
	_OriginalString = [_TextView string];
	_OriginalString = [_OriginalString substringWithRange:_RangeForUserCompletion];
	_OriginalString = [_OriginalString copy];
	// establish connections with the table view
	[_TableView setDataSource:self];
	[_TableView setDelegate:self];
	[_TableView setTarget:self];// self is expected to last forever
	[_TableView setDoubleAction:@selector(_concludeCompletion:)];
	[_TableView setAllowsMultipleSelection:NO];
	[_TableView reloadData];
	[_TableView selectRow:selectedRow byExtendingSelection:NO];
	[self updateCompletion];
	[self showCompletionWindow];
	return 0;
}
- (void)updateCompletion;
{
	int row = [_TableView selectedRow];
	NSTableColumn * tableColumn = [_TableView tableColumnWithIdentifier:@"completion"];
	id dataSource = [_TableView dataSource];
	NSString * completion = [dataSource tableView:_TableView objectValueForTableColumn:tableColumn row:row];
	if(![completion isKindOfClass:[NSString class]])
	{
		completion = _OriginalString;
	}
	[_LongCompletionString autorelease];
	_LongCompletionString = [_TextView replacementStringForMacro:completion selection:_OriginalSelectedString line:@""];
	_LongCompletionString = [_LongCompletionString copy];
	[_ShortCompletionString autorelease];
	_ShortCompletionString = [[_LongCompletionString stringByRemovingPlaceholderMarks] copy];
	[_TextView insertCompletion:_ShortCompletionString forPartialWordRange:_RangeForUserCompletion movement:NSOtherTextMovement isFinal:NO];
	_EditedRangeForUserCompletion.length = [completion length];
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
- (void)showCompletionWindow;
{
	//where should I draw the window
	[DNC addObserver:self selector:@selector(windowWillCloseNotified:) name:NSWindowWillCloseNotification object:[_TextView window]];
	NSLayoutManager * layoutManager = [_TextView layoutManager];
	NSRange glyphRange = [layoutManager glyphRangeForCharacterRange:_RangeForUserCompletion actualCharacterRange:nil];
	NSTextContainer * container = [layoutManager textContainerForGlyphAtIndex:glyphRange.location effectiveRange:nil];
	NSRect rect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:container];
	rect = [_TextView convertRect:rect toView:nil];// rect is now in window coordinates
	NSWindow * textViewWindow = [_TextView window];
	NSPoint bottomLeft = rect.origin;
	bottomLeft = [textViewWindow convertBaseToScreen:bottomLeft];
	NSPoint topRight = NSMakePoint(NSMaxX(rect),NSMaxY(rect));
	topRight = [textViewWindow convertBaseToScreen:topRight];
	NSRect textRect = NSZeroRect;
	textRect.origin = bottomLeft;
	textRect = NSInsetRect(textRect,-4,-1);
	rect = NSZeroRect;
	rect.origin = topRight;
	rect = NSInsetRect(rect,-4,-1);
	textRect = NSUnionRect(textRect,rect);
	// now textRect is the rectangle containing the range of the glyphs used for user completion
	// in screen coordinates
	// some adjustements were made to properly align the completions with the text view characters
	
	NSRect screenVisibleFrame = [[NSScreen mainScreen] visibleFrame];
	
	NSWindow * completionWindow = [self window];

	NSRect completionRect = [completionWindow frame];// in screen coordinates
	
	// grow the window to its biggest size
	// we will place the window on screen later
	completionRect.size.height = screenVisibleFrame.size.height * 0.3;
	completionRect.size.width = screenVisibleFrame.size.width * 0.3;
	[completionWindow setFrame:completionRect display:NO];// subviews should have their size modified
	NSScrollView * scrollView = [_TableView enclosingScrollView];
	NSClipView * contentView = [scrollView contentView];
	NSRect contentVisibleRect = [contentView visibleRect];
	contentVisibleRect = [contentView convertRect:contentVisibleRect toView:nil];
	NSRect documentRect = [_TableView bounds];
	// compute the minimal rect containing the table view
	// only the documentRect's size will be used
	documentRect.size.width = 0;
	NSArray * tableColumns = [_TableView tableColumns];
	NSTableColumn * tableColumn;
	unsigned numberOfRows = [_LongCandidates count];
	for(tableColumn in tableColumns)
	{
		unsigned row = 0;
		NSSize size = NSZeroSize;
		float maxWidth = 0;
		float maxHeight = 0;
		NSCell * cell;
		while(row<numberOfRows)
		{
			cell = [tableColumn dataCellForRow:row];
			NSString * aString = [_LongCandidates objectAtIndex:row];
			NSAttributedString * anAttributesString = [[[NSAttributedString allocWithZone:[self zone]] initWithString:aString attributes:nil] autorelease];
			[cell setAttributedStringValue:anAttributesString];// using only setStringValue does not work, the formatter is not called to compute the cell size...
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
		documentRect.size.width += maxWidth;
		if(documentRect.size.height>maxHeight)
		{
			documentRect.size.height = maxHeight;
		}
	}
	documentRect.size.width += 17;// correction: column too narrow, the last char is cut off
	documentRect = [_TableView convertRect:documentRect toView:nil];
	// adjust the width
	if(documentRect.size.width<contentVisibleRect.size.width)
	{
		completionRect.size.width -= contentVisibleRect.size.width - documentRect.size.width;
	}
	// adjust the height
	if(documentRect.size.height<contentVisibleRect.size.height)
	{
		completionRect.size.height -= contentVisibleRect.size.height - documentRect.size.height;
	}

	completionRect.origin.x = MIN(bottomLeft.x, NSMaxX(screenVisibleFrame) - completionRect.size.width);

	float midAnchorY = NSMidY(textRect);
	if(midAnchorY>NSMidY(screenVisibleFrame))
	{
		// draw in the lowest part of the screen
		completionRect.origin.y = bottomLeft.y - completionRect.size.height;		
	}
	else
	{
		completionRect.origin.y = topRight.y;		
	}
	[completionWindow setFrame:completionRect display:YES];
	[textViewWindow addChildWindow:completionWindow ordered:NSWindowAbove];
	[completionWindow makeKeyAndOrderFront:self];
	return;
}
- (void)updateCompletionWindow;
{
	NSWindow * completionWindow = [self window];
	if(![completionWindow parentWindow])
	{
		return;// prevents updating when not attached
	}
	//where should I draw the window
	NSLayoutManager * layoutManager = [_TextView layoutManager];
	NSRange glyphRange = [layoutManager glyphRangeForCharacterRange:_RangeForUserCompletion actualCharacterRange:nil];
	NSTextContainer * container = [layoutManager textContainerForGlyphAtIndex:glyphRange.location effectiveRange:nil];
	NSRect rect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:container];
	rect = [_TextView convertRect:rect toView:nil];// rect is now in window coordinates
	NSWindow * textViewWindow = [_TextView window];
	NSPoint bottomLeft = rect.origin;
	bottomLeft = [textViewWindow convertBaseToScreen:bottomLeft];
	NSPoint topRight = NSMakePoint(NSMaxX(rect),NSMaxY(rect));
	topRight = [textViewWindow convertBaseToScreen:topRight];
	NSRect textRect = NSZeroRect;
	textRect.origin = bottomLeft;
	textRect = NSInsetRect(textRect,-4,-1);
	rect = NSZeroRect;
	rect.origin = topRight;
	rect = NSInsetRect(rect,-4,-1);
	textRect = NSUnionRect(textRect,rect);
	// now textRect is the rectangle containing the range of the glyphs used for user completion
	// in screen coordinates
	// some adjustements were made to properly align the completions with the text view characters
	
	NSRect screenVisibleFrame = [[NSScreen mainScreen] visibleFrame];
	
	NSRect completionRect = [completionWindow frame];// in screen coordinates
	
	// grow the window to its biggest size
	// we will place the window on screen later
	NSScrollView * scrollView = [_TableView enclosingScrollView];
	NSClipView * contentView = [scrollView contentView];
	NSRect contentVisibleRect = [contentView visibleRect];
	contentVisibleRect = [contentView convertRect:contentVisibleRect toView:nil];
	NSRect documentRect = [_TableView bounds];
	documentRect = [_TableView convertRect:documentRect toView:nil];
	// compute the minimal rect containing the table view
	// only the documentRect's size will be used
	documentRect.size.width = 0;
	NSArray * tableColumns = [_TableView tableColumns];
	NSTableColumn * tableColumn;
	unsigned numberOfRows = [_LongCandidates count];
	for(tableColumn in tableColumns)
	{
		unsigned row = 0;
		NSSize size = NSZeroSize;
		float maxWidth = 0;
		float maxHeight = 0;
		NSCell * cell;
		while(row<numberOfRows)
		{
			cell = [tableColumn dataCellForRow:row];
			NSString * aString = [_LongCandidates objectAtIndex:row];
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
		documentRect.size.width += maxWidth;
		if(documentRect.size.height>maxHeight)
		{
			documentRect.size.height = maxHeight;
		}
	}
	documentRect.size.width += 17;// correction: column too narrow, the last char is cut off
	documentRect = [_TableView convertRect:documentRect toView:nil];
	// adjust the width
	if(documentRect.size.width>contentVisibleRect.size.width)
	{
		completionRect.size.width += documentRect.size.width - contentVisibleRect.size.width;
	}
	// adjust the height
	if(documentRect.size.height>contentVisibleRect.size.height)
	{
		completionRect.size.height = MIN(screenVisibleFrame.size.height * 0.3,completionRect.size.height + documentRect.size.height - contentVisibleRect.size.height);
	}

	completionRect.origin.x = MIN(bottomLeft.x, NSMaxX(screenVisibleFrame) - completionRect.size.width);

	float midAnchorY = NSMidY(textRect);
	if(midAnchorY>NSMidY(screenVisibleFrame))
	{
		// draw in the lowest part of the screen
		completionRect.origin.y = bottomLeft.y - completionRect.size.height;		
	}
	else
	{
		completionRect.origin.y = topRight.y;		
	}
	[completionWindow setFrame:completionRect display:YES];
	return;
}
- (void)cancelCompletion;
{
	if(_TextView)
	{
		[_TextView insertCompletion:_OriginalString forPartialWordRange:_RangeForUserCompletion movement:NSCancelTextMovement isFinal:NO];
		_RangeForUserCompletion.length = [_OriginalString length];
		NSUndoManager * undoManager = [_TextView undoManager];
		if(_ShouldEnableUndoRegistration && [[self window] parentWindow])
		{
			[undoManager enableUndoRegistration];//NSException raised when quitting while the text completion window is still active
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
		if(_SelectedRange.length>0)
		{
			_SelectedRange.length = 0;
			[_TextView replaceCharactersInRange:_SelectedRange withString:_OriginalSelectedString];			
		}
		[_TextView autorelease];
		_TextView = nil;
	}
	[_Tab autorelease];
	_Tab = nil;
	[_OriginalString autorelease];
	_OriginalString = nil;
	[_EditedString autorelease];
	_EditedString = nil;
	[_ShortCompletionString autorelease];
	_ShortCompletionString = nil;
	[_LongCompletionString autorelease];
	_LongCompletionString = nil;
	[_ReplacementLines autorelease];
	_ReplacementLines = nil;
	[_OriginalSelectedString autorelease];
	_OriginalSelectedString = nil;
	[_LongCandidates autorelease];
	_LongCandidates = nil;
	NSWindow * W = [self window];
	[[W parentWindow] removeChildWindow:W];
	[W orderOut:self];
	[DNC removeObserver:self name:NSWindowWillCloseNotification object:nil];
	return;
}
- (void)windowWillCloseNotified:(NSNotification *)aNotification;
{
	[[[self window] parentWindow] removeChildWindow:[self window]];// this will prevent an exception in the next call
	[self cancelCompletion];
	return;
}
- (void)_concludeCompletion:(id)sender;
{
	[self concludeCompletionAndInsertSpace:NO];
	return;
}
- (void)concludeCompletionAndInsertSpace:(BOOL)yorn;
{
	[_TextView insertCompletion:_OriginalString forPartialWordRange:_RangeForUserCompletion movement:NSCancelTextMovement isFinal:NO];
	NSUndoManager * undoManager = [_TextView undoManager];
	if(_ShouldEnableUndoRegistration)
	{
		[undoManager enableUndoRegistration];
//iTM2_LOG(@"now enableUndoRegistration");
		_ShouldEnableUndoRegistration = NO;
	}
	else
	{
//iTM2_LOG(@"still disableUndoRegistration");
	}
	NSString * replacementString = _LongCompletionString;
	if([_TextView contextBoolForKey:iTM2DontUseSmartMacrosKey domain:iTM2ContextAllDomainsMask])
	{
		replacementString = _ShortCompletionString;
	}
	if(yorn)
	{
		replacementString = [replacementString stringByAppendingString:@" "];
	}
	NSRange selectedRange = [_TextView selectedRange];
	replacementString = [_TextView macroByPreparing:replacementString forInsertionInRange:selectedRange];
	[_TextView insertCompletion:replacementString forPartialWordRange:_RangeForUserCompletion movement:NSReturnTextMovement isFinal:YES];
	// always select placeholders from the start
	if(![_TextView contextBoolForKey:iTM2DontUseSmartMacrosKey domain:iTM2ContextAllDomainsMask])
	{
		[_TextView selectFirstPlaceholder:self];
	}
	[_LongCandidates autorelease];
	_LongCandidates = nil;
	[_TextView autorelease];
	_TextView = nil;
	NSWindow * W = [self window];
	[[W parentWindow] removeChildWindow:W];
	[W orderOut:self];
	[DNC removeObserver:self name:NSWindowWillCloseNotification object:nil];
//	W = [_TextView window];
//	[W makeFirstResponder:_TextView];
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
		_LongCandidates = [[_TextView completionsForPartialWordRange:range indexOfSelectedItem:&selectedRow] retain];
		unsigned numberOfRows = [_LongCandidates count];
		if(!numberOfRows)
		{
			[self cancelCompletion];
			return;
		}
		// where should I put this window
		[_TableView setDataSource:self];
		[_TableView setDelegate:self];
		[_TableView setTarget:self];// self is expecetd to last forever
		[_TableView setDoubleAction:@selector(_concludeCompletion:)];
		[_TableView setAllowsMultipleSelection:NO];
		[_TableView reloadData];
		[_TableView selectRow:selectedRow byExtendingSelection:NO];

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
		[self updateCompletion];
		[self updateCompletionWindow];
	}
	return;
}
- (int)numberOfRowsInTableView:(NSTableView *)tableView;
{
	if(!_TableView)
	{
		_TableView = tableView;
	}
	return [_LongCandidates count];
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row;
{
	id result = row>=0?[_LongCandidates objectAtIndex:row]:nil;
	return result;
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
	NSString * completion = nil;
	for(completion in completions)
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
	NSString * candidate = nil;
	NSMutableArray * result = [NSMutableArray array];
	for(candidate in ra)
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
@synthesize _TableView;
@synthesize _LongCandidates;
@synthesize _TextView;
@synthesize _Tab;
@synthesize _OriginalString;
@synthesize _EditedString;
@synthesize _ShortCompletionString;
@synthesize _LongCompletionString;
@synthesize _ReplacementLines;
@synthesize _OriginalSelectedString;
@synthesize _ShouldEnableUndoRegistration;
@synthesize _PatriciaControllers;
@synthesize _IndentationLevel;
@end

#import <iTM2Foundation/iTM2TextDocumentKit.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>

/*"Description forthcoming."*/
@implementation NSTextView(iTM2TextCompletionKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	if(![NSTextView iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2_rangeForUserCompletion)])
	{
		iTM2_LOG(@"WARNING: No hook available to init text view completion module...");
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  proposedRangeForUserCompletion:
- (NSRange)proposedRangeForUserCompletion:(NSRange)range;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return range;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2_rangeForUserCompletion
- (NSRange)SWZ_iTM2_rangeForUserCompletion;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange result = [self SWZ_iTM2_rangeForUserCompletion];
	NSString * category = [self macroCategory];
	NSString * action = [NSString stringWithFormat:@"proposedRangeFor%@UserCompletion:",category];
	SEL selector = NSSelectorFromString(action);
	NSMethodSignature * MS = [self methodSignatureForSelector:selector];
	SEL mySelector = @selector(proposedRangeForUserCompletion:);
	NSMethodSignature * myMS = [self methodSignatureForSelector:mySelector];
	if(![MS isEqual:myMS])
	{
		MS = myMS;
		selector = mySelector;
	}
	NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
	[I setTarget:self];
	[I setArgument:&result atIndex:2];
	[I setSelector:selector];
	NS_DURING
	[I invoke];
	[I getReturnValue:&result];
	NS_HANDLER
	iTM2_LOG(@"EXCEPTION Catched: %@", localException);
	NS_ENDHANDLER
//iTM2_END;
    return result;
}
@end

#import <iTM2Foundation/iTM2TextDocumentKit.h>

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
	if(![self contextBoolForKey:@"iTM2NoExtendedCompletion" domain:iTM2ContextAllDomainsMask] && [[iTM2CompletionServer completionServer] runCompletionForTextView:self] != 0)
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= completionsForPartialWordRange:indexOfSelectedItem:
- (NSArray *)completionsForPartialWordRange:(NSRange)charRange indexOfSelectedItem:(int *)indexPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 12:58:07 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// we assume that the arrays given by the various methods are ordered
	NSString * preferred1 = nil;
	NSString * preferred2 = nil;
	NSMutableArray * result1 = (id)[[iTM2CompletionServer completionServer] completionsForTextView:self partialWordRange:charRange indexOfSelectedItem:indexPtr];
	if([result1 count])
	{
		if(indexPtr && (*indexPtr < [result1 count]))
		{
			preferred1 = [result1 objectAtIndex:*indexPtr];
		}
		int index2 = 0;
		NSArray * result2 = [[iTM2CompletionServer completionServer] completionsForTextView:self partialWordRange:charRange indexOfSelectedItem:&index2];// THIS SHOULD CHANGE, IT HAS NO SENSE
		if([result2 count])
		{
			if(indexPtr && (index2 < [result2 count]))
			{
				preferred2 = [result2 objectAtIndex:index2];
			}
			result1 = [[result1 mutableCopy] autorelease];
			// now merging the two arrays
			int idx1 = [result1 count] - 1;
			int idx2 = [result2 count] - 1;//ERROR
			NSString * S1 = [result1 objectAtIndex:idx1];
			NSString * S2 = [result2 objectAtIndex:idx2];
			int compare;
grosbois:
			compare = [S1 compare:S2];
			if(compare == NSOrderedDescending)
			{
				// S2 should be inserted before S1
				if(idx1)
				{
					--idx1;
					S1 = [result1 objectAtIndex:idx1];
				}
				else
				{
					// S1 is the first object
					[result1 insertObject:S2 atIndex:idx1];
					while(idx2--)
					{
						S2 = [result2 objectAtIndex:idx2];
						[result1 insertObject:S2 atIndex:idx1];
					}
				}
			}
			else if(compare == NSOrderedAscending)
			{
				[result1 insertObject:S2 atIndex:idx1+1];
				if(idx2--)
				{
					S2 = [result2 objectAtIndex:idx2];
					goto grosbois;
				}
			}
			else if(idx2--)
			{
				S2 = [result2 objectAtIndex:idx2];
				goto grosbois;
			}
			if(indexPtr)
			{
				*indexPtr = [result1 indexOfObject:preferred1];
			}
		}
		return result1;
	}
	else
	{
		return charRange.length?[super completionsForPartialWordRange:charRange indexOfSelectedItem:indexPtr]:[NSArray array];
	}
}
#if 0
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
//iTM2_LOG(@"word:%@",word);
//iTM2_LOG(@"charRange:%@",NSStringFromRange(charRange));
//iTM2_LOG(@"movement:%@",[NSNumber numberWithInt:movement]);
//iTM2_LOG(@"flag:%@",(flag?@"Y":@"N"));
	[super insertCompletion:(NSString *)word forPartialWordRange:(NSRange)charRange movement:(int)movement isFinal:(BOOL)flag];
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
			[[self windowController] concludeCompletionAndInsertSpace:NO];
			return;
		case ' ':
			[[self windowController] concludeCompletionAndInsertSpace:YES];
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

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextCompletionKit
