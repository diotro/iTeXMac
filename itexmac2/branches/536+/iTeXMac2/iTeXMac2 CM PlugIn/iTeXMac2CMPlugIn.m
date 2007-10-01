// =============================================================================
//	iTeXMac2CMPlugIn.m
// =============================================================================

// Uncomment ONE of these lines
//#define DEBUGSTR(s) DebugStr(s)
#define DEBUGSTR(s)

// =============================================================================

#include <CoreFoundation/CoreFoundation.h>
#include <CoreFoundation/CFPlugInCOM.h>
#include <ApplicationServices/ApplicationServices.h>
#include <Carbon/Carbon.h>
#include <CoreServices/CoreServices.h>
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>

#define iTM2_INIT_POOL NSAutoreleasePool * __P_O_O_L__ = [[NSAutoreleasePool alloc] init]
#define iTM2_RELEASE_POOL [__P_O_O_L__ release]

/*!
    @header		iTeXMac2CMPlugIn.m
    @abstract   Contextual menu implementation
    @discussion different situations are considered, with different possible actions
				- the selection is a set of tex wrappers
					- convert to folders
				- the selection is a set of folders each one containing only one project
					- convert to wrappers
				- the selection is a tex wrapper
					- convert to a folder
					- export to pdf
				- the selection is a set of files or folders with one tex wrapper
					- wrap the files or folders into the wrapper// not yet supported
				- the selection is a set of files or folders with one tex project
					- wrap the files or folders into a new wrapper// not yet supported
*/

// =============================================================================
//	typedefs, structs, consts, enums, etc.
// =============================================================================

/*#define kiTeXMac2CMPlugInFactoryID	( CFUUIDGetConstantUUIDWithBytes( NULL,		\
//																   0xC5, 0x2C, 0x25, 0x66, 0x3D, 0xC1, 0x11, 0xD5,	\
//																   0xBB, 0xA3, 0x00, 0x30, 0x65, 0xB3, 0x00, 0xBC))
// "C52C2566-3DC1-11D5-BBA3-003065B300BC"
*/
//29C781D6-A294-11D9-958B-00112476507E
//{0x29,0xC7,0x81,0xD6,0xA2,0x94,0x11,0xD9,0x95,0x8B,0x00,0x11,0x24,0x76,0x50,0x7E}
#define kiTeXMac2CMPlugInFactoryID	( CFUUIDGetConstantUUIDWithBytes( NULL,0x29,0xC7,0x81,0xD6,0xA2,0x94,0x11,0xD9,0x95,0x8B,0x00,0x11,0x24,0x76,0x50,0x7E ) )
	/*29C781D6-A294-11D9-958B-00112476507E*/


// The layout for an instance of iTeXMac2CMPlugInType.
typedef struct iTeXMac2CMPlugInType
{
	ContextualMenuInterfaceStruct	*cmInterface;
	CFUUIDRef						factoryID;
	UInt32							refCount;
} iTeXMac2CMPlugInType;

NSString * const iTeXMac2CMPlugInBundleIdentifier = @"comp.text.tex.iTeXMac2.CMPlugin";
NSString * const iTeXMac2CMPlugInTable = @"Localized";

// =============================================================================
//	local function prototypes
// =============================================================================

// =============================================================================
//	interface function prototypes
// =============================================================================
static HRESULT iTeXMac2CMPlugInQueryInterface(void* thisInstanceRef,REFIID iid,LPVOID* ppv);
static ULONG iTeXMac2CMPlugInAddRef(void *thisInstanceRef);
static ULONG iTeXMac2CMPlugInRelease(void *thisInstanceRef);

static OSStatus iTeXMac2CMPlugInExamineContext(void* thisInstanceRef,const AEDesc* inContextRef,AEDescList* outCommandPairsRef);
static OSStatus iTeXMac2CMPlugInHandleSelection(void* thisInstanceRef,AEDesc* inContextRef,SInt32 inCommandID);
static void iTeXMac2CMPlugInPostMenuCleanup( void *thisInstanceRef);

// =============================================================================
//	static (local) global variables
// =============================================================================

enum
{
	gConvertToWrapperCommandID = 1,
	gConvertToWrappersCommandID = 2,
	gConvertToFolderCommandID = 3,
	gConvertToFoldersCommandID = 4,
	gGatherInWrapperCommandID = 5,
	gGatherInNewWrapperCommandID = 6,
	gExportAsCommandID = 7
};

