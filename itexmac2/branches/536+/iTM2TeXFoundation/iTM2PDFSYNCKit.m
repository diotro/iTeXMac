 /*
//
//  @version Subversion:$Id:iTM2PDFSYNCKit.m 319 2006-12-09 22:02:14Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Jun 27 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum:Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

#define __iTM2TeXFoundation_PDFSYNC__ 1

#ifdef __iTM2TeXFoundation_NO_PDFSYNC__
#warning NO PDFSYNC FOR DEBUGGING PURPOSE
#else
#import "iTM2PDFSYNCKit.h"

NSString * const iTM2PDFSyncParsedNotificationName = @"iTM2:PDF-SyncParsedNotification";
NSString * const iTM2PDFNoSynchronizationKey = @"iTM2:PDF-NOSynchronization";
NSString * const iTM2PDFSyncPriorityKey = @"iTM2:PDF-SyncPriority";
NSString * const iTM2PDFSyncFollowFocusKey = @"iTM2:PDF-FollowFocus";
NSString * const iTM2PDFSyncOffsetKey = @"iTM2:PDF-SyncOffset";
NSString * const iTM2PDFSyncShowRecordNumberKey = @"iTM2:PDF-SyncShowRecordNumber";
NSString * const iTM2PDFSYNCDidToggleNotification = @"iTM2PDFSYNCDidToggle";
NSString * const iTM2PDFSYNCDisplayBulletsKey = @"iTM2PDFSYNCDisplayBullet";

NSString * const iTM2PDFSYNCTimeKey = @"iTM2PDFSYNCTime";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFSynchronizer

@interface iTM2PDFSynchronizer(PRIVATE)
- (BOOL)getLocation:(NSPoint *)thePointPtr page:(unsigned int *)thePagePtr forRecordIndex:(unsigned int)index;
- (void)getRecordIndexes:(NSArray **)hereIndexes beforeIndexes:(NSArray **)beforeIndexes afterIndexes:(NSArray **)afterIndexes forLine:(unsigned int)line column:(unsigned int)column inSource:(NSString *)source;
- (BOOL)getLine:(unsigned int *)linePtr column:(unsigned int *)columnPtr source:(NSString **)sourcePtr forRecordIndex:(unsigned int)index;
- (int)recordIndexForLocation:(NSPoint)point inPageAtIndex:(unsigned int)pageIndex;
- (void)doDealloc:(id)sender;
@end

typedef enum
{
    sleepingState = 0,// no thread
    updatingState = 1,// maybe a thread is already running
    parsingState = 2,// a thread is certainly running
    releaseState = -1// all should end
} iTM2PDFSynchronizerState;

@implementation iTM2PDFSynchronizer
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super initialize];
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
			NSStringFromPoint(NSMakePoint(0, 0)), iTM2PDFSyncOffsetKey,
				nil]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scanner
- (synctex_scanner_t)scanner;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NULL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isSyncTeX
- (BOOL)isSyncTeX;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_Files release];
    _Files = nil;
    [_FileName release];
    _FileName = nil;
    [_PageSyncLocations release];
    _PageSyncLocations = nil;
    [_Lines release];
    _Lines = nil;
    [super dealloc];
//NSLog(@"[SDC documents]:%@", [SDC documents]);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lock
- (void)lock;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _IsLocked = YES;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  unlock
- (void)unlock;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _IsLocked = NO;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  parsePdfsync:
- (void)parsePdfsync:(NSString *)pdfsyncPath;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSLock * L = [[[NSLock alloc] init] autorelease];
    [L lock];
    if(_Semaphore == sleepingState)
    {
        _Semaphore = updatingState;
        [_FileName release];
        _FileName = [pdfsyncPath copy]?:@"";
        [NSThread detachNewThreadSelector:@selector(_ThreadedParsePdfsync:) toTarget:self withObject:nil];
    }
    else if(_IsLocked)
    {
        [_FileName release];
        _FileName = [pdfsyncPath copy]?:@"";
        _Semaphore = updatingState;
    }
    [L unlock];
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _ThreadedParsePdfsync:
- (void)_ThreadedParsePdfsync:(id)irrelevant;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    NSLock * L = [[NSLock allocWithZone:[self zone]] init];
    NSString * s = nil;
    NSAutoreleasePool * pool = nil;
    
    updatingStateAnchor:
    
    [L lock];
    [_Files release];
    _Files = nil;
    [_PageSyncLocations release];
    _PageSyncLocations = nil;
    [_Lines release];
    _Lines = nil;
    _Semaphore = parsingState;
    [L unlock];
    
    [pool release];
    pool = [[NSAutoreleasePool allocWithZone:[self zone]] init];
//iTM2_START;
//NSLog(@"pdfsync ing");
    s = [NSString stringWithContentsOfFile:_FileName];
    if(![s length])
        goto kauehi;    
    NSPoint offset = NSPointFromString([SUD stringForKey:iTM2PDFSyncOffsetKey]);

    NSPoint firstPoint = NSZeroPoint;
    
    iTM2LiteScanner * S = [iTM2LiteScanner scannerWithString:s];
    
    NSString * directoryPath = [_FileName stringByDeletingLastPathComponent];

    NSString * file;
    if(![S scanUpToEOLIntoString:&file] || (!_IsLocked))
        goto kauehi;
    if(![DFM fileExistsAtPath:[directoryPath stringByAppendingPathComponent:file]])
    {
        file = [file stringByAppendingPathExtension:@"tex"];
    }
    file = [directoryPath stringByAppendingPathComponent:file];
    NSMutableArray * files = [NSMutableArray array];
    NSMutableArray * fileStack = [NSMutableArray array];
    [files addObject:file];
    [fileStack addObject:file];

    int version;
    if(![S scanString:@"version" intoString:nil] || ![S scanInt:&version])
    {
        goto kauehi;
    }
    // no test on the version number parsed...

    NSMutableArray * pages = [NSMutableArray array];
    
    // lines contains pairs of objects
    // the first one is the NSNumber of the current file
    // the next one is for the lines information
    // the lines information is just an array
    // each time a page is shipped out, a new array is created.
    // the objects of that array are just iTM2SynchronizationLineRecord encapsulated in values
    NSMutableArray * lines = [NSMutableArray array];
    [lines addObject:[NSNumber numberWithInt:0]];
    [lines addObject:[NSMutableDictionary dictionary]];
    int folio = 0;// the \@@folio?
    
    unsigned recordIndex;
    iTM2SynchronizationLineRecord lineRecord;
    lineRecord.column = -1;
    iTM2SynchronizationLocationRecord locationRecord;

    parsingStateAnchor:
    if([S scanString:@"l" intoString:nil])
    {
        if([S scanInt:&recordIndex] && [S scanInt:&lineRecord.line])
        {
            [[lines lastObject]
                setObject:[NSValue value:&lineRecord withObjCType:@encode(iTM2SynchronizationLineRecord)]
                    forKey:[NSNumber numberWithUnsignedInt:recordIndex]];
        }
//NSLog(@"line:%i ([lines count] = %i & [[lines lastObject] count] = %i )", line, [lines count], [[lines lastObject] count]);
    }
    else if([S scanString:@"p" intoString:nil])
    {
        locationRecord.star = [S scanString:@"*" intoString:nil];
        // here we are expected to read something like
        // #1 #2 #3
        // where #1 is the order of the record
        // #2 is the x position
        // #3 is the y position
        if([S scanInt:&recordIndex] && [S scanFloat:&locationRecord.x] && [S scanFloat:&locationRecord.y])
        {
            // ignore the first point because there are many garbage informations
            if((firstPoint.x != locationRecord.x) || (firstPoint.y != locationRecord.y))
            {
                if(!recordIndex)
                {
                    firstPoint.x = locationRecord.x;
                    firstPoint.y = locationRecord.y;
//NSLog(@"The first point is:%@", NSStringFromPoint(firstPoint));
                }
                locationRecord.x/=65536;
                locationRecord.y/=65536;
                locationRecord.x+=offset.x;
                locationRecord.y+=offset.y;
                [[pages lastObject]
                    setObject:[NSValue value:&locationRecord withObjCType:@encode(iTM2SynchronizationLocationRecord)]
                        forKey:[NSNumber numberWithUnsignedInt:recordIndex]];
            }
//else NSLog(@"Ignored:%u, %f, %f", recordIndex, locationRecord.x, locationRecord.y);
            // I guess there is only pages for a little while... I do not take advantage of this to have a more rapid parser
//NSLog(@"page:%i, point:(%f, %f)", page, P.x, P.y);
        }
    }
    else if([S scanString:@"s" intoString:nil] && [S scanInt:&folio])
    {
        // some page is being shipped out
        [pages addObject:[NSMutableDictionary dictionary]];
    }
    else if([S scanString:@"(" intoString:nil])
    {
        if(![S scanUpToEOLIntoString:&file])
            goto kauehi;
        if(![DFM fileExistsAtPath:[directoryPath stringByAppendingPathComponent:file]])
        {
            file = [file stringByAppendingPathExtension:@"tex"];
        }
        file = [directoryPath stringByAppendingPathComponent:file];
        [fileStack addObject:file];
        if(![files containsObject:file])
            [files addObject:file];
        [lines addObject:[NSNumber numberWithInt:[files indexOfObject:file]]];
        [lines addObject:[NSMutableDictionary dictionary]];
//NSLog(@"down to:%@", [fileStack lastObject]);
    }
    else if([S scanString:@")" intoString:nil])
    {
        [fileStack removeLastObject];
        [lines addObject:[NSNumber numberWithInt:[files indexOfObject:[fileStack lastObject]]]];
        [lines addObject:[NSMutableDictionary dictionary]];
//NSLog(@"up to :%@", [fileStack lastObject]);
    }
    if([S isAtEnd])
    {
        [L lock];
        [_Files autorelease];
        [_PageSyncLocations autorelease];
        [_Lines autorelease];
        _Files = [files copy];
        _PageSyncLocations = [pages mutableCopy];
        _Lines = [lines copy];
        [L unlock];
        [self performSelectorOnMainThread:@selector(pdfsyncDidParse:) withObject:nil waitUntilDone:NO]; 
        // cleaning the lines and the pages:we only keep line infos for which there exists a synchronization point.
        [NSThread setThreadPriority:[self contextFloatForKey:iTM2PDFSyncPriorityKey domain:iTM2ContextAllDomainsMask]];
#if 1
        NSEnumerator * E = [pages objectEnumerator];
        id O;
        NSMutableArray * allRecordIndices = [NSMutableArray array];
        while(O = [E nextObject])
            [allRecordIndices addObjectsFromArray:[O allKeys]];
        E = [lines objectEnumerator];
        unsigned saved = 0;
        unsigned total = 0;
        while([E nextObject] && (O = [E nextObject]))
        {
            NSEnumerator * e = [[O allKeys] objectEnumerator];
            id K;
            while(K = [e nextObject])
            {
                ++total;
                if(![allRecordIndices containsObject:K])
                {
//NSLog(@"removing line record index:%@", K);
                    [O removeObjectForKey:K];
                    ++saved;
                }
                if(!_IsLocked)
                {
//NSLog(@"pdfsync stopped");
                    goto kauehi;
                }
            }
        }
//NSLog(@"pdfsync saved %u/%u", saved, total);
        [L lock];
        [_Files autorelease];
        [_PageSyncLocations autorelease];
        [_Lines autorelease];
        _Files = [files copy];
        _PageSyncLocations = [pages mutableCopy];
        _Lines = [lines copy];
        [L unlock];
#endif
//NSLog(@"The end");
    }
    else if(_Semaphore == updatingState)
        goto updatingStateAnchor;
    else if(_Semaphore == parsingState)
        goto parsingStateAnchor;

    kauehi:
    [L lock];
    _Semaphore = sleepingState;
    [L unlock];
    [L release];
//NSLog(@"pdfsync complete");
    [pool release];
    return;
}
#else
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _ThreadedParsePdfsync:
- (void)_ThreadedParsePdfsync:(id)irrelevant;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    NSLock * L = [[NSLock allocWithZone:[self zone]] init];
    NSString * s = nil;
    updatingStateAnchor:
    
    [L lock];
    [_Files release];
    _Files = nil;
    [_PageSyncLocations release];
    _PageSyncLocations = nil;
    [_Lines release];
    _Lines = nil;
    _Semaphore = parsingState;
    [L unlock];
    
    iTM2_INIT_POOL;
//iTM2_START;
//NSLog(@"pdfsync ing");
    s = [NSString stringWithContentsOfFile:_FileName];
    if(![s length])
        goto kauehi;    
    NSPoint offset = NSPointFromString([SUD stringForKey:iTM2PDFSyncOffsetKey]);

//iTM2_LOG(@"offset is:%@", NSStringFromPoint(offset));
    NSPoint firstPoint = NSZeroPoint;
    
    iTM2LiteScanner * S = [iTM2LiteScanner scannerWithString:s];
    
    NSString * directoryPath = [_FileName stringByDeletingLastPathComponent];

    NSString * file;
    if(![S scanUpToEOLIntoString:&file] || (!_IsLocked))
        goto kauehi;
    if(![DFM fileExistsAtPath:[directoryPath stringByAppendingPathComponent:file]])
    {
        file = [file stringByAppendingPathExtension:@"tex"];
    }
    file = [directoryPath stringByAppendingPathComponent:file];
    NSMutableArray * files = [NSMutableArray array];
    NSMutableArray * fileStack = [NSMutableArray array];
    [files addObject:file];
    [fileStack addObject:file];

    int version;
    if(![S scanString:@"version" intoString:nil] || ![S scanInt:&version])
    {
        goto kauehi;
    }
    // no test on the version number parsed...

    NSMutableArray * pages = [NSMutableArray array];
    
    // lines contains pairs of objects
    // the first one is the NSNumber of the current file
    // the next one is for the lines information
    // the lines information is just an array
    // each time a page is shipped out, a new array is created.
    // the objects of that array are just iTM2SynchronizationLineRecord encapsulated in values
    NSMutableArray * lines = [NSMutableArray array];
    [lines addObject:[NSNumber numberWithInt:0]];
    [lines addObject:[NSMutableDictionary dictionary]];
    int folio = 0;// the \@@folio?
    
    int recordIndex;
    iTM2SynchronizationLineRecord lineRecord;
    lineRecord.column = -1;
    iTM2SynchronizationLocationRecord locationRecord;

    parsingStateAnchor:
    if([S scanString:@"l" intoString:nil])
    {
        if([S scanInt:&recordIndex] && [S scanInt:&lineRecord.line])
        {
            [[lines lastObject]
                setObject:[NSValue value:&lineRecord withObjCType:@encode(iTM2SynchronizationLineRecord)]
                    forKey:[NSNumber numberWithUnsignedInt:recordIndex]];
        }
//NSLog(@"line:%i ([lines count] = %i & [[lines lastObject] count] = %i )", line, [lines count], [[lines lastObject] count]);
    }
    else if([S scanString:@"p" intoString:nil])
    {
        locationRecord.star = [S scanString:@"*" intoString:nil];
        locationRecord.plus = [S scanString:@"+" intoString:nil];
        // here we are expected to read something like
        // #1 #2 #3
        // where #1 is the order of the record
        // #2 is the x position
        // #3 is the y position
        if([S scanInt:&recordIndex] && [S scanFloat:&locationRecord.x] && [S scanFloat:&locationRecord.y])
        {
            // ignore the first point because there are many garbage informations
            if((firstPoint.x != locationRecord.x) || (firstPoint.y != locationRecord.y))
            {
                if(!recordIndex)
                {
                    firstPoint.x = locationRecord.x;
                    firstPoint.y = locationRecord.y;
//NSLog(@"The first point is:%@", NSStringFromPoint(firstPoint));
                }
                locationRecord.x/=65781.76;//65781.76;
                locationRecord.y/=65781.76;//65781.76;
                locationRecord.x+=offset.x;
                locationRecord.y+=offset.y;
                [[pages lastObject]
                    setObject:[NSValue value:&locationRecord withObjCType:@encode(iTM2SynchronizationLocationRecord)]
                        forKey:[NSNumber numberWithUnsignedInt:recordIndex]];
            }
//else NSLog(@"Ignored:%u, %f, %f", recordIndex, locationRecord.x, locationRecord.y);
            // I guess there is only pages for a little while... I do not take advantage of this to have a more rapid parser
//NSLog(@"page:%i, point:(%f, %f)", page, P.x, P.y);
        }
    }
    else if([S scanString:@"s" intoString:nil] && [S scanInt:&folio])
    {
        // some page is being shipped out
        [pages addObject:[NSMutableDictionary dictionary]];
    }
    else if([S scanString:@"(" intoString:nil])
    {
        if(![S scanUpToEOLIntoString:&file])
            goto kauehi;
        if(![DFM fileExistsAtPath:[directoryPath stringByAppendingPathComponent:file]])
        {
            file = [file stringByAppendingPathExtension:@"tex"];
        }
        file = [directoryPath stringByAppendingPathComponent:file];
        [fileStack addObject:file];
        if(![files containsObject:file])
            [files addObject:file];
        [lines addObject:[NSNumber numberWithInt:[files indexOfObject:file]]];
        [lines addObject:[NSMutableDictionary dictionary]];
//NSLog(@"down to:%@", [fileStack lastObject]);
    }
    else if([S scanString:@")" intoString:nil])
    {
        [fileStack removeLastObject];
        [lines addObject:[NSNumber numberWithInt:[files indexOfObject:[fileStack lastObject]]]];
        [lines addObject:[NSMutableDictionary dictionary]];
//NSLog(@"up to :%@", [fileStack lastObject]);
    }
    if([S isAtEnd])
    {
        [L lock];
        [_Files autorelease];
        [_PageSyncLocations autorelease];
        [_Lines autorelease];
        _Files = [files copy];
        _PageSyncLocations = [pages mutableCopy];
        _Lines = [lines copy];
        [L unlock];
        [self performSelectorOnMainThread:@selector(pdfsyncDidParse:) withObject:nil waitUntilDone:NO]; 
        // cleaning the lines and the pages:we only keep line infos for which there exists a synchronization point.
        [NSThread setThreadPriority:[self contextFloatForKey:iTM2PDFSyncPriorityKey domain:iTM2ContextAllDomainsMask]];
#if 1
        NSEnumerator * E = [pages objectEnumerator];
        id O;
        NSMutableArray * allRecordIndices = [NSMutableArray array];
        while(O = [E nextObject])
            [allRecordIndices addObjectsFromArray:[O allKeys]];// EXC_BAD_ACCESS Here?
        E = [lines objectEnumerator];
        unsigned saved = 0;
        unsigned total = 0;
        while([E nextObject] && (O = [E nextObject]))
        {
            NSEnumerator * e = [[O allKeys] objectEnumerator];
            id K;
            while(K = [e nextObject])
            {
                ++total;
                if(![allRecordIndices containsObject:K])
                {
//NSLog(@"removing line record index:%@", K);
                    [O removeObjectForKey:K];
                    ++saved;
                }
                if(!_IsLocked)
                {
//NSLog(@"pdfsync stopped");
                    goto kauehi;
                }
            }
        }
//NSLog(@"pdfsync saved %u/%u", saved, total);
        [L lock];
        [_Files autorelease];
        [_PageSyncLocations autorelease];
        [_Lines autorelease];
        _Files = [files copy];
        _PageSyncLocations = [pages mutableCopy];
        _Lines = [lines copy];
        [L unlock];
#endif
//NSLog(@"The end");
    }
    else if(_Semaphore == updatingState)
        goto updatingStateAnchor;
    else if(_Semaphore == parsingState)
        goto parsingStateAnchor;

    kauehi:
    [L lock];
    _Semaphore = sleepingState;
    [L unlock];
    [L release];
//iTM2_END;
	iTM2_RELEASE_POOL;
	[NSThread exit];
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pdfsyncDidParse:
- (void)pdfsyncDidParse:(id)irrelevant;
/*"Description Forthcoming. This is meant to live in the main thread...
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [INC postNotificationName:iTM2PDFSyncParsedNotificationName object:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getLine:column:length:source:forLocation:withHint:inPageAtIndex:
- (BOOL)getLine:(unsigned int *)linePtr column:(unsigned int *)columnPtr length:(unsigned int *)lengthPtr source:(NSString **)sourcePtr forLocation:(NSPoint)point withHint:(NSDictionary *)hint inPageAtIndex:(unsigned int)pageIndex;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if((pageIndex<0) || (pageIndex>=[_PageSyncLocations count]))
        return NO;

    NSValue * V = nil;
	if(V = [hint objectForKey:@"line bounds"])
	{
		NSRect lineBounds = NSInsetRect([V rectValue], -1, -1);
		NSDictionary * D = [_PageSyncLocations objectAtIndex:pageIndex];
		NSEnumerator * E = [D keyEnumerator];
		NSNumber * N;
		NSMutableArray * left = [NSMutableArray array];// records are on the left of the column
		NSMutableDictionary * above = [NSMutableDictionary dictionary];// records are above the line bounds
		NSMutableDictionary * below = [NSMutableDictionary dictionary];// records are below the line bounds
		NSMutableArray * right = [NSMutableArray array];// records are on the right of the column
		while(N = [E nextObject])
		{
			V = [D objectForKey:N];
			iTM2SynchronizationLocationRecord locationRecord;
			[V getValue:&locationRecord];
			if(locationRecord.x < NSMinX(lineBounds))
				[left addObject:N];
			else if(locationRecord.x > NSMaxX(lineBounds))
				[right addObject:N];
			else if(locationRecord.y < NSMinY(lineBounds))
			{
				NSNumber * n = [NSNumber numberWithFloat:NSMinY(lineBounds) - locationRecord.y];
				NSMutableArray * mra = [below objectForKey:n];
				if(!mra)
				{
					mra = [NSMutableArray array];
					[below setObject:mra forKey:n];
				}
				[mra addObject:N];
			}
			else if([above count] || ![below count])// necessary to eliminate some exotic sync points
			{
				NSNumber * n = [NSNumber numberWithFloat:locationRecord.y - NSMinY(lineBounds)];
				NSMutableArray * mra = [above objectForKey:n];
				if(!mra)
				{
					mra = [NSMutableArray array];
					[above setObject:mra forKey:n];
				}
				[mra addObject:N];
			}
		}
//NSLog(@"The record index for location:%@ in page :%u is %i", NSStringFromPoint(point), page, result);
//NSLog(@"record index:%u (%@)", (resultObject? [[[D allKeysForObject:resultObject] lastObject] unsignedIntValue]:NSNotFound), resultObject);
		if([above count])
		{
			NSNumber * weightNumber = [[[above allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:0];
			NSNumber * recordNumber = [[above objectForKey:weightNumber] objectAtIndex:0];
			return [self getLine:linePtr column:columnPtr source:sourcePtr
							forRecordIndex:[recordNumber unsignedIntValue]];
		}
		else if([below count])
		{
			NSNumber * weightNumber = [[[below allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:0];
			NSNumber * recordNumber = [[below objectForKey:weightNumber] objectAtIndex:0];
			return [self getLine:linePtr column:columnPtr source:sourcePtr
							forRecordIndex:[recordNumber unsignedIntValue]];
		}
		else if([left count])
		{
			NSNumber * recordNumber = [left lastObject];
			return [self getLine:linePtr column:columnPtr source:sourcePtr
							forRecordIndex:[recordNumber unsignedIntValue]];
		}
		else if([right count])
		{
			NSNumber * recordNumber = [right objectAtIndex:0];
			return [self getLine:linePtr column:columnPtr source:sourcePtr
							forRecordIndex:[recordNumber unsignedIntValue]];
		}
	}
	return [self getLine:linePtr column:columnPtr source:sourcePtr
		forRecordIndex:[self recordIndexForLocation:point inPageAtIndex:pageIndex]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getLine:column:sourceBefore:sourceAfter:forLocation:withHint:inPageAtIndex:
- (BOOL)getLine:(unsigned int *)linePtr column:(unsigned int *)columnPtr sourceBefore:(NSString **)sourceBeforeRef sourceAfter:(NSString **)sourceAfterRef forLocation:(NSPoint)point withHint:(NSDictionary *)hint inPageAtIndex:(unsigned int)pageIndex;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if((pageIndex<0) || (pageIndex>=[_PageSyncLocations count]))
        return NO;

    NSValue * V = nil;
	if(V = [hint objectForKey:@"line bounds"])
	{
		NSRect lineBounds = NSInsetRect([V rectValue], -1, -1);
		NSDictionary * D = [_PageSyncLocations objectAtIndex:pageIndex];
		NSEnumerator * E = [D keyEnumerator];
		NSNumber * N;
		NSMutableArray * left = [NSMutableArray array];// records are on the left of the column
		NSMutableDictionary * above = [NSMutableDictionary dictionary];// records are above the line bounds
		NSMutableDictionary * below = [NSMutableDictionary dictionary];// records are below the line bounds
		NSMutableArray * right = [NSMutableArray array];// records are on the right of the column
		while(N = [E nextObject])
		{
			V = [D objectForKey:N];
			iTM2SynchronizationLocationRecord locationRecord;
			[V getValue:&locationRecord];
			if(locationRecord.x < NSMinX(lineBounds))
				[left addObject:N];
			else if(locationRecord.x > NSMaxX(lineBounds))
				[right addObject:N];
			else if(locationRecord.y < NSMinY(lineBounds))
			{
				NSNumber * n = [NSNumber numberWithFloat:NSMinY(lineBounds) - locationRecord.y];
				NSMutableArray * mra = [below objectForKey:n];
				if(!mra)
				{
					mra = [NSMutableArray array];
					[below setObject:mra forKey:n];
				}
				[mra addObject:N];
			}
			else// if([above count] || ![below count])// necessary to eliminate some exotic sync points
			{
				NSNumber * n = [NSNumber numberWithFloat:locationRecord.y - NSMinY(lineBounds)];
				NSMutableArray * mra = [above objectForKey:n];
				if(!mra)
				{
					mra = [NSMutableArray array];
					[above setObject:mra forKey:n];
				}
				[mra addObject:N];
			}
		}
//NSLog(@"The record index for location:%@ in page :%u is %i", NSStringFromPoint(point), page, result);
//NSLog(@"record index:%u (%@)", (resultObject? [[[D allKeysForObject:resultObject] lastObject] unsignedIntValue]:NSNotFound), resultObject);
		if([above count])
		{
			NSNumber * weightNumber = [[[above allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:0];
			NSNumber * recordNumber = [[above objectForKey:weightNumber] objectAtIndex:0];
			return [self getLine:linePtr column:columnPtr source:sourceBeforeRef
							forRecordIndex:[recordNumber unsignedIntValue]];
		}
		else if([below count])
		{
			NSNumber * weightNumber = [[[below allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:0];
			NSNumber * recordNumber = [[below objectForKey:weightNumber] objectAtIndex:0];
			return [self getLine:linePtr column:columnPtr source:sourceAfterRef
							forRecordIndex:[recordNumber unsignedIntValue]];
		}
		else if([left count])
		{
			NSNumber * recordNumber = [left lastObject];
			return [self getLine:linePtr column:columnPtr source:sourceBeforeRef
							forRecordIndex:[recordNumber unsignedIntValue]];
		}
		else if([right count])
		{
			NSNumber * recordNumber = [right objectAtIndex:0];
			return [self getLine:linePtr column:columnPtr source:sourceAfterRef
							forRecordIndex:[recordNumber unsignedIntValue]];
		}
	}
	return [self getLine:linePtr column:columnPtr source:sourceBeforeRef
		forRecordIndex:[self recordIndexForLocation:point inPageAtIndex:pageIndex]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getRecordIndexes:beforeIndexes:afterIndexes:column:inSource:
- (void)getRecordIndexes:(NSArray **)hereIndexes beforeIndexes:(NSArray **)beforeIndexes afterIndexes:(NSArray **)afterIndexes forLine:(unsigned int)line column:(unsigned int)column inSource:(NSString *)source;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(line == NSNotFound)
	{
		if(beforeIndexes)
			*beforeIndexes = nil;
		if(afterIndexes)
			*afterIndexes = nil;
		if(hereIndexes)
			*hereIndexes = nil;
        return;
	}
    if(![source length] && [_Files count])
        source = [_Files objectAtIndex:0];
    if(![source hasPrefix:@"/"])
        source = [[[_FileName stringByDeletingLastPathComponent]
			stringByAppendingPathComponent:source] stringByStandardizingPath];
//NSLog(@"hereIndexesForLine:%u (%u) column:%u inSource:%@", line, NSNotFound, column, source);
	int sourceIndex = [_Files indexOfObject:source];
    if(sourceIndex == NSNotFound)
    {
        iTM2_LOG(@"%@ not found in available:%@", source, _Files);
        return;
    }
    NSEnumerator * E = [_Lines objectEnumerator];
    NSNumber * N;
    int beforeMin = INT_MAX;
    int afterMin = INT_MAX;
    id beforeObjectResult = nil;
    id beforeDictResult = nil;
    id afterObjectResult = nil;
    id afterDictResult = nil;
    while(N = [E nextObject])
    {
        if([N intValue] == sourceIndex)
        {
            NSDictionary * D = [E nextObject];
            NSEnumerator * e = [D objectEnumerator];// an array MUST be there!!!
            NSValue * V;
            while(V = [e nextObject])
            {
                iTM2SynchronizationLineRecord lineRecord;
                [V getValue:&lineRecord];
                if(lineRecord.line == line)
                {
//NSLog(@"result exact line number:%u", [[[D allKeysForObject:V] lastObject] unsignedIntValue]);
					if(beforeIndexes)
						*beforeIndexes = nil;
					if(afterIndexes)
						*afterIndexes = nil;
					if(hereIndexes)
						*hereIndexes = [D allKeysForObject:V];
                    return;
				}
                else if(lineRecord.line < line)
                {
//NSLog(@"result exact line number:%u", [[[D allKeysForObject:V] lastObject] unsignedIntValue]);
					int newMin = line-lineRecord.line;
					if(newMin < beforeMin)
					{
						beforeMin = newMin;
						beforeObjectResult = V;
						beforeDictResult = D;
					}
				}
                else//if(lineRecord.line > line)
                {
//NSLog(@"result exact line number:%u", [[[D allKeysForObject:V] lastObject] unsignedIntValue]);
					int newMin = lineRecord.line-line;
					if(newMin < afterMin)
					{
						afterMin = newMin;
						afterObjectResult = V;
						afterDictResult = D;
					}
				}
            }
        }
        else
            [E nextObject];
    }
	if(beforeIndexes)
		*beforeIndexes = [beforeDictResult allKeysForObject:beforeObjectResult];
	if(afterIndexes)
		*afterIndexes = [afterDictResult allKeysForObject:afterObjectResult];
	if(hereIndexes)
		*hereIndexes = nil;// allways nil
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getLocation:page:forRecordIndex:
- (BOOL)getLocation:(NSPoint *)thePointPtr page:(unsigned int *)thePagePtr forRecordIndex:(unsigned int)index;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(index == NSNotFound)
        return NO;
    unsigned int page = 0;
    NSNumber * K = [NSNumber numberWithUnsignedInt:index];
    while(page<[_PageSyncLocations count])
    {
        NSDictionary * locations = [_PageSyncLocations objectAtIndex:page];
        NSValue * V = [locations objectForKey:K];
        if(V)
        {
            iTM2SynchronizationLocationRecord locationRecord;
            [V getValue:&locationRecord];
            if(thePagePtr)
                * thePagePtr = page;
            if(thePointPtr)
                * thePointPtr = NSMakePoint(locationRecord.x, locationRecord.y);
//NSLog(@"The location and page for index %u are %@ and %u", index, NSStringFromPoint(* thePointPtr), page);
            return YES;
        }
        ++page;
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  destinationsForLine:column:inSource:
- (NSDictionary*)destinationsForLine:(unsigned int)line column:(unsigned int)column inSource:(NSString *)source;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * hereIndexes = nil;
	NSArray * beforeIndexes = nil;
	NSArray * afterIndexes = nil;
	[self getRecordIndexes:&hereIndexes beforeIndexes:&beforeIndexes afterIndexes:&afterIndexes forLine:line column:column inSource:source];
	// now, the 3 arrays contain indexes of pdfsync records, either before the line, either after the line, either on the line.
	NSMutableDictionary * hereResult = [NSMutableDictionary dictionary];
	NSMutableDictionary * beforeResult = [NSMutableDictionary dictionary];
	NSMutableDictionary * afterResult = [NSMutableDictionary dictionary];
	NSEnumerator * E = nil;
	NSPoint point;
	unsigned int pageIndex;
	NSNumber * N = nil;
	unsigned int recordIndex = 0;
	NSNumber * key = nil;
	NSValue * V = nil;
	NSMutableArray * MRA = nil;
	if(hereIndexes)
	{
		// I got the exact line index!
		// hereIndexes is an array record indexes, each one corresponding to the same line
		E = [hereIndexes objectEnumerator];
		while(N = [E nextObject])
		{
			recordIndex = [N unsignedIntValue];
			[self getLocation:&point page:&pageIndex forRecordIndex:recordIndex];
			key = [NSNumber numberWithUnsignedInt:pageIndex];
			MRA = [hereResult objectForKey:key];
			if(!MRA)
			{
				MRA = [NSMutableArray array];
				[hereResult setObject:MRA forKey:key];
			}
			V = [NSValue valueWithPoint:point];
			[MRA addObject:V];
		}
		// hereResult is a dictionary,
		// each key is a NSNumber containing the page index where the pdfsync was found
		// each value is an array of NSValue's wrapping the points in the page where lie the pdfsync bullets.
	}
	if(beforeIndexes)
	{
		// I got the lines before index!
		// beforeIndexes is an array before indexes, each one corresponding to the same line in the source
		E = [beforeIndexes objectEnumerator];
		while(N = [E nextObject])
		{
			recordIndex = [N unsignedIntValue];
			[self getLocation:&point page:&pageIndex forRecordIndex:recordIndex];
			key = [NSNumber numberWithUnsignedInt:pageIndex];
			MRA = [beforeResult objectForKey:key];
			if(!MRA)
			{
				MRA = [NSMutableArray array];
				[beforeResult setObject:MRA forKey:key];
			}
			V = [NSValue valueWithPoint:point];
			[MRA addObject:V];
		}
	}
	if(afterIndexes)
	{
		// I got lines after index!
		// beforeIndexes is an array before indexes, each one corresponding to the same line
		E = [afterIndexes objectEnumerator];
		while(N = [E nextObject])
		{
			recordIndex = [N unsignedIntValue];
			[self getLocation:&point page:&pageIndex forRecordIndex:recordIndex];
			key = [NSNumber numberWithUnsignedInt:pageIndex];
			MRA = [afterResult objectForKey:key];
			if(!MRA)
			{
				MRA = [NSMutableArray array];
				[afterResult setObject:MRA forKey:key];
			}
			V = [NSValue valueWithPoint:point];
			[MRA addObject:V];
		}
	}
	NSMutableDictionary * result = [NSMutableDictionary dictionary];
	[result setObject:beforeResult forKey:@"before"];
	[result setObject:afterResult forKey:@"after"];
	[result setObject:hereResult forKey:@"here"];
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  recordIndexForLocation:inPageAtIndex:
- (int)recordIndexForLocation:(NSPoint)point inPageAtIndex:(unsigned int)pageIndex;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"recordIndexForLocation:%@ inPageAtIndex:%u", NSStringFromPoint(point), pageIndex);
    if((pageIndex<0) || (pageIndex>=[_PageSyncLocations count]))
        return NSNotFound;
    NSDictionary * D = [_PageSyncLocations objectAtIndex:pageIndex];
    NSEnumerator * E = [D objectEnumerator];
    NSValue * V = nil;
    float min = 1e20;
    id resultObject = nil;
    while(V = [E nextObject])
    {
        iTM2SynchronizationLocationRecord locationRecord;
        [V getValue:&locationRecord];
        locationRecord.x -= point.x;
        locationRecord.y -= point.y;
        float newMin = MAX(abs(locationRecord.x), abs(locationRecord.y));
//NSLog(@"P.x:%f", P.x);
//NSLog(@"min:%f", min);
        if(newMin<min)
        {
            min = newMin;
            resultObject = V;
        }
    }
//NSLog(@"The record index for location:%@ in page :%u is %i", NSStringFromPoint(point), page, result);
//NSLog(@"record index:%u (%@)", (resultObject? [[[D allKeysForObject:resultObject] lastObject] unsignedIntValue]:NSNotFound), resultObject);
    return resultObject? [[[D allKeysForObject:resultObject] lastObject] unsignedIntValue]:NSNotFound;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getLine:column:source:forRecordIndex:
- (BOOL)getLine:(unsigned int *)linePtr column:(unsigned int *)columnPtr source:(NSString **)sourcePtr forRecordIndex:(unsigned int)index;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"index:%i", index);
//NSLog(@"_Lines:%@", _Lines);
    if(index == NSNotFound)
        return NO;
    NSNumber * recordNumber = [NSNumber numberWithUnsignedInt:index];
    NSEnumerator * E = [_Lines objectEnumerator];
    NSNumber * N;
    while(N = [E nextObject])
    {
        int sourceIndex = [N intValue];
//NSLog(@"sourceIndex:%i", sourceIndex);
        NSDictionary * lines = [E nextObject];
        NSValue * V = [lines objectForKey:recordNumber];
        if(V)
        {
            iTM2SynchronizationLineRecord lineRecord;
            [V getValue:&lineRecord];
            if(linePtr)
                * linePtr = lineRecord.line;
            if(columnPtr)
                * columnPtr = lineRecord.column;
            if(sourcePtr)
                * sourcePtr = [_Files objectAtIndex:sourceIndex];
            return YES;
        }
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sourcesForPageAtIndex:
- (NSArray *)sourcesForPageAtIndex:(unsigned int)pageIndex;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"recordIndexForLocation:%@ inPageAtIndex:%u", NSStringFromPoint(point), pageIndex);
    if((pageIndex<0) || (pageIndex>=[_PageSyncLocations count]))
        return nil;
	NSMutableSet * result = [NSMutableSet set];// to be converted to an array on return
    NSEnumerator * E = [[_PageSyncLocations objectAtIndex:pageIndex] keyEnumerator];
    NSNumber * N = nil;
    while(N = [E nextObject])
    {
		NSString * source;
		if([self getLine:nil column:nil source:&source forRecordIndex:[N unsignedIntValue]])
		{
			[result addObject:source];
		}
    }
//iTM2_END;
	return [result allObjects];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizationLocationsForPageIndex:
- (NSDictionary *)synchronizationLocationsForPageIndex:(unsigned int)page;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return (page >= 0) && (page < [_PageSyncLocations count])? [_PageSyncLocations objectAtIndex:page]:nil;
}
@end

#import "synctex_parser.h"
#import <string.h>

@interface iTM2SyncTeXSynchronizer: iTM2PDFSynchronizer
{
@private
	synctex_scanner_t scanner;
}
@end


@implementation iTM2SyncTeXSynchronizer
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super initialize];
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
			NSStringFromPoint(NSMakePoint(0, 0)), iTM2PDFSyncOffsetKey,
				nil]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isSyncTeX
- (BOOL)isSyncTeX;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scanner
- (synctex_scanner_t)scanner;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return scanner;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithOutputURL:
- (id)initWithOutputURL:(NSURL *)outputURL;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![outputURL isFileURL])
	{
		[self dealloc];
		self = nil;
		return self;
	}
	if(self = [super init])
	{
		NSString * path = [outputURL path];
		scanner = synctex_scanner_new_with_output_file([path fileSystemRepresentation],nil,1);
		if(scanner == NULL)
		{
			// maybe there is a synctex file in the faraway directory
			// this can occur if the engine moves the pdf but does not move the compagnion synctex file
			// we have a problem here concerning the file modification date.
			// In order to make code simple, we are going to do something rather inefficient
			// when big files are involved.
			// We try to create a synctex scanner, then we compare the file modification dates
			// of the output file and the scanner related file
			NSString * FPD = [NSString farawayProjectsDirectory];
			NSString * otherPath = [FPD stringByAppendingPathComponent:path];
			// if there is a file at otherPath, any synctex information will belong to these file
			if([DFM fileExistsAtPath:otherPath])
			{
				// maybe the otherPath is the same as path
				// in that case the faraway synctex information is appropriate
				// otherwise we should ignore it
				if(![[path stringByResolvingSymlinksAndFinderAliasesInPath] pathIsEqual:
					[otherPath stringByResolvingSymlinksAndFinderAliasesInPath]])
				{
					[self release];
					self = nil;
					return self;
				}
			}
			scanner = synctex_scanner_new_with_output_file([path fileSystemRepresentation],nil,1);
			if(scanner == NULL)
			{
				[self release];
				self = nil;
				return self;
			}
			// if the scanner was created with a file older than the outputURL's one,
			// then it is not up to date.
			const char * synctex = synctex_scanner_get_synctex(scanner);
			otherPath = [DFM stringWithFileSystemRepresentation:synctex length:strlen(synctex)];
			NSDate * date = [[DFM fileAttributesAtPath:path traverseLink:YES] objectForKey:NSFileModificationDate];
			NSDate * otherDate = [[DFM fileAttributesAtPath:otherPath traverseLink:YES] objectForKey:NSFileModificationDate];
			if([otherDate timeIntervalSinceDate:date]<1)
			{
				// the path was modified 1 second after other path was
				// I consider that otherPath is obsolete
				synctex_scanner_free(scanner);
				[self release];
				self = nil;
				return self;
			}
		}
	}
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getLine:column:length:source:forLocation:withHint:inPageAtIndex:
- (BOOL)getLine:(unsigned int *)linePtr column:(unsigned int *)columnPtr length:(unsigned int *)lengthPtr source:(NSString **)sourcePtr forLocation:(NSPoint)point withHint:(NSDictionary *)hint inPageAtIndex:(unsigned int)pageIndex;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSValue * V = [hint objectForKey:@"page bounds"];
	if(!V)
	{
		return NO;
	}
	NSRect bounds = [V rectValue];
	point.y = NSMaxY(bounds)-point.y;
	if(synctex_edit_query(scanner,pageIndex+1,point.x,point.y)>0) {
		synctex_node_t node;
		if(node = synctex_next_result(scanner)) {
			if(linePtr) *linePtr = synctex_node_line(node);
			if(columnPtr) *columnPtr = synctex_node_column(node);
			if(lengthPtr) *lengthPtr = 0;
			
			if(sourcePtr) {
				const char * rep = synctex_scanner_get_name(scanner,synctex_node_tag(node));
				if(rep)
				{
					*sourcePtr = [DFM stringWithFileSystemRepresentation:rep length:strlen(rep)];
					if(![*sourcePtr isAbsolutePath])
					{
						rep = synctex_scanner_get_synctex(scanner);
						NSString * dir = [DFM stringWithFileSystemRepresentation:rep length:strlen(rep)];
						dir = [dir stringByDeletingLastPathComponent];
						[DFM pushDirectory:dir];
						NSURL * url = [NSURL fileURLWithPath:*sourcePtr];
						[DFM popDirectory];
						*sourcePtr = [url path];
					}
				}
				else
				{
					// weird
					iTM2_LOG(@"STOP HERE!");
				}
			} 
			return YES;
		}
	}
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getLine:column:sourceBefore:sourceAfter:forLocation:withHint:inPageAtIndex:
- (BOOL)getLine:(unsigned int *)linePtr column:(unsigned int *)columnPtr sourceBefore:(NSString **)sourceBeforeRef sourceAfter:(NSString **)sourceAfterRef forLocation:(NSPoint)point withHint:(NSDictionary *)hint inPageAtIndex:(unsigned int)pageIndex;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(sourceAfterRef) *sourceAfterRef = nil;
//iTM2_END;
	return [self getLine:linePtr column:columnPtr length:nil source:sourceBeforeRef forLocation:point withHint:hint inPageAtIndex:pageIndex];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getRecordIndexes:beforeIndexes:afterIndexes:column:inSource:
- (void)getRecordIndexes:(NSArray **)hereIndexes beforeIndexes:(NSArray **)beforeIndexes afterIndexes:(NSArray **)afterIndexes forLine:(unsigned int)line column:(unsigned int)column inSource:(NSString *)source;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getLocation:page:forRecordIndex:
- (BOOL)getLocation:(NSPoint *)thePointPtr page:(unsigned int *)thePagePtr forRecordIndex:(unsigned int)index;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  destinationsForLine:column:inSource:
- (NSDictionary*)destinationsForLine:(unsigned int)line column:(unsigned int)column inSource:(NSString *)source;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(synctex_display_query(scanner,[source fileSystemRepresentation],line+1,column)>0) {
		NSMutableDictionary * result = [NSMutableDictionary dictionary];
		NSMutableDictionary * hereResult = [NSMutableDictionary dictionary];
		synctex_node_t node;
		while((node = synctex_next_result(scanner))) {
			NSNumber * N = [NSNumber numberWithInt:synctex_node_page(node)-1];
			NSPoint P = NSMakePoint(synctex_node_visible_h(node),synctex_node_visible_v(node));
			NSValue * V = [NSValue valueWithPoint:P];
			[hereResult setObject:[NSArray arrayWithObject:V] forKey:N];
		}
		[result setObject:hereResult forKey:@"here"];
		[result setObject:[NSNumber numberWithBool:YES] forKey:@"SyncTeX"];
		return result;
	}
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  recordIndexForLocation:inPageAtIndex:
- (int)recordIndexForLocation:(NSPoint)point inPageAtIndex:(unsigned int)pageIndex;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getLine:column:source:forRecordIndex:
- (BOOL)getLine:(unsigned int *)linePtr column:(unsigned int *)columnPtr source:(NSString **)sourcePtr forRecordIndex:(unsigned int)index;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sourcesForPageAtIndex:
- (NSArray *)sourcesForPageAtIndex:(unsigned int)pageIndex;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return nil;
}
@end

#import <iTM2Foundation/iTM2ResponderKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>

@interface iTM2PDFImageRepView(Synchronization_PRIVATE_9)
- (BOOL)validateScrollSynchronizationPointToVisible:(NSMenuItem *)sender;
@end


@implementation NSApplication(iTM2PDFSYNCResponder)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFSYNCResponderDidFinishLaunching
- (void)iTM2PDFSYNCResponderDidFinishLaunching;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.4:Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self targetForAction:@selector(toggleSyncFollowFocus:)])
		[iTM2MileStone putMileStoneForKey:@"iTM2PDFSYNCResponder"];
//iTM2_END;
	return;
}
@end

@implementation iTM2PDFSYNCResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[iTM2MileStone registerMileStone:@"No installer available" forKey:@"iTM2PDFSYNCResponder"];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super initialize];
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithBool:YES], iTM2PDFSyncFollowFocusKey,
			[NSNumber numberWithFloat:0.5], iTM2PDFSyncPriorityKey,
			[NSNumber numberWithBool:NO], iTM2PDFSyncShowRecordNumberKey,
			[NSNumber numberWithInt:7], iTM2PDFSYNCDisplayBulletsKey,
			[NSNumber numberWithFloat:30], iTM2PDFSYNCTimeKey,
				nil]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSyncFollowFocus:
- (IBAction)toggleSyncFollowFocus:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id R = [[NSApp mainWindow] firstResponder];
    BOOL old = [R contextBoolForKey:iTM2PDFSyncFollowFocusKey domain:iTM2ContextAllDomainsMask];
    [R takeContextBool:!old forKey:iTM2PDFSyncFollowFocusKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSyncFollowFocus:
- (BOOL)validateToggleSyncFollowFocus:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState:([[[NSApp mainWindow] firstResponder] contextBoolForKey:iTM2PDFSyncFollowFocusKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSynchronizationMode:
- (IBAction)toggleSynchronizationMode:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSWindow * W = [NSApp mainWindow];
    id R = [W firstResponder];
    BOOL old = [R contextBoolForKey:iTM2PDFNoSynchronizationKey domain:iTM2ContextAllDomainsMask];
    [R takeContextBool:!old forKey:iTM2PDFNoSynchronizationKey domain:iTM2ContextAllDomainsMask];
	id D = [[W windowController] document];
	if([D respondsToSelector:@selector(updateSynchronizer:)])
		[D updateSynchronizer:self];//update the views
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSynchronizationMode:
- (BOOL)validateToggleSynchronizationMode:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//	[sender setState:([[[NSApp mainWindow] firstResponder] contextBoolForKey:iTM2PDFNoSynchronizationKey domain:iTM2ContextAllDomainsMask]? NSOffState:NSOnState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSyncNoBullets:
- (IBAction)toggleSyncNoBullets:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSWindow * W = [NSApp mainWindow];
    id R = [W firstResponder];
    [R takeContextInteger:0 forKey:iTM2PDFSYNCDisplayBulletsKey domain:iTM2ContextAllDomainsMask];
    [[[W windowController] document] updateSynchronizer:self];//update the views
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSyncNoBullets:
- (BOOL)validateToggleSyncNoBullets:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * W = [NSApp mainWindow];
	int mode = [[W firstResponder] contextIntegerForKey:iTM2PDFSYNCDisplayBulletsKey domain:iTM2ContextAllDomainsMask];
	[sender setState:(mode == 0? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSyncAllBullets:
- (IBAction)toggleSyncAllBullets:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSWindow * W = [NSApp mainWindow];
    id R = [W firstResponder];
    [R takeContextInteger:kiTM2PDFSYNCDisplayBuiltInBullets|kiTM2PDFSYNCDisplayUserBullets|kiTM2PDFSYNCDisplayFocusBullets
        forKey:iTM2PDFSYNCDisplayBulletsKey domain:iTM2ContextAllDomainsMask];
    [[[W windowController] document] updateSynchronizer:self];//update the views
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSyncAllBullets:
- (BOOL)validateToggleSyncAllBullets:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * W = [NSApp mainWindow];
	int mode = [[W firstResponder] contextIntegerForKey:iTM2PDFSYNCDisplayBulletsKey domain:iTM2ContextAllDomainsMask];
	[sender setState:(mode == (kiTM2PDFSYNCDisplayBuiltInBullets|kiTM2PDFSYNCDisplayUserBullets|kiTM2PDFSYNCDisplayFocusBullets)? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSyncUserBullets:
- (IBAction)toggleSyncUserBullets:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSWindow * W = [NSApp mainWindow];
    id CM = [[W firstResponder] contextManager];
    [CM takeContextInteger:kiTM2PDFSYNCDisplayUserBullets|kiTM2PDFSYNCDisplayFocusBullets
        forKey:iTM2PDFSYNCDisplayBulletsKey domain:iTM2ContextAllDomainsMask];
    [[[W windowController] document] updateSynchronizer:self];//update the views
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSyncUserBullets:
- (BOOL)validateToggleSyncUserBullets:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * W = [NSApp mainWindow];
	int mode = [[W firstResponder] contextIntegerForKey:iTM2PDFSYNCDisplayBulletsKey domain:iTM2ContextAllDomainsMask];
	[sender setState:(mode == (kiTM2PDFSYNCDisplayUserBullets|kiTM2PDFSYNCDisplayFocusBullets)? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSyncFocusBullet:
- (IBAction)toggleSyncFocusBullet:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSWindow * W = [NSApp mainWindow];
    id CM = [[W firstResponder] contextManager];
    [CM takeContextInteger:kiTM2PDFSYNCDisplayFocusBullets forKey:iTM2PDFSYNCDisplayBulletsKey domain:iTM2ContextAllDomainsMask];
    [[[W windowController] document] updateSynchronizer:self];//update the views
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSyncFocusBullet:
- (BOOL)validateToggleSyncFocusBullet:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * W = [NSApp mainWindow];
	int mode = [[W firstResponder] contextIntegerForKey:iTM2PDFSYNCDisplayBulletsKey domain:iTM2ContextAllDomainsMask];
	[sender setState:(mode == kiTM2PDFSYNCDisplayFocusBullets? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findAndScrollSynchronizationPointToVisible:
- (IBAction)findAndScrollSynchronizationPointToVisible:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2PDFInspector * WC = [[NSApp mainWindow] windowController];
	if([WC respondsToSelector:@selector(canSynchronizeOutput)] && [WC canSynchronizeOutput])
	{
		[WC scrollSynchronizationPointToVisible:(id) sender];		
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFindAndScrollSynchronizationPointToVisible:
- (BOOL)validateFindAndScrollSynchronizationPointToVisible:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2PDFInspector * WC = [[NSApp mainWindow] windowController];
	return [WC respondsToSelector:@selector(canSynchronizeOutput)] && [WC canSynchronizeOutput]
		&& [WC validateScrollSynchronizationPointToVisible:sender];
}
@end

NSString * const iTM2PDFSYNCExtension = @"pdfsync";
#import <iTM2Foundation/iTM2StringKit.h>
#import <iTM2Foundation/iTM2PDFViewKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>
#pragma mark -
@implementation iTM2PDFDocument(SYNCKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= synchronizer
- (id)synchronizer;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSynchronizer:
- (void)setSynchronizer:(id)argument;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument != metaGETTER)
    {
        metaSETTER(argument);
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceSynchronizer:
- (void)replaceSynchronizer:(id)argument;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSInvocation * I = [[[IMPLEMENTATION metaValueForKey:@"_Invocation"] retain] autorelease];
    [IMPLEMENTATION takeMetaValue:nil forKey:@"_Invocation"];
    id _Synchronizer = [self synchronizer];
    if(argument != _Synchronizer)
    {
        [_Synchronizer unlock];
        [self setSynchronizer:argument];
        _Synchronizer = [self synchronizer];
        [_Synchronizer lock];
    }
    NSEnumerator * E = [[NSApp windows] objectEnumerator];
    id W;
    while(W = [E nextObject])
	{
		id WC = [W windowController];
		if(([WC document] == self) && [WC respondsToSelector:@selector(canSynchronizeOutput)] && [WC canSynchronizeOutput])
            [[WC album] setNeedsDisplay:YES];
	}
    if(_Synchronizer)
    {
        [I invoke];
//NSLog(@"INVOKED:%@", I);
// launch the invocation in the main thread
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= synchronizationCompleteDidReadFromURL:ofType:error:
- (void)synchronizationCompleteDidReadFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self updateSynchronizer:self];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateSynchronizerFileModificationDate
- (void)updateSynchronizerFileModificationDate;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// the filename is not really the final filename...
	NSString * FN = [self fileName];
	NSString * pdfsyncPath = [FN stringByDeletingPathExtension];
	pdfsyncPath = [pdfsyncPath stringByAppendingPathExtension:iTM2PDFSYNCExtension];
	pdfsyncPath = [pdfsyncPath stringByResolvingSymlinksAndFinderAliasesInPath];
	if([DFM fileExistsAtPath:pdfsyncPath])
	{
		NSDate * pdfDate = [[DFM fileAttributesAtPath:FN traverseLink:NO] fileModificationDate];
		if(pdfDate && ![DFM changeFileAttributes:[NSDictionary dictionaryWithObject:pdfDate forKey:NSFileModificationDate] atPath:pdfsyncPath])
		{
			iTM2_LOG(@"ERROR:Unexpected problem:could not change the file modification date...");
		}
	}
	else
	{
		iTM2ProjectDocument * PD = [SPC projectForFileName:FN];
		NSString * dirName = [PD fileName];
		if([dirName belongsToFarawayProjectsDirectory])
		{
			dirName = [dirName enclosingWrapperFileName];
			NSString * K = [PD keyForFileName:FN];
			NSString * relativeName = [PD relativeFileNameForKey:K];
			pdfsyncPath = [relativeName stringByDeletingPathExtension];
			pdfsyncPath = [pdfsyncPath stringByAppendingPathExtension:iTM2PDFSYNCExtension];
			pdfsyncPath = [dirName stringByAppendingPathComponent:pdfsyncPath];
			pdfsyncPath = [pdfsyncPath stringByResolvingSymlinksAndFinderAliasesInPath];
			if([DFM fileExistsAtPath:pdfsyncPath])
			{
				NSDate * pdfDate = [[DFM fileAttributesAtPath:FN traverseLink:NO] fileModificationDate];
				if(pdfDate && ![DFM changeFileAttributes:[NSDictionary dictionaryWithObject:pdfDate forKey:NSFileModificationDate] atPath:pdfsyncPath])
				{
					iTM2_LOG(@"ERROR:Unexpected problem:could not change the file modification date...");
				}
			}
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= synchronizationCompleteWriteToURL:ofType:error:
- (void)synchronizationCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// the filename is not really the final filename...
	[self updateSynchronizerFileModificationDate];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= synchronizationCompleteSaveContext:
- (void)synchronizationCompleteSaveContext:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// the filename is not really the final filename...
	[self updateSynchronizerFileModificationDate];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateSynchronizer:
- (void)updateSynchronizer:(id)irrelevant;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    //things should be done only when the receiver is using the built in viewer
    // does a PDFSYNC info exist?
    if([self contextBoolForKey:iTM2PDFNoSynchronizationKey domain:iTM2ContextAllDomainsMask])
	{
        [self replaceSynchronizer:nil];
		return;
	}
    NSEnumerator * E = [[NSApp windows] objectEnumerator];
    NSWindow * W;
    while(W = [E nextObject])
	{
		id WC = [W windowController];
		if(([WC document] == self) && [WC respondsToSelector:@selector(canSynchronizeOutput)] && [WC canSynchronizeOutput])
		{
			goto laSuite;
		}
	}
	// no window to synchronize, no synchronizer
//iTM2_LOG(@"NO WINDOW TO SYNCHRONIZE");
	[self replaceSynchronizer:nil];
	return;
laSuite:;
	// first we try the synctex option
	// we just try to create a SyncTeX synchronizer
	// if something is returned, it means that there is a synctex file available.
	id S = nil;
	if(S = [[[iTM2SyncTeXSynchronizer allocWithZone:[self zone]] initWithOutputURL:[self fileURL]] autorelease])
	{
		[self replaceSynchronizer:S];
		return;
	}	
	NSString * FN = [self fileName];
	NSString * pdfsyncPath = [FN stringByDeletingPathExtension];
	pdfsyncPath = [pdfsyncPath stringByAppendingPathExtension:iTM2PDFSYNCExtension];
	pdfsyncPath = [pdfsyncPath stringByResolvingSymlinksAndFinderAliasesInPath];
	if(![DFM fileOrLinkExistsAtPath:pdfsyncPath])
	{
		iTM2ProjectDocument * PD = [SPC projectForFileName:FN];
		NSString * dirName = [PD fileName];
		if([dirName belongsToFarawayProjectsDirectory])
		{
			dirName = [dirName stringByDeletingLastPathComponent];
			NSString * K = [PD keyForFileName:FN];
			NSString * relativeName = [PD relativeFileNameForKey:K];
			pdfsyncPath = [relativeName stringByDeletingPathExtension];
			pdfsyncPath = [pdfsyncPath stringByAppendingPathExtension:iTM2PDFSYNCExtension];
			pdfsyncPath = [dirName stringByAppendingPathComponent:pdfsyncPath];
			pdfsyncPath = [pdfsyncPath stringByResolvingSymlinksAndFinderAliasesInPath];
			if(![DFM fileExistsAtPath:pdfsyncPath])
			{
				S = [[[iTM2PDFSynchronizer allocWithZone:[self zone]] init] autorelease];
				[self replaceSynchronizer:S];
				return;
			}
		}
		else
		{
			return;
		}
	}
	NSDate * pdfsyncDate = [[DFM fileAttributesAtPath:pdfsyncPath traverseLink:NO] fileModificationDate];
	if(!pdfsyncDate)
	{
		if(![self synchronizer])
		{
			S = [[[iTM2PDFSynchronizer allocWithZone:[self zone]] init] autorelease];
			[self replaceSynchronizer:S];
		}
		return;
	}
#if 0
// is the file busy?
	int fd = open( [pdfsyncPath fileSystemRepresentation], O_RDONLY + O_NONBLOCK );
	if(fd)
	{
		close(fd);
	}
	else
	{
		NSLog(@"The file is already open");        
	}
#endif
	NSDate * pdfDate = [[DFM fileAttributesAtPath:FN traverseLink:NO] fileModificationDate];
//iTM2_LOG(@"pdfDate:%@, pdfsyncDate:%@, [pdfDate timeIntervalSinceDate:pdfsyncDate]:%d", pdfDate, pdfsyncDate, [pdfDate timeIntervalSinceDate:pdfsyncDate]);
	if([pdfDate timeIntervalSinceDate:pdfsyncDate] < [self contextFloatForKey:iTM2PDFSYNCTimeKey domain:iTM2ContextAllDomainsMask])// in seconds
	{
		[INC removeObserver:self
			name:iTM2PDFSyncParsedNotificationName
				object:nil];
		id S = [[[iTM2PDFSynchronizer allocWithZone:[self zone]] init] autorelease];
		[self replaceSynchronizer:S];
		[INC addObserver:self
			selector:@selector(pdfsyncDidParseNotified:)
				name:iTM2PDFSyncParsedNotificationName
					object:S];
		[S parsePdfsync:pdfsyncPath];
	}
	else
	{
		iTM2_LOG(@"No synchronization available (pdfsync date %@>= pdf date %@ (%f s error -> pdfsync %lf)).", pdfsyncDate, pdfDate, [self contextFloatForKey:iTM2PDFSYNCTimeKey domain:iTM2ContextAllDomainsMask], [pdfDate timeIntervalSinceDate:pdfsyncDate]);
		int tag;
		if(![SWS performFileOperation:NSWorkspaceRecycleOperation
			source:[pdfsyncPath stringByDeletingLastPathComponent]	
				destination:nil
					files:[NSArray arrayWithObject:[pdfsyncPath lastPathComponent]]
						tag:&tag])
		{
			iTM2_LOG(@"ERROR:Could not recycle %@ due to %i, please do it for me...", pdfsyncPath, tag);
		}
		S = [[[iTM2PDFSynchronizer allocWithZone:[self zone]] init] autorelease];
		[self replaceSynchronizer:S];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pdfsyncDidParseNotified:
- (void)pdfsyncDidParseNotified:(NSNotification *)notification;
/*"Description Forthcoming. This is meant to live in the main thread...
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self replaceSynchronizer:[notification object]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPageForLine:column:source:withHint:orderFront:
- (BOOL)displayPageForLine:(unsigned int)l column:(unsigned int)c source:(NSString *)SRCE withHint:(NSDictionary *)hint orderFront:(BOOL)yorn force:(BOOL)force;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[self project] allowsSubdocumentsInteraction])
	{
		return YES;
	}
	NSEnumerator * E = [[NSApp windows] objectEnumerator];
	NSWindow * W;
	id WC;
	NSDictionary * destinations = nil;
	while(W = [E nextObject])
		if(([[W windowController] document] == self) && [W isVisible])
			goto laSuite;
	[self makeWindowControllers];
	[self showWindows];
	BOOL result = NO;
laSuite:
#if 0
	if([SRCE hasPrefix:@"/"])
	{
		SRCE = [SRCE stringByAbbreviatingWithDotsRelativeToDirectory:[[self fileName] stringByDeletingLastPathComponent]];
	}
#endif
//NSLog(@"line:%u column:%u source:%@", l, c, SRCE);
    [IMPLEMENTATION takeMetaValue:nil forKey:@"_Invocation"];
	// external viewers are prominent
	E = [[NSApp windows] objectEnumerator];
	while(W = [E nextObject])
	{
		WC = [W windowController];
		if(([WC document] == self) && force && [WC isKindOfClass:[iTM2ExternalInspector class]])
		{
			result = result || [WC switchToExternalHelperWithEnvironment:[NSDictionary dictionaryWithObjectsAndKeys:
				[self fileName], @"file",
				[NSNumber numberWithInt:l], @"line",
				[NSNumber numberWithInt:c], @"column",
				([SRCE length]? SRCE:@""), @"source", nil]];
		}
	}
//NSLog(@"SYNCHRONIZING");
	id syncer = [self synchronizer];
	if(!syncer)
	{
		[self updateSynchronizer:self];
	}
	else
	{
		BOOL result = NO;
		E = [[NSApp windows] objectEnumerator];
		if(![syncer isSyncTeX] &&(destinations = [syncer destinationsForLine:l column:c inSource:SRCE])) {
			hint = [[hint mutableCopy] autorelease];
			[(id)hint setObject:destinations forKey:@"destinations"];
		}
		while(W = [E nextObject])
		{
			WC = [W windowController];
//iTM2_LOG(@"[WC document]:%@, [WC class]:%@", [WC document], [WC class]);
			if(([WC document] == self)
				&& [WC respondsToSelector:@selector(canSynchronizeOutput)]
					&& [WC canSynchronizeOutput])
			{
				if([WC synchronizeWithLine:l column:c source:SRCE hint:hint]
					|| (destinations && [WC synchronizeWithDestinations:destinations hint:hint]))// after the window has been loaded
				{
					if(yorn)
					{
						if(force)
						{
							[W makeKeyAndOrderFront:self];
						}
						else if(![WC isKindOfClass:[iTM2ExternalInspector class]])
						{
							[W orderBelowFront:self];
						}
					}
					result = YES;
				}
			}
		}
		if(result)
		{
			return result;
		}
	}
	if(l != NSNotFound)
	{
		if([[self synchronizer] isSyncTeX])
		{
			hint = [[hint mutableCopy] autorelease];
		}
		result = NO;
		E = [[NSApp windows] objectEnumerator];
		while(W = [E nextObject])
		{
			iTM2PDFInspector * WC = [W windowController];
//iTM2_LOG(@"[WC document]:%@, [WC class]:%@", [WC document], [WC class]);
			if(([WC document] == self)
				&& [WC respondsToSelector:@selector(canSynchronizeOutput)]
					&& [WC canSynchronizeOutput])
			{
				if([WC synchronizeWithDestinations:destinations hint:hint])
				{
					if(yorn && (force || ![WC isKindOfClass:[iTM2ExternalInspector class]]))
					{
						[W makeKeyAndOrderFront:self];
					}
					else
					{
						[W orderBelowFront:self];
					}
					result = YES;
				}
			}
		}
		if(!result && [self synchronizer])
		{
			NSMethodSignature * MS = [self methodSignatureForSelector:_cmd];
			NSInvocation * _Invocation = [NSInvocation invocationWithMethodSignature:MS];
			[_Invocation retainArguments];
			[_Invocation setTarget:self];
			[_Invocation setSelector:_cmd];
			[_Invocation setArgument:&l atIndex:2];
			[_Invocation setArgument:&c atIndex:3];
			[_Invocation setArgument:&SRCE atIndex:4];
			[_Invocation setArgument:&hint atIndex:5];
			[_Invocation setArgument:&yorn atIndex:6];
			[_Invocation setArgument:&force atIndex:7];
			[IMPLEMENTATION takeMetaValue:_Invocation forKey:@"_Invocation"];
		}
		if(result)
		{
			return result;
		}
//NSLog(@"DELAYED SYNCHRONIZATION %@", _Invocation);
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWithLocation:inPageAtIndex:withHint:orderFront:
- (void)synchronizeWithLocation:(NSPoint)thePoint inPageAtIndex:(unsigned int)thePage withHint:(NSDictionary *)hint orderFront:(BOOL)yorn;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * source = @"";
    unsigned int line = 0;
    unsigned int column = -1;
    unsigned int length = 1;
    [[self synchronizer] getLine:&line column:&column length:&length source:&source forLocation:thePoint withHint:hint inPageAtIndex:thePage];
//NSLog(@"point:%@ page:%u", NSStringFromPoint(thePoint) , thePage);
//NSLog(@"line:%u source:%@", line, source);
    if([source length])
	{
		NSURL * absoluteURL = [NSURL fileURLWithPath:source];
		id D = [SDC openDocumentWithContentsOfURL:absoluteURL display:NO error:nil];
		if(D)
		{
			NSDictionary * d = [NSDictionary dictionaryWithObjectsAndKeys:
				absoluteURL,@"current source URL",
				[NSNumber numberWithInt:line],@"line",
				[NSNumber numberWithInt:column],@"column",
				[NSNumber numberWithInt:length],@"length",
					nil];
			[[self implementation] takeMetaValue:d forKey:@"current source synchronization location"];
			[D displayLine:line column:column length:length withHint:hint orderFront:yorn];
		}
		return;
	}
	if(iTM2DebugEnabled)
    {
        iTM2_LOG(@"Could not synchronize with:<%@>", source);
    }
    return;
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderFrontCurrentSource
- (void)orderFrontCurrentSource;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * d = [[self implementation] metaValueForKey:@"current source synchronization location"];
	NSURL * url = [d objectForKey:@"current source URL"];
	if([url isFileURL])
	{
		id D = [SDC openDocumentWithContentsOfURL:url display:NO error:nil];
		if(D)
		{
			int line = [[d objectForKey:@"line"] intValue];
			int column = [[d objectForKey:@"column"] intValue];
			int length = [[d objectForKey:@"length"] intValue];
			[D displayLine:line column:column length:length withHint:nil orderFront:YES];
		}
	}
	[[self implementation] takeMetaValue:nil forKey:@"current source synchronization location"];
//iTM2_END;
}
@end

@implementation iTM2PDFInspector(SYNCKit)
/*"Description forthcoming."*/
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= canSynchronizeOutput
- (BOOL)canSynchronizeOutput;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollSynchronizationPointToVisible:
- (IBAction)scrollSynchronizationPointToVisible:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2PDFView * centeredSubview = [[self album] centeredSubview];
	NSEnumerator * E = [[centeredSubview subviews] objectEnumerator];
	iTM2PDFImageRepView * V;
	while(V = [E nextObject])
	{
		if([V isKindOfClass:[iTM2PDFImageRepView class]] && NSPointInRect([V synchronizationPoint], [V bounds]))
		{
			[centeredSubview selectViewWithTag:[V tag]];
			[[centeredSubview selectedView] scrollSynchronizationPointToVisible:sender];
			break;
		}
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateScrollSynchronizationPointToVisible:
- (BOOL)validateScrollSynchronizationPointToVisible:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [(iTM2PDFImageRepView *)[[[self album] centeredSubview] focusView] validateScrollSynchronizationPointToVisible:(NSMenuItem *) sender];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPhysicalPage:synchronizationPoint:withHint:
- (void)displayPhysicalPage:(int)page synchronizationPoint:(NSPoint)P withHint:(NSDictionary *)hint;
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(page<0)
    {
        page = 0;
        P = NSMakePoint(1e100, 1e100);
    }
    [[self album] takeCurrentPhysicalPage:page synchronizationPoint:P withHint:hint];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= synchronizeWithLine:column:source:hint:
- (BOOL)synchronizeWithLine:(unsigned int)l column:(unsigned int)c source:(NSString *)SRCE hint:(NSDictionary *)hint
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[[self document] synchronizer] isSyncTeX]
		&& [[self album] synchronizeWithLine:(unsigned int)l column:(unsigned int)c source:(NSString *)SRCE hint:(NSDictionary *) hint];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= synchronizeWithDestinations:hint:
