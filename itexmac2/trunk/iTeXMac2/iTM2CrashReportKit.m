//
//  iTM2CrashReportKit.m
//  iTeXMac2
//
//  @version 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A pARTICULAR pURPOSE.
//  See the GNU General public License for more details. You should have received a copy
//  of the GNU General public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
//

#import "iTM2CrashReportKit.h"
#import <AddressBook/AddressBook.h>
#import "Mail.h"

@interface iTM2CrashReportController:NSWindowController
{
@private
	NSString * _crashDescription;
	NSString * _crashLog;
	NSString * _consoleLog;
	BOOL _dontSendConsole;
	BOOL _dontSendReport;
	BOOL _isSending;
}
@property (retain) NSString * _crashDescription;
@property (retain) NSString * _crashLog;
@property (retain) NSString * _consoleLog;
@property BOOL _dontSendConsole;
@property BOOL _dontSendReport;
@property BOOL _isSending;
@end


@implementation NSBundle(iTM2CrashReportKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  reportCrashIfNeeded
+ (void)reportCrashIfNeeded;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2CrashReportController * WC = [[[iTM2CrashReportController alloc] initWithWindowNibName:NSStringFromClass([iTM2CrashReportController class])] autorelease];
	NSWindow * window = [WC window];
	[window makeKeyAndOrderFront:self];
//iTM2_END;
    return;
}
@end


@implementation iTM2CrashReportController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
- (id)initWithWindow:(NSWindow *)aWindow;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDate * lastCrashDate = [SUD valueForKey: @"iTM2LastCrashDate"];
	if(!lastCrashDate)
	{
		lastCrashDate = [SUD valueForKey: @"HDCrashReporter.lastCrashDate"];
	}
	NSArray *libraries = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask,YES);
	NSString * logsPath = [libraries lastObject];
	logsPath = [logsPath stringByAppendingPathComponent:@"Logs"];
	NSString * crashPath = [logsPath stringByAppendingPathComponent:@"CrashReporter"];
	NSBundle * mainBundle = [NSBundle mainBundle];
	NSString * name = [mainBundle objectForInfoDictionaryKey:(NSString *)kCFBundleExecutableKey];
	crashPath = [crashPath stringByAppendingPathComponent:name];
	crashPath = [crashPath stringByAppendingPathExtension:@"crash"];
	crashPath = [crashPath stringByAppendingPathExtension:@"log"];
	id attributes = [DFM fileAttributesAtPath:crashPath traverseLink: YES];
	NSDate * modificationDate = [attributes fileModificationDate];
	[SUD setValue:nil forKey:@"HDCrashReporter.lastCrashDate"];
	[SUD setValue:modificationDate forKey:@"iTM2LastCrashDate"];
	if(modificationDate)
	{
		if(!lastCrashDate || ([lastCrashDate compare:modificationDate] == NSOrderedAscending))
		{
			NSString * consoleDir = [logsPath stringByAppendingPathComponent:name];
			
			NSArray * availableLogs = [DFM contentsOfDirectoryAtPath:consoleDir error:NULL];
			NSString * component;
			NSMutableArray * files = [NSMutableArray array];
			for(component in availableLogs)
			{
				NSString * fullPath = [consoleDir stringByAppendingPathComponent:component];
				attributes = [DFM fileAttributesAtPath:fullPath traverseLink: YES];
				NSDate * date = [attributes fileModificationDate];
				if([date compare:modificationDate] == NSOrderedAscending)
				{
					attributes = [[attributes mutableCopy] autorelease];
					[attributes setObject:fullPath forKey:@"file name"];
					[files addObject:attributes];
				}
			}
			if([files count])
			{
				NSSortDescriptor * descriptor  = [[[NSSortDescriptor alloc] initWithKey:NSFileModificationDate ascending:YES] autorelease];
				NSArray * descriptors = [NSArray arrayWithObject:descriptor];
				[files sortUsingDescriptors:descriptors];
				attributes = [files lastObject];
				NSString * consolePath = [attributes objectForKey:@"file name"];
				
				if(self = [super initWithWindow:aWindow])
				{
					// the crash log
					NSString * crashLog = [NSString stringWithContentsOfFile:crashPath encoding:NSUTF8StringEncoding error:NULL];
					NSArray * crashLogs = [crashLog componentsSeparatedByString: @"**********"];
					[_crashLog autorelease];
					_crashLog = [[crashLogs lastObject] copy];
					[_consoleLog autorelease];
					_consoleLog = [[NSString stringWithContentsOfFile:consolePath encoding:NSUTF8StringEncoding error:NULL] copy];
				}
				return [self retain];// will be released by itself when closing
			}
		}
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_windowPositionShouldBeObserved
- (BOOL)iTM2_windowPositionShouldBeObserved;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  send:
- (IBAction)send:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[sender window] makeFirstResponder:nil];
	NSNumber * N = [NSNumber numberWithBool:YES];
	[self setValue:N forKey:@"isSending"];
	NSString *email = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"iTM2CompanyEmail"];
	if (!email)
	{
		NSLog (@"crash reported: did not find email address");
		NSBeep();
		return;
	}
	NSString * body = _crashDescription?:@"";
	if(!_dontSendReport)
	{
		body = [body stringByAppendingString:@"\n==============\n\n"];
		body = [body stringByAppendingString:_crashLog];
	}
	if(!_dontSendConsole)
	{
		body = [body stringByAppendingString:@"\n==============\n\n"];
		body = [body stringByAppendingString:_consoleLog];
	}
	
	NSString * subject = @"iTeXMac2 crash report";