static NSString * gConvertToWrapperTitleFormat = nil;
static NSString * gConvertToWrappersTitleFormat = nil;
static NSString * gConvertToFolderTitleFormat = nil;
static NSString * gConvertToFoldersTitleFormat = nil;
static NSString * gGatherInWrapperTitleFormat = nil;
static NSString * gGatherInNewWrapperTitleFormat = nil;
static NSString * gExportAsTitleFormat = nil;

// =============================================================================
//	local function implementations
// =============================================================================

// -----------------------------------------------------------------------------
//	testInterfaceFtbl	definition
// -----------------------------------------------------------------------------
//	The TestInterface function table.
//
static ContextualMenuInterfaceStruct testInterfaceFtbl =
{
	// Required padding for COM
	NULL,

	// These three are the required COM functions
	iTeXMac2CMPlugInQueryInterface,
	iTeXMac2CMPlugInAddRef,
	iTeXMac2CMPlugInRelease,

	// Interface implementation
	iTeXMac2CMPlugInExamineContext,
	iTeXMac2CMPlugInHandleSelection,
	iTeXMac2CMPlugInPostMenuCleanup
};

// -----------------------------------------------------------------------------
//	iTeXMac2CMPlugInFactory
// -----------------------------------------------------------------------------
//	Implementation of the factory function for this type.
//
extern void* iTeXMac2CMPlugInFactory(CFAllocatorRef allocator,CFUUIDRef typeID );
void* iTeXMac2CMPlugInFactory(CFAllocatorRef allocator,CFUUIDRef typeID )
{
#pragma unused (allocator)

	DEBUGSTR("\p|iTeXMac2CMPlugInFactory-I-Debug;g");

	if(!gExportAsTitleFormat)
	{
		iTM2_INIT_POOL;
		NSString * proposal;
		NSString * key;
		NSBundle * B = [NSBundle bundleWithIdentifier:iTeXMac2CMPlugInBundleIdentifier];
		// initialize the titles.
		key = @"Convert \"%@\" to a TeX Wrapper";
		proposal = NSLocalizedStringFromTableInBundle(key, iTeXMac2CMPlugInTable, B, "");
		if(![proposal length]
			|| ([[proposal componentsSeparatedByString:@"%"] count] != 2)
				|| !([proposal rangeOfString:@"%@"].length))
		{// not completely safe but sufficient
			proposal = key;
			NSLog(@"*** ERROR: iTeXMac2 CM PlugIn Localization BUG, bad translation for key: %@", key);
		}
		[gConvertToWrapperTitleFormat autorelease];
		gConvertToWrapperTitleFormat = [proposal copy];
		key = @"Convert %i Folders to TeX Directories";
		proposal = NSLocalizedStringFromTableInBundle(key, iTeXMac2CMPlugInTable, B, "");
		if(![proposal length]
			|| ([[proposal componentsSeparatedByString:@"%"] count] != 2)
				|| !([proposal rangeOfString:@"%i"].length))
		{// not completely safe but sufficient
			proposal = key;
			NSLog(@"*** ERROR: iTeXMac2 CM PlugIn Localization BUG, bad translation for key: %@", key);
		}
		[gConvertToWrappersTitleFormat autorelease];
		gConvertToWrappersTitleFormat = [proposal copy];
		key = @"Convert \"%@\" to a Folder";
		proposal = NSLocalizedStringFromTableInBundle(key, iTeXMac2CMPlugInTable, B, "");
		if(![proposal length]
			|| ([[proposal componentsSeparatedByString:@"%"] count] != 2)
				|| !([proposal rangeOfString:@"%@"].length))
		{// not completely safe but sufficient
			proposal = key;
			NSLog(@"*** ERROR: iTeXMac2 CM PlugIn Localization BUG, bad translation for key: %@", key);
		}
		[gConvertToFolderTitleFormat autorelease];
		gConvertToFolderTitleFormat = [proposal copy];
		key = @"Convert %i TeX Directories to Folders";
		proposal = NSLocalizedStringFromTableInBundle(key, iTeXMac2CMPlugInTable, B, "");
		if(![proposal length]
			|| ([[proposal componentsSeparatedByString:@"%"] count] != 2)
				|| !([proposal rangeOfString:@"%i"].length))
		{// not completely safe but sufficient
			proposal = key;
			NSLog(@"*** ERROR: iTeXMac2 CM PlugIn Localization BUG, bad translation for key: %@", key);
		}
		[gConvertToFoldersTitleFormat autorelease];
		gConvertToFoldersTitleFormat = [proposal copy];
		key = @"Gather %1$i Documents in \"%2$@\"";
		proposal = NSLocalizedStringFromTableInBundle(key, iTeXMac2CMPlugInTable, B, "");
		if(![proposal length]
			|| ([[proposal componentsSeparatedByString:@"%"] count] != 3)
				|| !([proposal rangeOfString:@"%1$i"].length)
					|| !([proposal rangeOfString:@"%2$@"].length))
		{// not completely safe but sufficient
			proposal = key;
			NSLog(@"*** ERROR: iTeXMac2 CM PlugIn Localization BUG, bad translation for key: %@", key);
		}
		[gGatherInWrapperTitleFormat autorelease];
		gGatherInWrapperTitleFormat = [proposal copy];
		key = @"New TeX Directory for %i Documents";
		proposal = NSLocalizedStringFromTableInBundle(key, iTeXMac2CMPlugInTable, B, "");
		if(![proposal length]
			|| ([[proposal componentsSeparatedByString:@"%"] count] != 2)
				|| !([proposal rangeOfString:@"%i"].length))
		{// not completely safe but sufficient
			proposal = key;
			NSLog(@"*** ERROR: iTeXMac2 CM PlugIn Localization BUG, bad translation for key: %@", key);
		}
		[gGatherInNewWrapperTitleFormat autorelease];
		gGatherInNewWrapperTitleFormat = [proposal copy];
		key = @"Export \"%@\" As \"%@\"";
		proposal = NSLocalizedStringFromTableInBundle(key, iTeXMac2CMPlugInTable, B, "");
		if(![proposal length]
			|| ([[proposal componentsSeparatedByString:@"%"] count] != 3)
				|| !([proposal rangeOfString:@"%@"].length))
		{// not completely safe but sufficient
			proposal = key;
			NSLog(@"*** ERROR: iTeXMac2 CM PlugIn Localization BUG, bad translation for key: %@", key);
		}
		[gExportAsTitleFormat autorelease];
		gExportAsTitleFormat = [proposal copy];
		iTM2_RELEASE_POOL;
	}

	// If correct type is being requested, allocate an
	// instance of TestType and return the IUnknown interface.
	if ( CFEqual( typeID, kContextualMenuTypeID ) )
	{
		iTeXMac2CMPlugInType *result;
		// Allocate memory for the new instance.

		DEBUGSTR("\p|iTeXMac2AllocCMPlugInType-I-Debug;g");

		result = (iTeXMac2CMPlugInType*) malloc(sizeof( iTeXMac2CMPlugInType ) );

		// Point to the function table
		result->cmInterface = &testInterfaceFtbl;

		// Retain and keep an open instance refcount<
		// for each factory.
		result->factoryID = CFRetain( kiTeXMac2CMPlugInFactoryID );
		CFPlugInAddInstanceForFactory( kiTeXMac2CMPlugInFactoryID );

		// This function returns the IUnknown interface
		// so set the refCount to one.
		result->refCount = 1;
		return result;
	}
	else
	{
		// If the requested type is incorrect, return NULL.
		return NULL;
	}
}

