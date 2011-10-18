/*
//  iTM2ConTeXtSupport.h
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
#import "iTM2ConTeXtSupport.h"

@interface iTM2ConTeXtPrefsPane()
- (id)downloadIndicator;
- (id)manualsTableView;
- (id)downloadPanel;
- (NSArray *)ConTeXtManuals;
- (void)setConTeXtManuals:(NSArray *)aConTeXtManuals;
- (NSUInteger)countOfConTeXtManuals;
- (id)objectInConTeXtManualsAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObjectInConTeXtManuals:(id) object;
- (void)insertObject:(id)anObject inConTeXtManualsAtIndex:(NSUInteger)index;
- (void)removeObjectFromConTeXtManualsAtIndex:(NSUInteger)index;
- (void)replaceObjectInConTeXtManualsAtIndex:(NSUInteger)index withObject:(id)anObject;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return @"2.TeX.ConTeXt";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  manualsTableView
- (id)manualsTableView
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setManualsTableView:
- (void)setManualsTableView:(NSTableView *)object;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(object);
	[object registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, NSFilenamesPboardType, NSStringPboardType, nil]];
	object.dataSource = self;
	object.delegate = self;
	[self synchronizeWithUserDefaults];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  downloadPanel
- (id)downloadPanel
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDownloadPanel:
- (void)setDownloadPanel:(id)object;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(object);
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setConTeXtManuals:
- (void)setConTeXtManuals:(NSArray *)argument
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(([argument isKindOfClass:[NSArray class]]? [argument mutableCopy]: (argument? [NSMutableArray array]: argument)));
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  countOfConTeXtManuals:
- (NSUInteger)countOfConTeXtManuals;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [(NSMutableArray *)self.ConTeXtManuals count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInConTeXtManualsAtIndex:
- (id)objectInConTeXtManualsAtIndex:(NSUInteger)index;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [(NSMutableArray *)self.ConTeXtManuals objectAtIndex:index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  indexOfObjectInConTeXtManuals:
- (NSUInteger)indexOfObjectInConTeXtManuals:(id) object;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSUInteger index = self.countOfConTeXtManuals;
	NSString * title = [object valueForKeyPath:@"Path"];
	while(index--)
	{
		if([[[self objectInConTeXtManualsAtIndex:index] valueForKeyPath:@"Path"] isEqual:title])
			return index;
	}
//END4iTM3;
    return NSNotFound;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertObject:inConTeXtManualsAtIndex:
- (void)insertObject:(id)anObject inConTeXtManualsAtIndex:(NSUInteger)index 
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [(NSMutableArray *)self.ConTeXtManuals insertObject:anObject atIndex:index];
	[self synchronizeUserDefaults];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeObjectFromConTeXtManualsAtIndex:
- (void)removeObjectFromConTeXtManualsAtIndex:(NSUInteger)index 
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [(NSMutableArray *)self.ConTeXtManuals removeObjectAtIndex:index];
	[self synchronizeUserDefaults];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceObjectInConTeXtManualsAtIndex:withObject:
- (void)replaceObjectInConTeXtManualsAtIndex:(NSUInteger)index withObject:(id)anObject 
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [(NSMutableArray *)self.ConTeXtManuals replaceObjectAtIndex:index withObject:anObject];
	[self synchronizeUserDefaults];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeUserDefaults
- (void)synchronizeUserDefaults; 
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * MRA = [NSMutableArray array];
	NSEnumerator * E = [self.ConTeXtManuals objectEnumerator];
	NSDictionary * D;
	while(D = E.nextObject)
	{
		id O = [D objectForKey:@"Path"];
		if(O)
			[MRA addObject:[[O copy] autorelease]];
	}
	[SUD setObject:MRA forKey:iTM2ConTeXtManuals];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWithUserDefaults
- (void)synchronizeWithUserDefaults; 
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * MRA = [NSMutableArray array];
	NSEnumerator * E = [[SUD stringArrayForKey:iTM2ConTeXtManuals] objectEnumerator];
	NSString * S;
	while(S = E.nextObject) [MRA addObject:[NSDictionary dictionaryWithObject:S forKey:@"Path"]];
	[self setConTeXtManuals:MRA];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSTableView * myTableView = self.manualsTableView;
	[myTableView deselectAll:nil];
	[self insertObject:[NSMutableDictionary dictionary] inConTeXtManualsAtIndex:ZER0];
	[myTableView reloadData];
	[myTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:ZER0] byExtendingSelection:NO];
	[myTableView editColumn:ZER0 row:ZER0 withEvent:nil select:YES];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= remove:
- (IBAction)remove:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSTableView * myTableView = self.manualsTableView;
	NSIndexSet * IS = [myTableView selectedRowIndexes];
	NSUInteger index = [IS lastIndex];
	while(index != NSNotFound)
	{
		[self removeObjectFromConTeXtManualsAtIndex:index];
		index = [IS indexLessThanIndex:index];
	}
	[myTableView reloadData];
//END4iTM3;
	return;
}
/* required methods
*/
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= numberOfRowsInTableView:
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return self.countOfConTeXtManuals;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [[[self objectInConTeXtManualsAtIndex:row] valueForKeyPath:[tableColumn identifier]] lastPathComponent];
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  :
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[self objectInConTeXtManualsAtIndex:row] setValue:object forKeyPath:[tableColumn identifier]];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id object = [self objectInConTeXtManualsAtIndex:[rowIndexes lastIndex]];
	[pboard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
	[pboard setString:[object valueForKeyPath:@"Path"] forType:NSStringPboardType];
//END4iTM3;
	return YES;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:validateDrop:proposedRow:proposedDropOperation:
- (NSDragOperation)tableView:(NSTableView *)tableView
                    validateDrop: (id <NSDraggingInfo>) info
                    proposedRow: (NSInteger) row
                    proposedDropOperation: (NSTableViewDropOperation) operation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (row > self.countOfConTeXtManuals)
		return NSDragOperationNone;

	[tableView setDropRow:row dropOperation:NSTableViewDropAbove];
	if (tableView == [info draggingSource]) // From self
    {
//END4iTM3;
		return NSDragOperationMove;
    }
	else 
    {
//END4iTM3;
		return NSDragOperationCopy;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:acceptDrop:row:dropOperation:
- (BOOL)tableView:(NSTableView *)tableView
         acceptDrop: (id <NSDraggingInfo>) info
         row: (NSInteger) row
         dropOperation: (NSTableViewDropOperation) operation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (row > self.countOfConTeXtManuals)
		return NO;

	NSPasteboard *pboard = [info draggingPasteboard];
	NSURL * myURL = [NSURL URLFromPasteboard:pboard];
	if(myURL)
	{
		// is it a local file URL?
		if(myURL.isFileURL)
		{
			id object = [NSMutableDictionary dictionaryWithObject:myURL.path forKey:@"Path"];
			NSUInteger oldIndex = [self indexOfObjectInConTeXtManuals:object];
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
			[NSApp beginSheet:self.downloadPanel modalForWindow:self.mainView.window modalDelegate:nil didEndSelector:NULL contextInfo:nil];
			[self.downloadIndicator setIndeterminate:YES];
			[self.downloadIndicator startAnimation:nil];
			[self setURLDownload:[[[NSURLDownload alloc] initWithRequest:[NSURLRequest requestWithURL:myURL] delegate:self] autorelease]];
			// [myURL loadResourceDataNotifyingClient:self usingCache:YES];
			return YES;
		}
	}
	NSArray * FNs = [pboard propertyListForType:NSFilenamesPboardType];
	if(FNs.count)
	{
		NSEnumerator * E = [FNs reverseObjectEnumerator];
		NSString * S;
		while(S = E.nextObject)
		{
			id object = [NSMutableDictionary dictionaryWithObject:S forKey:@"Path"];
			NSUInteger oldIndex = [self indexOfObjectInConTeXtManuals:object];
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
	NSUInteger oldIndex = [self indexOfObjectInConTeXtManuals:object];
	[self insertObject:object inConTeXtManualsAtIndex:row];
	if(oldIndex != NSNotFound)
	{
		[self removeObjectFromConTeXtManualsAtIndex: (oldIndex<row? oldIndex: ++oldIndex)];
	}
	[tableView reloadData];
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  download:didReceiveResponse:
- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	long long ECL = [response expectedContentLength];
	if (ECL) {
		[self.downloadIndicator setMaxValue:ECL+0.0];
		[self.downloadIndicator setIndeterminate:NO];
	} else
		[self.downloadIndicator setIndeterminate:YES];
	[self.downloadPanel isContentValid4iTM3];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  download:didReceiveDataOfLength:
- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"data received ");
	[self.downloadIndicator setDoubleValue:[self.downloadIndicator doubleValue] + length];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  downloadDidFinish:
- (void)downloadDidFinish:(NSURLDownload *)download;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.downloadIndicator stopAnimation:nil];
	[NSApp endSheet:self.downloadPanel];
	[self.downloadPanel orderOut:self];
	[self.manualsTableView reloadData];
	[self setURLDownload:nil];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  download:didFailWithError:
- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	LOG4iTM3(@"Download error: %@", error);
	[NSApp endSheet:self.downloadPanel];
	[self.downloadPanel orderOut:self];
	[self.manualsTableView reloadData];
	[self setURLDownload:nil];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  download:decideDestinationWithSuggestedFilename:
- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * dir = [[NSBundle mainBundle] URLForSupportDirectory4iTM3:@"Documentation/ConTeXt" inDomain:NSUserDomainMask create:YES];
	[download setDestination:[dir URLByAppendingPathComponent:filename.lastPathComponent].path allowOverwrite:YES];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  download:didCreateDestination:
- (void)download:(NSURLDownload *)download didCreateDestination:(NSString *)path;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id object = [NSMutableDictionary dictionaryWithObject:path forKey:@"Path"];
	NSUInteger oldIndex = [self indexOfObjectInConTeXtManuals:object];
	if (oldIndex != NSNotFound) {
		[self removeObjectFromConTeXtManualsAtIndex:oldIndex];
	}
	[self insertObject:object inConTeXtManualsAtIndex:self.countOfConTeXtManuals];
	[self.manualsTableView reloadData];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.URLDownload cancel];
	[NSApp endSheet:self.downloadPanel];
	[self.downloadPanel orderOut:self];
	[self.manualsTableView reloadData];
	[self setURLDownload:nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editDownload:
- (IBAction)editDownload:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditDownload:
- (BOOL)validateEditDownload:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[sender setStringValue:[[[self.URLDownload request] URL] description]];
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  downloadIndicator
- (id)downloadIndicator
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDownloadIndicator:
- (void)setDownloadIndicator:(id)object;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(object);
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLDownload
- (id)URLDownload
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setURLDownload:
- (void)setURLDownload:(id)object;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/27/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(object);
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtAtPragmaADE:
- (IBAction)ConTeXtAtPragmaADE:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SWS openURL:[iTM2ConTeXtInspector ConTeXtPragmaADEURL]];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[iTM2PrefsController sharedPrefsController] displayPrefsPaneWithIdentifier:@"2.TeX.ConTeXt"];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showConTeXtManualsPrefs:
- (IBAction)showConTeXtManualsPrefs:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self showConTeXtPrefs:sender];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * SOV = [super stringForObjectValue:anObject];
	NSString * LSOV = NSLocalizedStringFromTableInBundle(SOV.stringByDeletingPathExtension, iTM2ConTeXtManualsTable, self.classBundle4iTM3, "");
    return [SOV isEqual:LSOV]? SOV:[NSString stringWithFormat:@"%@ (%@)", LSOV, SOV];
}
@end

@interface iTM2ConTeXtManualsTableView: NSTableView
- (BOOL)interpretKeyStrokeBackspace:(id)sender;
@end 
@implementation iTM2ConTeXtManualsTableView
#pragma mark =-=-=-=-=-  KEY BINDINGS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handlesKeyBindings4iTM3
- (BOOL)handlesKeyBindings4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes4iTM3
- (BOOL)handlesKeyStrokes4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStrokeDelete:
- (BOOL)interpretKeyStrokeDelete:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self interpretKeyStrokeBackspace: (id) sender];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStrokeBackspace:
- (BOOL)interpretKeyStrokeBackspace:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Mar 15 09:46:26 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self.editedColumn != -1)
        return NO;
    else if (self.window.firstResponder == self) {
		NSIndexSet * IS = self.selectedRowIndexes;
		NSUInteger index = [IS lastIndex];
		while (index != NSNotFound) {
			[(iTM2ConTeXtPrefsPane *)self.dataSource removeObjectFromConTeXtManualsAtIndex:index];
			index = [IS indexLessThanIndex:index];
		}
		[self reloadData];
	//END4iTM3;
        return YES;
    }
//END4iTM3;
    return NO;
}
@end
