/*
//  iTM2ConTeXtsKit.h
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net today.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

#import "iTM2ConTeXtPrefsKit.h"
#import "iTM2ConTeXtKit.h"

@interface iTM2ConTeXtPrefsPane(PRIVATE)
- (id)downloadIndicator;
- (id)manualsTableView;
- (id)downloadPanel;
- (NSArray *)ConTeXtManuals;
- (void)setConTeXtManuals:(NSArray *)aConTeXtManuals;
- (unsigned int)countOfConTeXtManuals;
- (id)objectInConTeXtManualsAtIndex:(unsigned int)index;
- (unsigned int)indexOfObjectInConTeXtManuals:(id) object;
- (void)insertObject:(id)anObject inConTeXtManualsAtIndex:(unsigned int)index;
- (void)removeObjectFromConTeXtManualsAtIndex:(unsigned int)index;
- (void)replaceObjectInConTeXtManualsAtIndex:(unsigned int)index withObject:(id)anObject;
- (id)URLDownload;
- (void)setURLDownload:(id)object;
- (void)synchronizeUserDefaults; 
- (void)synchronizeWithUserDefaults; 
@end

@implementation iTM2ConTeXtPrefsPane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefPaneIdentifier
- (NSString *)prefPaneIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"2.TeX.ConTeXt";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  manualsTableView
- (id)manualsTableView
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setManualsTableView:
- (void)setManualsTableView:(id)object;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(object);
	[object registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, NSFilenamesPboardType, NSStringPboardType, nil]];
	[object setDataSource:self];
	[object setDelegate:self];
	[self synchronizeWithUserDefaults];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  downloadPanel
- (id)downloadPanel
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDownloadPanel:
- (void)setDownloadPanel:(id)object;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(object);
//iTM2_END;
    return;
}
#pragma mark -
#pragma mark =-=-=-=-=-  DATA MODEL
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtManuals
- (NSArray *)ConTeXtManuals
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setConTeXtManuals:
- (void)setConTeXtManuals:(NSArray *)argument
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(([argument isKindOfClass:[NSArray class]]? [argument mutableCopy]: (argument? [NSMutableArray array]: argument)));
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  countOfConTeXtManuals:
- (unsigned int)countOfConTeXtManuals;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [(NSMutableArray *)[self ConTeXtManuals] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInConTeXtManualsAtIndex:
- (id)objectInConTeXtManualsAtIndex:(unsigned int)index;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [(NSMutableArray *)[self ConTeXtManuals] objectAtIndex:index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  indexOfObjectInConTeXtManuals:
- (unsigned int)indexOfObjectInConTeXtManuals:(id) object;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned int index = [self countOfConTeXtManuals];
	NSString * title = [object valueForKeyPath:@"Path"];
	while(index--)
	{
		if([[[self objectInConTeXtManualsAtIndex:index] valueForKeyPath:@"Path"] isEqual:title])
			return index;
	}
//iTM2_END;
    return NSNotFound;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertObject:inConTeXtManualsAtIndex:
- (void)insertObject:(id)anObject inConTeXtManualsAtIndex:(unsigned int)index 
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [(NSMutableArray *)[self ConTeXtManuals] insertObject:anObject atIndex:index];
	[self synchronizeUserDefaults];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeObjectFromConTeXtManualsAtIndex:
- (void)removeObjectFromConTeXtManualsAtIndex:(unsigned int)index 
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [(NSMutableArray *)[self ConTeXtManuals] removeObjectAtIndex:index];
	[self synchronizeUserDefaults];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceObjectInConTeXtManualsAtIndex:withObject:
- (void)replaceObjectInConTeXtManualsAtIndex:(unsigned int)index withObject:(id)anObject 
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [(NSMutableArray *)[self ConTeXtManuals] replaceObjectAtIndex:index withObject:anObject];
	[self synchronizeUserDefaults];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeUserDefaults
- (void)synchronizeUserDefaults; 
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * MRA = [NSMutableArray array];
	NSEnumerator * E = [[self ConTeXtManuals] objectEnumerator];
	NSDictionary * D;
	while(D = [E nextObject])
	{
		id O = [D objectForKey:@"Path"];
		if(O)
			[MRA addObject:[[O copy] autorelease]];
	}
	[SUD setObject:MRA forKey:iTM2ConTeXtManuals];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWithUserDefaults
- (void)synchronizeWithUserDefaults; 
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * MRA = [NSMutableArray array];
	NSEnumerator * E = [[SUD stringArrayForKey:iTM2ConTeXtManuals] objectEnumerator];
	NSString * S;
	while(S = [E nextObject]) [MRA addObject:[NSDictionary dictionaryWithObject:S forKey:@"Path"]];
	[self setConTeXtManuals:MRA];
//iTM2_END;
	return;
}
#pragma mark -
#pragma mark =-=-=-=-=-  DATASOURCE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= add:
- (IBAction)add:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSTableView * myTableView = [self manualsTableView];
	[myTableView deselectAll:nil];
	[self insertObject:[NSMutableDictionary dictionary] inConTeXtManualsAtIndex:0];
	[myTableView reloadData];
	[myTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
	[myTableView editColumn:0 row:0 withEvent:nil select:YES];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= remove:
- (IBAction)remove:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSTableView * myTableView = [self manualsTableView];
	NSIndexSet * IS = [myTableView selectedRowIndexes];
	unsigned int index = [IS lastIndex];
	while(index != NSNotFound)
	{
		[self removeObjectFromConTeXtManualsAtIndex:index];
		index = [IS indexLessThanIndex:index];
	}
	[myTableView reloadData];
//iTM2_END;
	return;
}
/* required methods
*/
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= numberOfRowsInTableView:
- (int)numberOfRowsInTableView:(NSTableView *)tableView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self countOfConTeXtManuals];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[[self objectInConTeXtManualsAtIndex:row] valueForKeyPath:[tableColumn identifier]] lastPathComponent];
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  :
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self objectInConTeXtManualsAtIndex:row] setValue:object forKeyPath:[tableColumn identifier]];
//iTM2_END;
	return;
}
#endif
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_4
#pragma mark -
#pragma mark =-=-=-=-=-  DRAG & DROP
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:writeRowsWithIndexes:toPasteboard:
- (BOOL)tableView:(NSTableView *)view
         writeRowsWithIndexes:(NSIndexSet *)rowIndexes
         toPasteboard: (NSPasteboard *) pboard;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id object = [self objectInConTeXtManualsAtIndex:[rowIndexes lastIndex]];
	[pboard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
	[pboard setString:[object valueForKeyPath:@"Path"] forType:NSStringPboardType];
//iTM2_END;
	return YES;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:validateDrop:proposedRow:proposedDropOperation:
- (NSDragOperation)tableView:(NSTableView *)tableView
                    validateDrop: (id <NSDraggingInfo>) info
                    proposedRow: (int) row
                    proposedDropOperation: (NSTableViewDropOperation) operation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if (row > [self countOfConTeXtManuals])
		return NSDragOperationNone;

	[tableView setDropRow:row dropOperation:NSTableViewDropAbove];
	if (tableView == [info draggingSource]) // From self
    {
//iTM2_END;
		return NSDragOperationMove;
    }
	else 
    {
//iTM2_END;
		return NSDragOperationCopy;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:acceptDrop:row:dropOperation:
- (BOOL)tableView:(NSTableView *)tableView
         acceptDrop: (id <NSDraggingInfo>) info
         row: (int) row
         dropOperation: (NSTableViewDropOperation) operation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if (row > [self countOfConTeXtManuals])
		return NO;

	NSPasteboard *pboard = [info draggingPasteboard];
	NSURL * myURL = [NSURL URLFromPasteboard:pboard];
	if(myURL)
	{
		// is it a local file URL?
		if([myURL isFileURL])
		{
			id object = [NSMutableDictionary dictionaryWithObject:[myURL path] forKey:@"Path"];
			unsigned int oldIndex = [self indexOfObjectInConTeXtManuals:object];
			[self insertObject:object inConTeXtManualsAtIndex:row];
			if(oldIndex != NSNotFound)
			{
				[self removeObjectFromConTeXtManualsAtIndex: (oldIndex<row? oldIndex: ++oldIndex)];
			}
			[tableView reloadData];
			return YES;
		}
		else
		{
			[NSApp beginSheet:[self downloadPanel] modalForWindow:[[self mainView] window] modalDelegate:nil didEndSelector:NULL contextInfo:nil];
			[[self downloadIndicator] setIndeterminate:YES];
			[[self downloadIndicator] startAnimation:nil];
			[self setURLDownload:[[[NSURLDownload allocWithZone:[self zone]] initWithRequest:[NSURLRequest requestWithURL:myURL] delegate:self] autorelease]];
			// [myURL loadResourceDataNotifyingClient:self usingCache:YES];
			return YES;
		}
	}
	NSArray * FNs = [pboard propertyListForType:NSFilenamesPboardType];
	if([FNs count])
	{
		NSEnumerator * E = [FNs reverseObjectEnumerator];
		NSString * S;
		while(S = [E nextObject])
		{
			id object = [NSMutableDictionary dictionaryWithObject:S forKey:@"Path"];
			unsigned int oldIndex = [self indexOfObjectInConTeXtManuals:object];
			[self insertObject:object inConTeXtManualsAtIndex:row];
			if(oldIndex != NSNotFound)
			{
				[self removeObjectFromConTeXtManualsAtIndex: (oldIndex<row? oldIndex: ++oldIndex)];
			}
		}
		[tableView reloadData];
		return YES;
	}
	
	id object = [NSMutableDictionary dictionaryWithObject:[pboard stringForType:NSStringPboardType] forKey:@"Path"];
	unsigned int oldIndex = [self indexOfObjectInConTeXtManuals:object];
	[self insertObject:object inConTeXtManualsAtIndex:row];
	if(oldIndex != NSNotFound)
	{
		[self removeObjectFromConTeXtManualsAtIndex: (oldIndex<row? oldIndex: ++oldIndex)];
	}
	[tableView reloadData];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  download:didReceiveResponse:
- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int ECL = [response expectedContentLength];
	if(ECL)
	{
		[[self downloadIndicator] setMaxValue:ECL+0.0];
		[[self downloadIndicator] setIndeterminate:NO];
	}
	else
		[[self downloadIndicator] setIndeterminate:YES];
	[[self downloadPanel] validateContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  download:didReceiveDataOfLength:
- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(unsigned)length;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"data received ");
	[[self downloadIndicator] setDoubleValue:[[self downloadIndicator] doubleValue] + length];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  downloadDidFinish:
- (void)downloadDidFinish:(NSURLDownload *)download;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self downloadIndicator] stopAnimation:nil];
	[NSApp endSheet:[self downloadPanel]];
	[[self downloadPanel] orderOut:self];
	[[self manualsTableView] reloadData];
	[self setURLDownload:nil];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  download:didFailWithError:
- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2_LOG(@"Download error: %@", error);
	[NSApp endSheet:[self downloadPanel]];
	[[self downloadPanel] orderOut:self];
	[[self manualsTableView] reloadData];
	[self setURLDownload:nil];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  download:decideDestinationWithSuggestedFilename:
- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * dir = [[NSBundle mainBundle] pathForSupportDirectory:@"Documentation/ConTeXt" inDomain:NSUserDomainMask create:YES];
	[download setDestination:[dir stringByAppendingPathComponent:[filename lastPathComponent]] allowOverwrite:YES];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  download:didCreateDestination:
- (void)download:(NSURLDownload *)download didCreateDestination:(NSString *)path;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id object = [NSMutableDictionary dictionaryWithObject:path forKey:@"Path"];
	unsigned int oldIndex = [self indexOfObjectInConTeXtManuals:object];
	if(oldIndex != NSNotFound)
	{
		[self removeObjectFromConTeXtManualsAtIndex:oldIndex];
	}
	[self insertObject:object inConTeXtManualsAtIndex:[self countOfConTeXtManuals]];
	[[self manualsTableView] reloadData];
//iTM2_END;
	return;
}
//- (void)download:(NSURLDownload *)download didCreateDestination:(NSString *)path;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancelDownload:
- (IBAction)cancelDownload:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self URLDownload] cancel];
	[NSApp endSheet:[self downloadPanel]];
	[[self downloadPanel] orderOut:self];
	[[self manualsTableView] reloadData];
	[self setURLDownload:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editDownload:
- (IBAction)editDownload:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditDownload:
- (BOOL)validateEditDownload:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setStringValue:[[[[self URLDownload] request] URL] description]];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  downloadIndicator
- (id)downloadIndicator
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDownloadIndicator:
- (void)setDownloadIndicator:(id)object;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(object);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLDownload
- (id)URLDownload
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setURLDownload:
- (void)setURLDownload:(id)object;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(object);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtAtPragmaADE:
- (IBAction)ConTeXtAtPragmaADE:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SWS openURL:[iTM2ConTeXtInspector ConTeXtPragmaADEURL]];
//iTM2_END;
	return;
}
@end