// -----------------------------------------------------------------------------
//	iTeXMac2AddCommandToAEDescList
// -----------------------------------------------------------------------------
static OSStatus iTeXMac2AddCommandToAEDescList(NSString *	commandName,
												SInt32		inCommandID,
												AEDescList*	ioCommandListRef)
{
	OSStatus thereIsAnError = noErr;
	unsigned int length = [commandName length];
	unichar * characters = (unichar *)NewPtr(sizeof(unichar)*length);
	[commandName getCharacters:characters range:NSMakeRange(0, length)];
	if (!characters)
		return noErr;

	// create an apple event record for our command

	AERecord commandRecord = { typeNull, NULL };
	thereIsAnError = AECreateList( NULL, 0, true, &commandRecord );
	require_noerr( thereIsAnError, iTeXMac2AddCommandToAEDescList_fail );

	// stick the command text into the aerecord
	thereIsAnError = AEPutKeyPtr( &commandRecord, keyAEName, typeUnicodeText, characters, length * sizeof(unichar));
	require_noerr( thereIsAnError, iTeXMac2AddCommandToAEDescList_fail );

	// stick the command ID into the AERecord
	thereIsAnError = AEPutKeyPtr( &commandRecord, keyContextualMenuCommandID, typeLongInteger, &inCommandID, sizeof( inCommandID ) );
	require_noerr( thereIsAnError, iTeXMac2AddCommandToAEDescList_fail );

	// stick this record into the list of commands that we are
	// passing back to the CMM
	thereIsAnError = AEPutDesc(ioCommandListRef, 			// the list we're putting our command into
				   0, 						// stick this command onto the end of our list
				   &commandRecord );	// the command I'm putting into the list

iTeXMac2AddCommandToAEDescList_fail:
		// clean up after ourself; dispose of the AERecord
	AEDisposeDesc( &commandRecord );
	DisposePtr((Ptr)characters);
    return thereIsAnError;

} // iTeXMac2AddCommandToAEDescList

