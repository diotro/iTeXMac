//
//  iTM2HelpSupport.m
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

#import "iTM2HelpSupport.h"

@interface iTM2MailController:iTM2Inspector
+ (id)sharedMailController;
- (void)mailForHelp;
- (NSString *)mailSender;
- (void)setMailSender:(NSString *)mailSender;
- (NSTextView *)textView;
- (void)setTextView:(NSTextView *)textView;
- (BOOL)canSend;
- (void)setCanSend:(BOOL)yorn;
@end
static iTM2MailController * iTM2_sharedMailController;
@implementation iTM2MailController
+ (id)sharedMailController;
{
	return iTM2_sharedMailController?:(iTM2_sharedMailController = [[self alloc] initWithWindowNibName:NSStringFromClass(self)]);
}
- (id)initWithWindow:(NSWindow *)window;
{
	if(iTM2_sharedMailController)
	{
		[self dealloc];
		return [iTM2_sharedMailController retain];
	}
	else if(self = [super initWithWindow:window])
	{
		ABPerson *myself = [[ABAddressBook sharedAddressBook] me];
		ABMultiValue * mailProperty = [myself valueForProperty:kABEmailProperty];
		NSString * primaryIdentifier = [mailProperty primaryIdentifier];
		int emailIndex = [mailProperty indexForIdentifier: primaryIdentifier]; 
		NSString * mailSender = [mailProperty valueAtIndex: emailIndex];
		[self setMailSender:mailSender];
		[self setCanSend:YES];
	}
	return iTM2_sharedMailController = self;
}
- (void)mailForHelp;
{
	[[self window] makeKeyAndOrderFront:self];
	return;
}
- (NSTextView *)textView;
{
	return metaGETTER;
}
- (void)setTextView:(NSTextView *)textView;
{
	metaSETTER(textView);
	return;
}
- (NSString *)mailSender;
{
	return metaGETTER;
}
- (void)setMailSender:(NSString *)mailSender;
{
	metaSETTER(mailSender);
	return;
}
- (IBAction)close:(id)sender;
{
	[self close];
}
- (BOOL)canSend;
{
	return [NSMailDelivery hasDeliveryClassBeenConfigured] && [metaGETTER boolValue];
}
- (void)setCanSend:(BOOL)yorn;
{
	metaSETTER([NSNumber numberWithBool:yorn]);
	return;
}
- (IBAction)send:(id)sender;
{
	if(![NSMailDelivery hasDeliveryClassBeenConfigured])
	{
		NSBeep();
		[self close];
	}
	else
	{
		NSMutableDictionary *headers = [NSMutableDictionary dictionary];
		NSString * mailSender = [self mailSender];
		[headers setObject: (mailSender?:@"iTeXMac2_User") forKey:@"From"];
		[headers setObject: @"jlaurens@users.sourceforge.net" forKey:@"To"];
		[headers setObject: @"iTeXMac2 Help Request" forKey:@"Subject"];
		[headers setObject: @"Apple Message" forKey:@"X-Mailer"];
		[headers setObject: @"multipart/mixed" forKey:@"Content-Type"];
		[headers setObject: @"1.0" forKey:@"Mime-Version"];
		if(![NSMailDelivery deliverMessage: [[self textView] textStorage]
										headers: headers
										 format: NSMIMEMailFormat
									   protocol: NSSMTPDeliveryProtocol])
		{
			NSBeep();
			[self setCanSend:NO];
		}
	}
	[self close];
	return;
}
@end

@implementation iTM2Application(iTM2HelpSupport)
- (IBAction)mailForHelp:(id)sender;
{
	[[iTM2MailController sharedMailController] mailForHelp];
	return;
}
@end
