#import <Foundation/Foundation.h>
#import "ICURegEx.h"

@interface ICURegEx(PRIVATE)
-(int)status;
@end
int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"A create ----------------------------");
	NSError * localError = nil;
	ICURegEx * RE = [[[ICURegEx alloc] initWithSearchPattern:@"abc+" options:nil error:&localError] autorelease];
	if(!RE)
	{
		NSLog(@"RE unavailable");
		if(localError)
		{
			NSLog(@"localError:%@",localError);
		}
		else
		{
			NSLog(@"localError unavailable");
		}
		[pool release];
		return -1;
	}
	NSLog(@"B match ----------------------------");
	[RE setInputString:@"abccccc"];
	if([RE matchesAtIndex:0 extendToTheEnd:YES])
	{
		NSLog(@"expected match");
	}
	else
	{
		NSLog(@"unexpected with error:%@ status:%i",localError, [RE status]);
	}
	[RE setInputString:@"xabccccc"];
	if([RE matchesAtIndex:0 extendToTheEnd:YES])
	{
		NSLog(@"unexpected match");
	}
	else
	{
		NSLog(@"expected with error:%@ status:%i",localError, [RE status]);
	}
	if([RE matchesAtIndex:1 extendToTheEnd:YES])
	{
		NSLog(@"expected match");
	}
	else
	{
		NSLog(@"unexpected with error:%@ status:%i",localError, [RE status]);
	}
#pragma mark C
	NSLog(@"C look ----------------------------");
	[RE setInputString:@"abccccd"];
	if([RE matchesAtIndex:0 extendToTheEnd:NO])
	{
		NSLog(@"expected look");
	}
	else
	{
		NSLog(@"unexpected with error:%@ status:%i",localError, [RE status]);
	}
	[RE setInputString:@"xabccccd"];
	if([RE matchesAtIndex:0 extendToTheEnd:NO])
	{
		NSLog(@"unexpected look");
	}
	else
	{
		NSLog(@"expected with error:%@ status:%i",localError, [RE status]);
	}
	if([RE matchesAtIndex:0 extendToTheEnd:NO])
	{
		NSLog(@"unexpected look");
	}
	else
	{
		NSLog(@"expected with error:%@ status:%i",localError, [RE status]);
	}
	if([RE matchesAtIndex:1 extendToTheEnd:NO])
	{
		NSLog(@"expected look");
	}
	else
	{
		NSLog(@"unexpected with error:%@ status:%i",localError, [RE status]);
	}
#pragma mark D
	NSLog(@"D find ----------------------------");
	int index = 0;
	RE = [[[ICURegEx alloc] initWithSearchPattern:@"a(b*)(c+)" options:nil error:&localError] autorelease];
	[RE setInputString:@"xacccyyabbczzabbeeee"];
	if([RE nextMatch])
	{
		NSLog(@"expected found: %@", NSStringFromRange([RE rangeOfMatch]));
		for(index=0;index<=[RE numberOfGroups];++index)
		{
			NSLog(@"group:%i, range:%@",index,NSStringFromRange([RE rangeOfGroupAtIndex:index]));
		}
	}
	else if([RE error])
	{
		NSLog(@"unexpected error");
	}
	else
	{
		NSLog(@"unexpected no found");
	}
	if([RE nextMatch])
	{
		NSLog(@"expected found: %@", NSStringFromRange([RE rangeOfMatch]));
		for(index=0;index<=[RE numberOfGroups];++index)
		{
			NSLog(@"group:%i, range:%@",index,NSStringFromRange([RE rangeOfGroupAtIndex:index]));
		}
	}
	else if([RE error])
	{
		NSLog(@"unexpected error");
	}
	else
	{
		NSLog(@"unexpected no found");
	}
	if([RE nextMatch])
	{
		NSLog(@"unexpected found: %@", NSStringFromRange([RE rangeOfMatch]));
		for(index=0;index<=[RE numberOfGroups];++index)
		{
			NSLog(@"group:%i, range:%@",index,NSStringFromRange([RE rangeOfGroupAtIndex:index]));
		}
	}
	else if([RE error])
	{
		NSLog(@"unexpected error");
	}
	else
	{
		NSLog(@"expected no found");
	}
	if([RE nextMatchAfterIndex:2])
	{
		NSLog(@"expected found: %@", NSStringFromRange([RE rangeOfMatch]));
		for(index=0;index<=[RE numberOfGroups];++index)
		{
			NSLog(@"group:%i, range:%@",index,NSStringFromRange([RE rangeOfGroupAtIndex:index]));
		}
	}
	else if([RE error])
	{
		NSLog(@"unexpected error");
	}
	else
	{
		NSLog(@"unexpected no found");
	}
	[RE setReplacementPattern:@"0:/$0/\n1:/$1/\n2:/$3/"];
	NSLog(@"[RE replacementString]:%@",[RE replacementString]);
	NSLog(@"[RE error]:%@",[RE error]);
#pragma mark E
	NSLog(@"E find ----------------------------");
	NSString * input = [NSString stringWithUTF8String:"ઔકખਅਆਦਤઔકખਅਆਦਤઔકખਅਆਦਤઔકખਅਆਦਤ"];
	NSError * error;
	NSMutableString * MS;
	MS = [NSMutableString stringWithString:input];
	NSLog(@"Avant:%@",MS);
	NSString * pattern = [NSString stringWithUTF8String:"(ખ..).*(ਆ+)"];
	[MS replaceOccurrencesOfICUREPattern:pattern withPattern:@"$2$1$2$1" options:0 range:NSMakeRange(0,[MS length]) error:&error];
	NSLog(@"Apres:%@",MS);
	MS = [NSMutableString stringWithString:input];
	NSLog(@"Avant:%@",MS);
	[MS replaceOccurrencesOfICUREPattern:pattern withPattern:@"$2$1$2$1" options:0 range:NSMakeRange(2,[MS length]-3) error:&error];
	NSLog(@"Apres:%@",MS);
#pragma mark F
	NSLog(@"F find ----------------------------");
	RE = [[[ICURegEx alloc] initWithSearchPattern:@"a(b*)(c+)" options:nil error:&localError] autorelease];
	if([RE nextMatch])
	{
		NSLog(@"un expected found: %@", NSStringFromRange([RE rangeOfMatch]));
		for(index=0;index<=[RE numberOfGroups];++index)
		{
			NSLog(@"group:%i, range:%@",index,NSStringFromRange([RE rangeOfGroupAtIndex:index]));
		}
	}
	else if([RE error])
	{
		NSLog(@"expected error:%@",[RE error]);
	}
	else
	{
		NSLog(@"unexpected no found");
	}
#pragma mark G
	NSString * S = [NSString * stringWithUTF8String:"“‘ÁØå’”"];
	
	[pool release];
	
    return 0;
}