static NSMutableArray * wrappers = nil;
static NSMutableArray * projects = nil;
static NSMutableArray * folders = nil;// eligible to wrappers!
static NSMutableArray * others = nil;

// -----------------------------------------------------------------------------
//	_iTeXMac2CMPlugInCreateSubmenu
// -----------------------------------------------------------------------------
static OSStatus _iTeXMac2CMPlugInCreateSubmenu(void * thisInstanceRef, const AEDescList* inContextRef, AEDescList* ioCommandListRef)
{
//NSLog(@"*** AEDescList? %4.4s", &(inContextRef->descriptorType));
	// inContextRef is expected to be a ref to the descriptor of a list
	OSStatus error = noErr;
	long theCount = 0;
	error = AECountItems(inContextRef, &theCount);
	if(error)
		return error;
	iTM2_INIT_POOL;
	[wrappers release];
	wrappers = [[NSMutableArray alloc] initWithCapacity:theCount+1];
	[projects release];
	projects = [[NSMutableArray alloc] initWithCapacity:theCount+1];
	[folders release];
	folders = [[NSMutableArray alloc] initWithCapacity:theCount+1];// eligible to wrappers!
	[others release];
	others = [[NSMutableArray alloc] initWithCapacity:theCount+1];
	long index = theCount;
	while(index)
	{
		AEDesc result = {typeNull, NULL};
		AEKeyword theAEKeyword;
		error = AEGetNthDesc(inContextRef, index, typeWildCard, &theAEKeyword, &result);
		if(error)
		{
			NSLog(@"*** could not get the descriptor %i/%i (error: %i)", index, theCount, error);
		}
		else
		{
			AEDesc coerced = {typeNull, NULL};
			error = AECoerceDesc(&result, typeFSRef, &coerced);
			if(error)
			{
				NSLog(@"*** could not coerce to typeFSRef from %4.4s (error: %i)", &(result.descriptorType), error);
			}
			else
			{
				FSRef ref;
				error = AEGetDescData(&coerced, &ref, sizeof(FSRef));
				if(error)
				{
					NSLog(@"*** could not get FSRef (error: %i)", error);
				}
				else
				{
					UInt32 maxPathSize = 1024;
					UInt8 * path;
					if(path = malloc(maxPathSize * sizeof(UInt8)))
					{
						error = FSRefMakePath(&ref, path, maxPathSize);
						if(error)
						{
							NSLog(@"*** could not convert a FSRef to a path (error: %i)", error);
						}
						else
						{
							NSString * P = [NSString stringWithUTF8String: (char *) path];
							if([[[P pathExtension] lowercaseString] isEqualToString:@"texd"])
								[wrappers addObject:P];
							else if([[[P pathExtension] lowercaseString] isEqualToString:@"texp"])
								[projects addObject:P];
							else
							{
								NSFileManager * DFM = [NSFileManager defaultManager];
								BOOL isDirectory;
								if([DFM fileExistsAtPath:P isDirectory: &isDirectory] && isDirectory)
								{
									NSMutableArray * mra = [NSMutableArray array];
									NSEnumerator * E = [[DFM directoryContentsAtPath:P] objectEnumerator];
									NSString * p;
									while(p = [E nextObject])
										if([[[p pathExtension] lowercaseString] isEqualToString:@"texp"])
											[mra addObject:p];
									[(([mra count] == 1)? folders:others) addObject:P];
								}
								else
									[others addObject:P];
							}
						}
					}
				}
			}
			AEDisposeDesc(&coerced);
		}
		AEDisposeDesc(&result);
		--index;
	}
#if __iTM2_DEVELOPMENT__
	NSLog(@"wrappers are: %@", wrappers);
	NSLog(@"projects are: %@", projects);
	NSLog(@"folders are: %@", folders);
	NSLog(@"others are: %@", others);
#endif
	// if we have only wrappers, propose to convert them to folders
	if([wrappers count] && ![projects count] && ![folders count] && ![others count])
	{
		long commandID = 0L;
		NSString * title = @"";
		if([wrappers count]>1)
		{
			commandID = gConvertToFoldersCommandID;
			title = [NSString stringWithFormat:gConvertToFoldersTitleFormat, [wrappers count]];
		}
		else
		{
			commandID = gConvertToFolderCommandID;
			title = [NSString stringWithFormat: gConvertToFolderTitleFormat,
				[[NSFileManager defaultManager] displayNameAtPath:[wrappers objectAtIndex:0]]];
			
		}
		iTeXMac2AddCommandToAEDescList(title, commandID, ioCommandListRef);
		iTeXMac2AddCommandToAEDescList(@"-", 0, ioCommandListRef);
	}
	else if(![wrappers count] && ![projects count] && [folders count] && ![others count])
	{
		long commandID = 0L;
		NSString * title = @"";
		if([folders count]>1)
		{
			commandID = gConvertToWrappersCommandID;
			title = [NSString stringWithFormat:gConvertToWrappersTitleFormat, [folders count]];
		}
		else
		{
			commandID = gConvertToWrapperCommandID;
			title = [NSString stringWithFormat: gConvertToWrapperTitleFormat,
				[[NSFileManager defaultManager] displayNameAtPath:[folders objectAtIndex:0]]];
			
		}
		iTeXMac2AddCommandToAEDescList(title, commandID, ioCommandListRef);
		iTeXMac2AddCommandToAEDescList(@"-", 0, ioCommandListRef);
	}
	else 
	{
		// nothing in that context
		iTM2_RELEASE_POOL;
		return noErr;
	}
/*
enum
{
	gConvertToWrapperCommandID = 1,
	gConvertToWrappersCommandID = 2,
	gConvertToFolderCommandID = 3,
	gConvertToFoldersCommandID = 4,
	gGatherInWrapperCommandID = 5,
	gGatherInNewWrapperCommandID = 6,
	gExportAsCommandID = 7
};
static NSString * gConvertToWrapperTitleFormat = nil;
static NSString * gConvertToWrappersTitleFormat = nil;
static NSString * gConvertToFolderTitleFormat = nil;
static NSString * gConvertToFoldersTitleFormat = nil;
static NSString * gGatherInWrapperTitleFormat = nil;
static NSString * gGatherInNewWrapperTitleFormat = nil;
static NSString * gExportAsTitleFormat = nil;
*/

	iTM2_RELEASE_POOL;
	return error;
} // _iTeXMac2CMPlugInCreateSubmenu

