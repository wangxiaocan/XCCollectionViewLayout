//
//  XC_DeviceInfo.m
//  PageTest
//
//  Created by xiao can on 2019/6/11.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import "XC_DeviceInfo.h"

#import "SFHFKeychainUtils.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/utsname.h>
#import  <arpa/inet.h>

#import <ifaddrs.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>

#import <AdSupport/AdSupport.h>

#import  "sys/utsname.h"
#include <sys/socket.h> // Per msqr
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/types.h>


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


NSString *const UUID_USER_NAME = @"com.xiaocan._uuid";
NSString *const UUID_SERVICE = @"com.xiaocan._uuid_service";

@implementation XC_DeviceInfo


/** 获取唯一标识 */
+ (nonnull NSString *)getUniqueId{
    NSString * strUUID = (NSString *)[SFHFKeychainUtils getPasswordForUsername:UUID_USER_NAME andServiceName:UUID_SERVICE error:nil];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID){
        
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [SFHFKeychainUtils storeUsername:UUID_USER_NAME andPassword:strUUID forServiceName:UUID_SERVICE updateExisting:YES error:nil];
        
    }
    return strUUID;
}

/** idfa 广告标识 */
+ (nonnull NSString *)idfaString{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}


/** idfv */
+ (nonnull NSString *)idfvString{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

/** mac地址 */
+ (nonnull NSString *)macAddress{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}

/** 获取设备当前网络IP地址 */
+ (nonnull NSString *)getIPAddress:(BOOL)preferIPv4{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

/** 设备机型名称 */
+ (nonnull NSString *)modelName{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform?platform:@"unknow";
}

/** 浏览器userAgent */
+ (nonnull NSString *)userAgent{
    NSString *ua = [[NSUserDefaults standardUserDefaults] objectForKey:@"navigator.userAgent"];
    if (!ua) {
        if ([NSThread isMainThread]) {
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            NSString *useAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
            [[NSUserDefaults standardUserDefaults] setObject:useAgent forKey:@"navigator.userAgent"];
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
                NSString *useAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
                [[NSUserDefaults standardUserDefaults] setObject:useAgent forKey:@"navigator.userAgent"];
            });
        }
    }
    if (ua) {
        return ua;
    }
    return @"";
}

/** 屏幕尺⼨ */
+ (nonnull NSString *)screenSize{
    CGFloat width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    CGFloat height = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
    NSString *size = @"";
    if (width > height) {
        size = [NSString stringWithFormat:@"%.01f,%.01f",height,width];
    }else{
        size = [NSString stringWithFormat:@"%.01f,%.01f",width,height];
    }
    return size;
}

/** app名 */
+ (nonnull NSString *)appName{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    }
    if (!appName) {
        appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    }
    if (!appName) {
        appName = @"";
    }
    return appName;
}

/** 应用包名 */
+ (nonnull NSString *)appPackageName{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    
    if (!appName) {
        appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    }
    if (!appName) {
        appName = @"";
    }
    return appName;
}

/** 应用 bundleID */
+ (nonnull NSString *)appBundleId{
    NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    if (!bundleId) {
        bundleId = @"";
    }
    return bundleId;
}

/** APP版本号 */
+ (nonnull NSString *)appVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/** 设备系统版本 */
+ (nonnull NSString *)deviceVersion{
    return [UIDevice currentDevice].systemVersion;
}

/** 磁盘使用情况 */
+ (nonnull NSString *)diskUsage{
    return [NSString stringWithFormat:@"%.01lf/%.01lf",[self deviceStorageSpace:NO] / 1000.0 / 1000.0 / 1000.0,[self deviceStorageSpace:YES] / 1000.0 / 1000.0 / 1000.0];
}

/** 当前手机磁盘空间大小 ，totalSpace：YES：磁盘空间总大小，NO：磁盘剩余可用空间 */
+ (long long)deviceStorageSpace:(BOOL)totalSpace{
    //剩余空间
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpaces = (NSNumber *)[fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpaces = (NSNumber *)[fileSysAttributes objectForKey:NSFileSystemSize];
    if (totalSpace) {
        return totalSpaces.longLongValue;
    }
    return freeSpaces.longLongValue;
}

@end
