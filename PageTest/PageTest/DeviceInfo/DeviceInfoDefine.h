//
//   DeviceInfoDefine.h
//   PageTest
//
//   Created by xiao can on 2019/6/11.
//   Copyright © 2019 xiaocan. All rights reserved.
//


#ifndef DeviceInfoDefine_h
#define DeviceInfoDefine_h


/** 唯一ID */
#define XC_UNIQUE_ID            [XC_DeviceInfo getUniqueId]

/** idfa */
#define XC_IDFA                 [XC_DeviceInfo idfaString]

/** idfv */
#define XC_IDFV                 [XC_DeviceInfo idfvString]

/**  mac 地址 */
#define XC_MAC_ADDRESS          [XC_DeviceInfo macAddress]

/** ipv4 地址 */
#define XC_IPV4_ADDRESS         [XC_DeviceInfo getIPAddress:YES]

/** ipv6 地址 */
#define XC_IPV6_ADDRESS         [XC_DeviceInfo getIPAddress:NO]

/** 设备型号名称 如：iPhone10,1 */
#define XC_MODEL_NAME           [XC_DeviceInfo modelName]

/** 浏览器 User-Agent */
#define XC_USER_AGENT           [XC_DeviceInfo userAgent]

/** 设备宽高，如 750.0,1334.0 */
#define XC_SCREEN_SIZE          [XC_DeviceInfo screenSize]

/** 应用名称 */
#define XC_APP_NAME             [XC_DeviceInfo appName]

/** 应用包名 */
#define XC_APP_PACKAGE_NAME     [XC_DeviceInfo appPackageName]

/** bundle id */
#define XC_BUNDLE_ID            [XC_DeviceInfo appBundleId]

/**  app version */
#define XC_APP_VERSION          [XC_DeviceInfo appVersion]

/**  device version */
#define XC_DEVICE_VERSION       [XC_DeviceInfo deviceVersion]

/** 手机磁盘空间使用情况，如：6.8/64.0 */
#define XC_DISK_USAGE           [XC_DeviceInfo diskUsage]

/** 手机磁盘总空间,如：63989469184 （64G） */
#define XC_DEVICE_TOTAL_SPACE   [XC_DeviceInfo deviceStorageSpace:YES]

/** 手机磁盘剩余空间 */
#define XC_DEVICE_FREE_SPACE    [XC_DeviceInfo deviceStorageSpace:NO]



#endif /* DeviceInfoDefine_h */





//自定义log输出
#ifdef DEBUG
    #define XC_LOG(param,...) NSLog((@"\n-------------- XC_LOG ↓ --------------\n" @"log info：" param @"\nlog at line: %d\n" @"log at file: %@\n" @"log at function: %@" @"\n-------------- XC_LOG ↑ --------------\n"),##__VA_ARGS__,__LINE__,[NSString stringWithUTF8String:__FILE__],[NSString stringWithUTF8String:__PRETTY_FUNCTION__])
#else
    #define XC_LOG(...)
#endif