#	if 1
	ABPerson * me = [[ABAddressBook sharedAddressBook] me];
	id Email = [me valueForProperty: kABEmailProperty];
	id primaryIdentifier = [Email primaryIdentifier];
	/* FROM apple sample code SBSendEmail */
	/* create a Scripting Bridge object for talking to the Mail application */
    MailApplication *mail = [SBApplication applicationWithBundleIdentifier:@"com.apple.Mail"];
    
	/* create a new outgoing message object */
    MailOutgoingMessage *emailMessage =	[[[[mail classForScriptingClass:@"outgoing message"] alloc] initWithProperties:
										 [NSDictionary dictionaryWithObjectsAndKeys:
										  subject, @"subject",
										  body, @"content",
										  nil]] autorelease];
	
	/* add the object to the mail app  */
    [[mail outgoingMessages] addObject: emailMessage];
	
	/* set the sender, show the message */
    emailMessage.sender = (primaryIdentifier?:@"iTeXMac2_User");
    emailMessage.visible = YES;
	
	/* create a new recipient and add it to the recipients list */
    MailToRecipient *theRecipient =	[[[[mail classForScriptingClass:@"to recipient"] alloc]
									 initWithProperties: [NSDictionary dictionaryWithObjectsAndKeys:
										email, @"address",
														  nil]] autorelease];
    [emailMessage.toRecipients addObject: theRecipient];
    
	
	/* send the message */
    [emailMessage send];
#	else
	BOOL result = NO;
	if ([NSMailDelivery hasDeliveryClassBeenConfigured])
	{  
		ABPerson * me = [[ABAddressBook sharedAddressBook] me];
		id Email = [me valueForProperty: kABEmailProperty];
		id primaryIdentifier = [Email primaryIdentifier];
		NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:
			primaryIdentifier,@"From",
			email,@"To",
			subject,@"Subject",
			@"Apple Message",@"X-Mailer",
			@"multipart/mixed",@"Content-Type",
			@"1.0",@"Mime-Version",
				nil];

		NSAttributedString * AS = [[[NSAttributedString alloc] initWithString:body] autorelease];
		result = [NSMailDelivery deliverMessage: AS
										headers: headers
										 format: NSMIMEMailFormat
									   protocol: NSSMTPDeliveryProtocol];
	}
	if(!result)
	{
		email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		subject = [subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		body = [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString * encodedURLString = [NSString stringWithFormat:@"mailto:%@?SUBJECT=%@&BODY=%@", email, subject, body];
		if (encodedURLString)
		{
			NSURL * url = [NSURL URLWithString: encodedURLString];
			result = [[NSWorkspace sharedWorkspace] openURL:url];
		}
	}
	if(result)
	{
		 ;
	}
#	endif
	[self close];
	[self autorelease];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ignore:
- (IBAction)ignore:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self autorelease];
	[self close];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  consoleColor
- (NSColor *)consoleColor;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return _dontSendConsole? [NSColor disabledControlTextColor]:[NSColor controlTextColor];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  reportColor
- (NSColor *)reportColor;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return _dontSendReport? [NSColor disabledControlTextColor]:[NSColor controlTextColor];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDontSendConsole:
- (void)setDontSendConsole:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self willChangeValueForKey:@"consoleColor"];
	[self willChangeValueForKey:@"dontSendConsole"];
	_dontSendConsole = yorn;
	[self didChangeValueForKey:@"dontSendConsole"];
	[self didChangeValueForKey:@"consoleColor"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDontSendReport:
- (void)setDontSendReport:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self willChangeValueForKey:@"reportColor"];
	[self willChangeValueForKey:@"dontSendReport"];
	_dontSendReport = yorn;
	[self didChangeValueForKey:@"dontSendReport"];
	[self didChangeValueForKey:@"reportColor"];
//iTM2_END;
    return;
}
@synthesize _crashDescription;
@synthesize _crashLog;
@synthesize _consoleLog;
@synthesize _dontSendConsole;
@synthesize _dontSendReport;
@synthesize _isSending;
@end

