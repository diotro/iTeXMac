#import <Foundation/Foundation.h>
#import "ICURegEx.h"

@interface ICURegEx(PRIVATE)
-(int)status;
@end
int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"isValidPattern:... ----------------------------");
	NSError * localError = nil;
	if(![ICURegEx isValidPattern:@"" options:0 error:&localError] && localError)
	{
		NSLog(@"UNEXPECTED: localError:%@",localError);
	}
	if(![ICURegEx isValidPattern:@"x" options:0 error:&localError] && localError)
	{
		NSLog(@"UNEXPECTED: localError:%@",localError);
	}
	if(![ICURegEx isValidPattern:@"griboullons(x dans la mare" options:0 error:&localError] && localError)
	{
		NSLog(@"EXPECTED: localError:%@",localError);
	}
	NSLog(@"initWithSearchPattern:... ----------------------------");
	ICURegEx * RE = [[[ICURegEx alloc] initWithSearchPattern:@".\\{[`'\\^\"~=.]\\}" options:nil error:&localError] autorelease];
	if(!RE)
	{
		NSLog(@"RE unavailable");
		if(localError)
		{
			NSLog(@"UNEXPECTED: localError:%@",localError);
		}
		else
		{
			NSLog(@"UNEXPECTED: localError unavailable");
		}
		[pool release];
		return -1;
	}
	RE = [[[ICURegEx alloc] initWithSearchPattern:@".\\{)[`'\\[\\^\\\"~=.]\\)\\}" options:nil error:&localError] autorelease];
	if(RE)
	{
		NSLog(@"UNEXPECTED RE available");
		[pool release];
		return -1;
	}
	else
	{
		if(localError)
		{
			NSLog(@"EXPECTED: localError:%@",localError);
		}
		else
		{
			NSLog(@"UNEXPECTED: localError unavailable");
			[pool release];
			return -1;
		}
	}
	NSLog(@"matchesAtIndex: AND setInputString:----------------------------");
	NSString * pattern = @"a";
	RE = [[ICURegEx alloc] initWithSearchPattern:pattern options:nil error:&localError];
	NSString * inputString = @"a";
	[RE setInputString:inputString];
	NSLog(@"setInputString:\"%@\"%@\"%@\"",inputString,([inputString isEqual:[RE inputString]]?@"==":@"UNEXPECTED <>"),[RE inputString]);
	NSLog(@"pattern: %@ match string: %@ at index: 0, result: %@",pattern, inputString,([RE matchesAtIndex:0 extendToTheEnd:YES]?@"EXPECTED YES":@"UNEXPECTED NO"));
	inputString = @"bac";
	[RE setInputString:inputString];
	NSLog(@"pattern: %@ match string: %@ at index: 1, result: %@",pattern, inputString,([RE matchesAtIndex:1 extendToTheEnd:NO]?@"EXPECTED YES":@"UNEXPECTED NO"));
	inputString = @"bbacc";
	[RE setInputString:inputString range:iTM3MakeRange(1,3)];
	NSLog(@"pattern: %@ match substring: %@ range:(1,3) at index: 1, result: %@",pattern, inputString,([RE matchesAtIndex:1 extendToTheEnd:NO]?@"EXPECTED YES":@"UNEXPECTED NO"));
	NSLog(@"A create ----------------------------");
	localError = nil;
	RE = [[[ICURegEx alloc] initWithSearchPattern:@"abc+" options:nil error:&localError] autorelease];
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
		for(index=0;index<=[RE numberOfCaptureGroups];++index)
		{
			NSLog(@"group:%i, range:%@",index,NSStringFromRange([RE rangeOfCaptureGroupAtIndex:index]));
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
		for(index=0;index<=[RE numberOfCaptureGroups];++index)
		{
			NSLog(@"group:%i, range:%@",index,NSStringFromRange([RE rangeOfCaptureGroupAtIndex:index]));
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
		for(index=0;index<=[RE numberOfCaptureGroups];++index)
		{
			NSLog(@"group:%i, range:%@",index,NSStringFromRange([RE rangeOfCaptureGroupAtIndex:index]));
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
		for(index=0;index<=[RE numberOfCaptureGroups];++index)
		{
			NSLog(@"group:%i, range:%@",index,NSStringFromRange([RE rangeOfCaptureGroupAtIndex:index]));
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
	NSString * replace = @"0:/$0/\n1:/$1/\n2:/$2/";
	[RE setReplacementPattern:replace];
	NSLog(@"[RE replacementString]:%@ (%@)",[RE replacementString],replace);
	NSLog(@"[RE error]:%@",[RE error]);
#pragma mark E
	NSLog(@"E find ----------------------------");
	NSString * input = [NSString stringWithUTF8String:"ઔકખਅਆਦਤઔકખਅਆਦਤઔકખਅਆਦਤઔકખਅਆਦਤ"];
	NSError * error;
	NSMutableString * MS;
	MS = [NSMutableString stringWithString:input];
	NSLog(@"Avant:%@",MS);
	pattern = [NSString stringWithUTF8String:"(ખ..).*(ਆ+)"];
	[MS replaceOccurrencesOfICUREPattern:pattern withPattern:@"$2$1$2$1" options:0 range:iTM3MakeRange(0,MS.length) error:&error];
	NSLog(@"Apres:%@",MS);
	MS = [NSMutableString stringWithString:input];
	NSLog(@"Avant:%@",MS);
	[MS replaceOccurrencesOfICUREPattern:pattern withPattern:@"$2$1$2$1" options:0 range:iTM3MakeRange(2,MS.length-3) error:&error];
	NSLog(@"Apres:%@",MS);
#pragma mark F
	NSLog(@"F find ----------------------------");
	RE = [[[ICURegEx alloc] initWithSearchPattern:@"a(b*)(c+)" options:nil error:&localError] autorelease];
	if([RE nextMatch])
	{
		NSLog(@"un expected found: %@", NSStringFromRange([RE rangeOfMatch]));
		for(index=0;index<=[RE numberOfCaptureGroups];++index)
		{
			NSLog(@"group:%i, range:%@",index,NSStringFromRange([RE rangeOfCaptureGroupAtIndex:index]));
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
	NSString * S = [NSString stringWithUTF8String:"“‘ÁØå’”"];
	
	[pool release];
	
    return 0;
}