- (BOOL)synchronizeWithDestinations:(NSDictionary *)destinations hint:(NSDictionary *)hint;
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog
//NSLog(@"dpn");
    return [[self album] synchronizeWithDestinations:(NSDictionary *) destinations hint:(NSDictionary *) hint];
}
@end

#import <iTM2Foundation/iTM2ViewKit.h>

@implementation iTM2PDFAlbumView(SYNCKit)
/*"Description forthcoming."*/
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= synchronizeWithLine:column:source:hint:
- (BOOL)synchronizeWithLine:(unsigned int)l column:(unsigned int)c source:(NSString *)SRCE hint:(NSDictionary *)hint
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= synchronizeWithDestinations:hint:
- (BOOL)synchronizeWithDestinations:(NSDictionary *)destinations hint:(NSDictionary *)hint;
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * Ds = [destinations objectForKey:@"here"];
	NSEnumerator * E = [Ds keyEnumerator];
	NSNumber * N = [E nextObject];
	NSNumber * minN = N;
	unsigned min;
	if(N)
	{
		min = abs([N unsignedIntValue]-[self currentPhysicalPage]);
		while(N = [E nextObject])
		{
			unsigned newMin = abs([N unsignedIntValue]-[self currentPhysicalPage]);
			if(newMin<min)
			{
				min = newMin;
				minN = N;
			}
		}
		NSArray * synchPoints = [Ds objectForKey:minN];
		if([synchPoints count])
		{
			[self takeCurrentPhysicalPage:[N unsignedIntValue]
				synchronizationPoint:[[synchPoints objectAtIndex:0] pointValue]
					withHint:hint];
			[self scrollSynchronizationPointToVisible:self];
			return YES;
		}
	}
	NSMutableDictionary * MDs = [[[destinations objectForKey:@"before"] mutableCopy] autorelease];
	[MDs addEntriesFromDictionary:[destinations objectForKey:@"after"]];
	E = [MDs keyEnumerator];
	N = [E nextObject];
	minN = N;
	if(N)
	{
		min = abs([N unsignedIntValue]-[self currentPhysicalPage]);
		while(N = [E nextObject])
		{
			unsigned newMin = abs([N unsignedIntValue]-[self currentPhysicalPage]);
			if(newMin<min)
			{
				min = newMin;
				minN = N;
			}
		}
		NSArray * synchPoints = [MDs objectForKey:minN];
		if([synchPoints count])
		{
			[self takeCurrentPhysicalPage:[N unsignedIntValue]
				synchronizationPoint:[[synchPoints objectAtIndex:0] pointValue]
					withHint:hint];
			[self scrollSynchronizationPointToVisible:self];
			return YES;
		}
	}
	iTM2_LOG(@"....  Unable to synchronize");
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeCurrentPhysicalPage:synchronizationPoint:withHint:
- (BOOL)takeCurrentPhysicalPage:(int)aCurrentPhysicalPage synchronizationPoint:(NSPoint)P withHint:(NSDictionary *)hint;
/*"O based.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning DEBUGGGG:I DONT KNOW WHY THIS SHOULD WORK!!!
    if([[self centeredSubview] takeCurrentPhysicalPage:aCurrentPhysicalPage synchronizationPoint:P withHint:hint])
    {
        [self setParametersHaveChanged:YES];
        return YES;
    }
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollSynchronizationPointToVisible:
- (void)scrollSynchronizationPointToVisible:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[(iTM2PDFImageRepView *)[[self centeredSubview] focusView] scrollSynchronizationPointToVisible:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateScrollSynchronizationPointToVisible:
- (BOOL)validateScrollSynchronizationPointToVisible:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [(iTM2PDFImageRepView *)[[self centeredSubview] focusView] validateScrollSynchronizationPointToVisible:(NSMenuItem *) sender];
}
@end

#import <iTM2Foundation/iTM2PDFViewKit.h>

@interface NSView(iTM2PDFSYNCKik)
- (void)setSynchronizationPoint:(NSPoint)P;
@end

@implementation iTM2PDFView(SYNCKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeCurrentPhysicalPage:synchronizationPoint:withHint:
- (BOOL)takeCurrentPhysicalPage:(int)aCurrentPhysicalPage synchronizationPoint:(NSPoint)P withHint:(NSDictionary *)hint;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
//NSLog(@"argument:%i", aCurrentPhysicalPage);
//NSLog(@"[self currentPhysicalPage]:%i", [self currentPhysicalPage]);
    if(++aCurrentPhysicalPage != [self currentLogicalPage])
    {
        NSEnumerator * E = [[self subviews] objectEnumerator];
        NSView * V;
        while(V = [E nextObject])
            [V setSynchronizationPoint:NSMakePoint(1e100, 1e100)];
        [self setCurrentLogicalPage:aCurrentPhysicalPage];
    }
    if (!NSEqualPoints([[self focusView] synchronizationPoint], P))
    {
        [[self focusView] setSynchronizationPoint:P];
        return YES;
    }
    return NO;
}
@end

@implementation NSView(iTM2PDFSYNCKik)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSynchronizationPoint:
- (void)setSynchronizationPoint:(NSPoint)P;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
@end

@implementation iTM2PDFImageRepView(iTM2PDFSYNCKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollSynchronizationPointToVisible:
- (void)scrollSynchronizationPointToVisible:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![self contextBoolForKey:iTM2PDFNoSynchronizationKey domain:iTM2ContextAllDomainsMask])
    {
        NSRect R = NSZeroRect;
        R.origin = _SynchronizationPoint;
        NSSize S = [self convertSize:NSMakeSize(15, 15) fromView:nil];
        R.origin.x -= S.width;
        R.origin.y -= S.height;
        R.size.width = 2 * S.width;
        R.size.height = 2 * S.height;
		NSRect visibleRect = [self visibleRect];
        NSRect visibleR = NSIntersectionRect(R, visibleRect);
        if(visibleR.size.width*visibleR.size.height<R.size.width*R.size.height)
            [self scrollRectToVisible:R];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateScrollSynchronizationPointToVisible:
- (BOOL)validateScrollSynchronizationPointToVisible:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSPointInRect(_SynchronizationPoint, [self bounds]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mouseDown
- (void)mouseDown:(NSEvent *)theEvent;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([theEvent clickCount] == 1)
	{
		unsigned int modifierFlags = [theEvent modifierFlags]
			& (NSAlphaShiftKeyMask
				|NSShiftKeyMask
				|NSControlKeyMask
				|NSAlternateKeyMask
				|NSCommandKeyMask
				|NSNumericPadKeyMask
				|NSHelpKeyMask
				|NSFunctionKeyMask
				|NSDeviceIndependentModifierFlagsMask);
		if((modifierFlags == NSCommandKeyMask) || !modifierFlags)
		{
			[self pdfSynchronizeMouseDown:theEvent];
			return;
		}
	}
//iTM2_LOG(@"[theEvent clickCount] is:%i", [theEvent clickCount]);
    [super mouseDown:theEvent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pdfSynchronizeMouseDown:
- (void)pdfSynchronizeMouseDown:(NSEvent *)theEvent;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[[[self window] windowController] document] synchronizeWithLocation:[self convertPoint:[theEvent locationInWindow] fromView:nil] inPageAtIndex:[self tag]-1 withHint:nil orderFront:(([theEvent modifierFlags] & NSAlternateKeyMask) == 0)];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizationCompleteDrawRect:
- (void)synchronizationCompleteDrawRect:(NSRect)rect;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![self contextBoolForKey:iTM2PDFNoSynchronizationKey domain:iTM2ContextAllDomainsMask])
    {
        NSColor * C = [[NSColor blueColor] colorWithAlphaComponent:0.3];
        NSColor * CStar = [NSColor colorWithCalibratedRed:0 green:0.5 blue:0 alpha:0.3];
		iTM2PDFDocument * D = [[[self window] windowController] document];
		iTM2PDFSynchronizer * syncer = [D synchronizer];
		if(!syncer)
		{
			[D updateSynchronizer:self];
			return;
		}
        NSDictionary * SLs = [syncer synchronizationLocationsForPageIndex:[self tag] - 1];
        if([SUD boolForKey:iTM2PDFSyncShowRecordNumberKey])
        {
            NSEnumerator * E = [SLs keyEnumerator];
            iTM2SynchronizationLocationRecord locationRecord;
            NSDictionary * D = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSFont systemFontOfSize:8], NSFontAttributeName,
                [NSColor purpleColor], NSForegroundColorAttributeName, nil];
            id K;
            while(K = [E nextObject])
            {
                NSValue * V = [SLs objectForKey:K];
                [V getValue:&locationRecord];
                NSPoint P = NSMakePoint(locationRecord.x, locationRecord.y);
                [(locationRecord.star? CStar:C) set];
                [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(P.x-2, P.y-2, 4, 4)] fill];
                [[NSString stringWithFormat:@"%@", K] drawAtPoint:P withAttributes:D];
            }
            if(NSPointInRect(_SynchronizationPoint, NSInsetRect([self bounds], 2, 2)))
            {
                [[[NSColor redColor] colorWithAlphaComponent:0.1] set];
                NSRect R = NSMakeRect(_SynchronizationPoint.x-3, _SynchronizationPoint.y-3, 6, 6);
                [[NSBezierPath bezierPathWithOvalInRect:R] fill];
                #define INSET 1.0
                #define DOUBLEINSET 2.0
                R.origin.x -= INSET;
                R.origin.y -= INSET;
                R.size.width += DOUBLEINSET;
                R.size.height += DOUBLEINSET;
                [[NSBezierPath bezierPathWithOvalInRect:R] fill];
                R.origin.x -= INSET;
                R.origin.y -= INSET;
                R.size.width += DOUBLEINSET;
                R.size.height += DOUBLEINSET;
                [[NSBezierPath bezierPathWithOvalInRect:R] fill];
                R.origin.x -= INSET;
                R.origin.y -= INSET;
                R.size.width += DOUBLEINSET;
                R.size.height += DOUBLEINSET;
                [[NSBezierPath bezierPathWithOvalInRect:R] fill];
                R.origin.x -= INSET;
                R.origin.y -= INSET;
                R.size.width += DOUBLEINSET;
                R.size.height += DOUBLEINSET;
                [[NSBezierPath bezierPathWithOvalInRect:R] fill];
            }
        }
        else
        {
            unsigned displayBulletsMode = [self contextIntegerForKey:iTM2PDFSYNCDisplayBulletsKey domain:iTM2ContextAllDomainsMask];
            NSEnumerator * E = [SLs objectEnumerator];
            iTM2SynchronizationLocationRecord locationRecord;
            NSValue * V;
            if(displayBulletsMode & kiTM2PDFSYNCDisplayUserBullets)
            {
                while(V = [E nextObject])
                {
                    [V getValue:&locationRecord];
                    NSPoint P = NSMakePoint(locationRecord.x, locationRecord.y);
                    if(locationRecord.star)
                    {
                        [CStar set];
                        [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(P.x-2, P.y-2, 4, 4)] fill];
                    }
                    else if(displayBulletsMode & kiTM2PDFSYNCDisplayBuiltInBullets)
                    {
                        [C set];
                        [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(P.x-2, P.y-2, 4, 4)] fill];
                    }
                }
            }
            if((displayBulletsMode & kiTM2PDFSYNCDisplayFocusBullets)
                    && NSPointInRect(_SynchronizationPoint, NSInsetRect([self bounds], 2, 2)))
            {
                [[[NSColor redColor] colorWithAlphaComponent:0.1] set];
                NSRect R = NSMakeRect(_SynchronizationPoint.x-3, _SynchronizationPoint.y-3, 6, 6);
                [[NSBezierPath bezierPathWithOvalInRect:R] fill];
                #define INSET 1.0
                #define DOUBLEINSET 2.0
                R.origin.x -= INSET;
                R.origin.y -= INSET;
                R.size.width += DOUBLEINSET;
                R.size.height += DOUBLEINSET;
                [[NSBezierPath bezierPathWithOvalInRect:R] fill];
                R.origin.x -= INSET;
                R.origin.y -= INSET;
                R.size.width += DOUBLEINSET;
                R.size.height += DOUBLEINSET;
                [[NSBezierPath bezierPathWithOvalInRect:R] fill];
                R.origin.x -= INSET;
                R.origin.y -= INSET;
                R.size.width += DOUBLEINSET;
                R.size.height += DOUBLEINSET;
                [[NSBezierPath bezierPathWithOvalInRect:R] fill];
                R.origin.x -= INSET;
                R.origin.y -= INSET;
                R.size.width += DOUBLEINSET;
                R.size.height += DOUBLEINSET;
                [[NSBezierPath bezierPathWithOvalInRect:R] fill];
            }
        }
    }
//iTM2_END;
	return;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSTextView_iTM2IOSynch
/*"Description forthcoming."*/
@interface NSTextView_iTM2IOSynch:NSTextView
@end