// =============================================================================
//	interface function implementations
// =============================================================================

// -----------------------------------------------------------------------------
//	iTeXMac2CMPlugInQueryInterface
// -----------------------------------------------------------------------------
//	Implementation of the IUnknown QueryInterface function.
//
static HRESULT iTeXMac2CMPlugInQueryInterface(void* thisInstanceRef,REFIID iid,LPVOID* ppv)
{
	// Create a CoreFoundation UUIDRef for the requested interface.
	CFUUIDRef	interfaceID = CFUUIDCreateFromUUIDBytes( NULL, iid );

	DEBUGSTR("\p|iTeXMac2CMPlugInQueryInterface-I-Debug;g");

	// Test the requested ID against the valid interfaces.
	if ( CFEqual( interfaceID, kContextualMenuInterfaceID ) )
	{
		// If the TestInterface was requested, bump the ref count,
		// set the ppv parameter equal to the instance, and
		// return good status.
  //		((iTeXMac2CMPlugInType*) thisInstanceRef)->cmInterface->AddRef(thisInstanceRef);
		iTeXMac2CMPlugInAddRef(thisInstanceRef);

		*ppv = thisInstanceRef;
		CFRelease( interfaceID );
		return S_OK;
	}
	else if ( CFEqual( interfaceID, IUnknownUUID ) )
	{
		// If the IUnknown interface was requested, same as above.
  //		( ( iTeXMac2CMPlugInType* ) thisInstanceRef)->cmInterface->AddRef(thisInstanceRef);
		iTeXMac2CMPlugInAddRef(thisInstanceRef);

		*ppv = thisInstanceRef;
		CFRelease( interfaceID );
		return S_OK;
	}
	else
	{
		// Requested interface unknown, bail with error.
		*ppv = NULL;
		CFRelease( interfaceID );
		return E_NOINTERFACE;
	}
}