@implementation NSApplication(iTM2ConTeXtPrefsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showConTeXtPrefs:
- (IBAction)showConTeXtPrefs:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[iTM2PrefsController sharedPrefsController] displayPrefsPaneWithIdentifier:@"2.TeX.ConTeXt"];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showConTeXtManualsPrefs:
- (IBAction)showConTeXtManualsPrefs:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self showConTeXtPrefs:sender];
//iTM2_END;
	return;
}
@end

@implementation iTM2ConTeXtManualsFormatter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringForObjectValue:
- (NSString *)stringForObjectValue:(id)anObject;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * SOV = [super stringForObjectValue:anObject];
	NSString * LSOV = NSLocalizedStringFromTableInBundle([SOV stringByDeletingPathExtension], iTM2ConTeXtManualsTable, [self classBundle], "");
    return [SOV isEqual:LSOV]? SOV:[NSString stringWithFormat:@"%@ (%@)", LSOV, SOV];
}
@end

@interface iTM2ConTeXtManualsTableView: NSTableView
- (BOOL)interpretKeyStrokeBackspace:(id)sender;
@end 
@implementation iTM2ConTeXtManualsTableView
#pragma mark =-=-=-=-=-  KEY BINDINGS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handlesKeyBindings
- (BOOL)handlesKeyBindings;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes
- (BOOL)handlesKeyStrokes;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStrokeDelete:
- (BOOL)interpretKeyStrokeDelete:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self interpretKeyStrokeBackspace: (id) sender];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStrokeBackspace:
- (BOOL)interpretKeyStrokeBackspace:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self editedColumn] != -1)
        return NO;
    else if([[self window] firstResponder] == self)
    {
		NSIndexSet * IS = [self selectedRowIndexes];
		unsigned int index = [IS lastIndex];
		while(index != NSNotFound)
		{
			[[self dataSource] removeObjectFromConTeXtManualsAtIndex:index];
			index = [IS indexLessThanIndex:index];
		}
		[self reloadData];
	//iTM2_END;
        return YES;
    }
//iTM2_END;
    return NO;
}
@end