@interface NSObject(iTM2PDFSyncKit)
- (void)orderFrontCurrentSource;
@end

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

@implementation NSTextView_iTM2IOSynch
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:Thu Jul 03 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[NSTextView_iTM2IOSynch poseAsClass:[NSTextView class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super initialize];
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithBool:YES], @"iTM2PDFSYNCOrderFrontOutput",
				nil]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mouseDown:
- (void)mouseDown:(NSEvent *)event
/*"Description Forthcoming
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // this is where the support for poor man synchronicity begins
    unsigned modifierFlags = [event modifierFlags];
    if((modifierFlags & NSCommandKeyMask)>0)
	{
		if(([event clickCount]==1) && [self pdfSynchronizeMouseDown:event])
		{
			return;
		}
		else if([event clickCount]>1)
		{
			NSDocument * D = [[[self window] windowController] document];
			if([D respondsToSelector:@selector(orderFrontCurrentSource)])
			{
				[D orderFrontCurrentSource];
			}
		}
	}
	else
	{
		[super mouseDown:event];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pdfSynchronizeMouseDown:
- (BOOL)pdfSynchronizeMouseDown:(NSEvent *)event
/*"Description Forthcoming
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // this is where the support for poor man synchronicity begins
	NSWindow * window = [self window];
	if([self selectedRange].length>0)
	{
		float timeInterval = [SUD floatForKey:@"com.apple.mouse.doubleClickThreshold"];//rather big
		NSDate * date = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
		if(![window nextEventMatchingMask:NSLeftMouseUpMask untilDate:date inMode:NSEventTrackingRunLoopMode dequeue:NO])
		{
			return NO;
		}
	}
	NSDocument * D = [[window windowController] document];
	if(!D)
	{
		return NO;
	}
	NSTextStorage * TS = [self textStorage];
	NSString * S = [self string];
	NSPoint hitPoint = [event locationInWindow];
	hitPoint = [self convertPoint:hitPoint fromView:nil];
	NSLayoutManager * LM = [self layoutManager];
	NSTextContainer * TC = [self textContainer];
	unsigned int glyphIndex = [LM glyphIndexForPoint:hitPoint inTextContainer:TC];
	unsigned charIndex = [LM characterIndexForGlyphAtIndex:glyphIndex];
	unsigned start, contentsEnd;
	[TS getLineStart:&start end:nil contentsEnd:&contentsEnd forRange:NSMakeRange(charIndex, 1)];
	unsigned line = [TS lineIndexForLocation:charIndex];
	unsigned column = charIndex - start;
	NSDictionary * hint = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithUnsignedInt:charIndex], @"character index", S, @"container", nil];
	BOOL result = [SDC displayPageForLine:line column:column source:[D fileName] withHint:hint
			orderFront:(([event modifierFlags] & NSAlternateKeyMask) != 0) force:YES];
//iTM2_END;
    return result;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFSynchronizer
#import <iTM2Foundation/iTM2TextDocumentKit.h>
#import <iTM2Foundation/NSTextStorage_iTeXMac2.h>

@implementation iTM2TextInspector(PDFSYNCKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFSYNCKitWindowDidLoad
- (void)PDFSYNCKitWindowDidLoad;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:Mon Jun 30 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[DNC addObserver:self selector:@selector(PDFSYNCKit_NSTextViewDidChangeSelectionNotified:) name:NSTextViewDidChangeSelectionNotification object:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFSYNCKitCompleteDealloc
- (void)PDFSYNCKitCompleteDealloc;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:Mon Jun 30 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[DNC removeObserver:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFSYNCKit_NSTextViewDidChangeSelectionNotified:
- (void)PDFSYNCKit_NSTextViewDidChangeSelectionNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:Mon Jun 30 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSTextView * TV = [self textView];
	NSTextStorage * TS = [TV textStorage];
	NSMutableDictionary * cd = [[[SUD dictionaryForKey:@"iTM2PDFKitSync"] mutableCopy] autorelease];
	[cd addEntriesFromDictionary:[self contextDictionaryForKey:@"iTM2PDFKitSync" domain:iTM2ContextAllDomainsMask]];
	NSNumber * N = [cd objectForKey:@"FollowFocus"];
	if(([notification object] == TV) && [N respondsToSelector:@selector(boolValue)] && [N boolValue])
	{
		NSDocument * D = [self document];
		NSString * S = [TV string];
		NSRange selectedRange = [TV selectedRange];
		unsigned charIndex = selectedRange.location;
		unsigned start, contentsEnd;
		[TS getLineStart:&start end:nil contentsEnd:&contentsEnd forRange:NSMakeRange(charIndex, 0)];
		unsigned line = [TS lineIndexForLocation:charIndex];
		unsigned column = charIndex - start;
		NSValue * oldValue = [[notification userInfo] objectForKey:@"NSOldSelectedCharacterRange"];
		NSValue * newValue = [NSValue valueWithRange:selectedRange];
		NSDictionary * hint = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInt:charIndex], @"character index",
				S, @"container",
				oldValue,@"old selected range",
				newValue,@"new selected range",
					nil];
		if(![SDC displayPageForLine:line column:column source:[D fileName] withHint:hint
			orderFront:NO force:NO])// side effect:text document opens pdf document as when focus is on
		{
			// second chance to follow focus:from the visible start of the line
			NSLayoutManager * LM = [TV layoutManager];
			NSRange range = NSMakeRange(charIndex,1);
			if(charIndex < [S length])
			{
				range = [LM lineFragmentCharacterRangeForCharacterRange:range withoutAdditionalLayout:YES];
				if(range.location<charIndex)
				{
					charIndex = range.location;
					column = charIndex - start;
					hint = [NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithUnsignedInt:charIndex], @"character index",
						S, @"container",
						oldValue,@"old selected range",
						newValue,@"new selected range",
							nil];
					[SDC displayPageForLine:line column:column source:[D fileName] withHint:hint
						orderFront:NO force:NO];
				}
			}
		}
	}
//iTM2_END;
    return;
}
@end
#endif