// -----------------------------------------------------------------------------
//	iTeXMac2CMPlugInAddRef
// -----------------------------------------------------------------------------
//	Implementation of reference counting for this type. Whenever an interface
//	is requested, bump the refCount for the instance. NOTE: returning the
//	refcount is a convention but is not required so don't rely on it.
//
static ULONG iTeXMac2CMPlugInAddRef( void *thisInstanceRef)
{
	DEBUGSTR("\p|iTeXMac2CMPlugInAddRef-I-Debug;g");

	( ( iTeXMac2CMPlugInType* ) thisInstanceRef)->refCount += 1;
	return ( ( iTeXMac2CMPlugInType* ) thisInstanceRef)->refCount;
}

// -----------------------------------------------------------------------------
// iTeXMac2CMPlugInRelease
// -----------------------------------------------------------------------------
//	When an interface is released, decrement the refCount.
//	If the refCount goes to zero, deallocate the instance.
//
static ULONG iTeXMac2CMPlugInRelease( void *thisInstanceRef)
{
	DEBUGSTR("\p|iTeXMac2CMPlugInRelease-I-Debug;g");

	((iTeXMac2CMPlugInType*) thisInstanceRef)->refCount -= 1;
	if (((iTeXMac2CMPlugInType*) thisInstanceRef)->refCount == 0)
	{
		CFUUIDRef	theFactoryID = ((iTeXMac2CMPlugInType*) thisInstanceRef)->factoryID;
		free( thisInstanceRef);
		if ( theFactoryID )
		{
			CFPlugInRemoveInstanceForFactory( theFactoryID );
			CFRelease( theFactoryID );
		}
		return 0;
	}
	else
	{
		return ((iTeXMac2CMPlugInType*) thisInstanceRef)->refCount;
	}
}

// -----------------------------------------------------------------------------
//	iTeXMac2CMPlugInExamineContext
// -----------------------------------------------------------------------------
//	The implementation of the ExamineContext test interface function.
//

static OSStatus iTeXMac2CMPlugInExamineContext(	void*				thisInstanceRef,
											  const AEDesc*			inContextRef,
											  AEDescList*			outCommandPairsRef)
{
	if(!inContextRef)
		return errAENotAEDesc;
	if(!inContextRef->descriptorType)
		return errAENotAEDesc;
	// the contextual menu depends on the number and kind of selected items
	// if there is no selected item or if there is mode than one selected item
	// nothing happens,
	if (inContextRef->descriptorType == typeAEList)
	{
		return _iTeXMac2CMPlugInCreateSubmenu(thisInstanceRef, inContextRef, outCommandPairsRef);
	}
	else
	{
		AEDesc coercedContext = { typeNull, NULL };
		OSErr error = AECoerceDesc( inContextRef, typeAEList, &coercedContext );
		if(!error)
		{
			_iTeXMac2CMPlugInCreateSubmenu(thisInstanceRef, &coercedContext,outCommandPairsRef);
			return error;
		}
		AEDisposeDesc(&coercedContext);
		return error;
	}
	return noErr;
}

// -----------------------------------------------------------------------------
//	HandleSelection
// -----------------------------------------------------------------------------
//	The implementation of the HandleSelection test interface function.
//
static OSStatus iTeXMac2CMPlugInHandleSelection(void*				thisInstanceRef,
											  AEDesc*				inContextRef,
											  SInt32				inCommandID )
{
//printf("\niTeXMac2CMPlugIn->iTeXMac2CMPlugInHandleSelection(instance: 0x%lx, inContextRef: 0x%lx, inCommandID: 0x%lx)",
//		( SInt32 ) thisInstanceRef,
//		( SInt32 ) inContextRef,
//		( SInt32 ) inCommandID );

	// this is a quick sample that looks for text in the context descriptor

	// make sure the descriptor isn't null
	OSStatus	thereIsAnError = noErr;
	if ( inContextRef != NULL )
	{
#pragma unused (inContextRef)
		iTM2_INIT_POOL;
		switch (inCommandID)
		{
			case gConvertToWrapperCommandID:
			case gConvertToWrappersCommandID:
			{
				NSFileManager * DFM = [NSFileManager defaultManager];
				NSEnumerator * E = [folders objectEnumerator];
				NSString * src;
				BOOL notAll = NO;
				while(src = [E nextObject])
				{
					NSString * dest = [src stringByAppendingPathExtension:@"texd"];
					if([DFM fileExistsAtPath:dest])
					{
						notAll = YES;
						NSLog(@"INFO: iTeXMac2 CM PlugIn, File already existing at %@", dest);
					}
					else if([DFM movePath:src toPath:dest handler:nil])
					{
						NSLog(@"INFO: iTeXMac2 CM PlugIn\n%@ moved to %@", src, dest);
						[[NSWorkspace sharedWorkspace] noteFileSystemChanged:src];
						[[NSWorkspace sharedWorkspace] noteFileSystemChanged:dest];
					}
					else
					{
						NSLog(@"*** ERROR: iTeXMac2 CM PlugIn, Problem when moving\n%@ to %@", src, dest);
					}
				}
				if(notAll)
				{
					NSRunCriticalAlertPanel(
						NSLocalizedStringFromTableInBundle(@"Problem", iTeXMac2CMPlugInTable, [NSBundle bundleWithIdentifier:iTeXMac2CMPlugInBundleIdentifier], ""),
						NSLocalizedStringFromTableInBundle(@"Could not convert all the files", iTeXMac2CMPlugInTable, [NSBundle bundleWithIdentifier:iTeXMac2CMPlugInBundleIdentifier], ""),
						nil, nil, nil, nil);
				}
				break;
			}
			case gConvertToFolderCommandID:
			case gConvertToFoldersCommandID:
			{
//NSLog(@"gConvertToFolderCommandID");
				NSFileManager * DFM = [NSFileManager defaultManager];
				NSEnumerator * E = [wrappers objectEnumerator];
				NSString * src;
				BOOL notAll = NO;
				while(src = [E nextObject])
				{
					NSString * dest = [src stringByDeletingPathExtension];
					if([DFM fileExistsAtPath:dest])
					{
						notAll = YES;
						NSLog(@"INFO: iTeXMac2 CM PlugIn, File already existing at %@", dest);
					}
					else if([DFM movePath:src toPath:dest handler:nil])	
					{
						NSLog(@"INFO: iTeXMac2 CM PlugIn\n%@ moved to %@", src, dest);
						[[NSWorkspace sharedWorkspace] noteFileSystemChanged:src];
						[[NSWorkspace sharedWorkspace] noteFileSystemChanged:dest];
					}
					else	
					{
						NSLog(@"*** ERROR: iTeXMac2 CM PlugIn, Problem when moving %@ to %@", src, dest);
					}
				}
				if(notAll)
				{// leaking:
					NSRunCriticalAlertPanel(
						NSLocalizedStringFromTableInBundle(@"Problem", iTeXMac2CMPlugInTable, [NSBundle bundleWithIdentifier:iTeXMac2CMPlugInBundleIdentifier], ""),
						NSLocalizedStringFromTableInBundle(@"Could not convert all the files", iTeXMac2CMPlugInTable, [NSBundle bundleWithIdentifier:iTeXMac2CMPlugInBundleIdentifier], ""),
						nil, nil, nil, nil);
				}
				break;
			}
			case gGatherInWrapperCommandID:
				printf("\n\"gGatherInWrapperCommandID\""); break;
			case gGatherInNewWrapperCommandID:
				printf("\n\"gGatherInNewWrapperCommandID\""); break;
			case gExportAsCommandID:
				printf("\n\"gExportAsCommandID\""); break;
			default:
				printf("UNKNOWN command id: %li",inCommandID); break;
		}
		iTM2_RELEASE_POOL;
	}
	else
	{
		printf("\niTeXMac2CMPlugInHandleSelection: Hey! What's up with the NULL descriptor?" );
	}

	return thereIsAnError;
}	// iTeXMac2CMPlugInHandleSelection

// -----------------------------------------------------------------------------
//	PostMenuCleanup
// -----------------------------------------------------------------------------
//	The implementation of the PostMenuCleanup test interface function.
//
static void iTeXMac2CMPlugInPostMenuCleanup( void *thisInstanceRef)
{
	[wrappers release];
	wrappers = nil;
	[projects release];
	projects = nil;
	[folders release];
	folders = nil;
	[others release];
	others = nil;
}
