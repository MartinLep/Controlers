//
//  pwMethodSwizzling.m
//  pwControls
//
//  Created by MartinLee on 17/1/11.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pwMethodSwizzling.h"
#import <objc/runtime.h>

@implementation pwMethodSwizzling

/**
 
 交换实例方法
 originalSEL 被替换的SEL
 objectSEL 用于替换的自定义SEL
 objectClass 进行MehodSwizzling的Class
 */
void MT_ExchangeInstanceMethod(SEL originalSEL,SEL objectSEL,Class objectClass){
    
    Method originalMethod = class_getInstanceMethod(objectClass, originalSEL);
    Method replaceMethod = class_getInstanceMethod(objectClass, objectSEL);
    
    //判断是否实现方法
    if(originalMethod==NULL|| replaceMethod==NULL){
        NSLog(@"\n.\tWarning! MT_ExchangeInstanceMethod failed! [%@ 及其 SuperClasses] 均为实现方法 [%@]\n",objectClass,originalMethod==NULL?NSStringFromSelector(originalSEL):NSStringFromSelector(objectSEL));
        return;
    }
    
    //将replaceMethod实现添加到objectClass中，并且将originalSEL指向新添加的replaceMethod的IMP。
    BOOL add = class_addMethod(objectClass, originalSEL, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod));
    if(add){
        // 添加成功，再将objectSEL指向原有的originalMethod的IMP，实现交换
        // 当前类或者父类没有实现originalSEL会执行这一步
        class_replaceMethod(objectClass, objectSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        // 已经实现originalSEL，对originalMethod和replaceMethod的实现指针IMP进行交换
        method_exchangeImplementations(originalMethod, replaceMethod);
    }
}

/**
 
 交换类方法 
 用于替换同一类的2个[类]方法。建议放在+(void)load方法使用
 originalSEL 被替换的SEL
 objectSEL 用于替换的自定义SEL
 objectClass 进行MehodSwizzling的Class
 */

void MT_ExchangeClassMethod(SEL originalSEL,SEL objectSEL,Class objectClass){
    
    Method originalMethod = class_getClassMethod(objectClass, originalSEL);
    Method replaceMethod = class_getClassMethod(objectClass, objectSEL);
    
    //判断是否实现方法
    if(originalMethod==NULL|| replaceMethod==NULL){
        NSLog(@"\n.\tWarning! MT_ExchangeInstanceMethod failed! [%@ 及其 SuperClasses] 均为实现方法 [%@]\n",objectClass,originalMethod==NULL?NSStringFromSelector(originalSEL):NSStringFromSelector(objectSEL));
        return;
    }
    
    // 交换实例方法的写法在这失效了，所以直接进行了method_exchangeImplementations
    method_exchangeImplementations(originalMethod, replaceMethod);
}

@end

#pragma mark 打印当前要显示的控制器
@implementation UIViewController (Swizzling)

+(void)load{
#ifdef DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MT_ExchangeInstanceMethod(@selector(viewWillAppear:), @selector(MT_viewWillAppear:), self);
    });
#endif
}

-(void)MT_viewWillAppear:(BOOL)animated{
    [self MT_viewWillAppear:YES];
    NSString * className = NSStringFromClass([self class]);
    if (![className hasPrefix:@"UI"] && ![className hasPrefix:@"_"]) {
        //NSLog(@"即将显示:%@   备注:%@",self.class,self.view.accessibilityIdentifier);
    }
}

@end

/**
 加载UIImage有2种方式：
 方式1：[UIImage imageNamed...]会不断增加缓存，直到APP进程被杀才会释放，适用于频繁使用的图片，存放在Assets.xcassets中图片必须[UIImage imageNamed...]。
 方式2：[UIImage imageWithContentsOfFile...]不会被缓存，Image对象释放即可释放内存，适用于不怎么用的图片，而且存在于[NSBundle mainBundle]中，不能存放在Assets.xcassets中。
 */
#pragma mark  UIImage优先使用无缓存加载

@implementation UIImage (Swizzling)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MT_ExchangeClassMethod(@selector(imageNamed:), @selector(MT_imageNamed:), self);
    });
}

+ (UIImage *)MT_imageNamed:(NSString *)name{
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:[name hasSuffix:@"jpg"] ? nil : @"png"]];
    if(!image){
        image = [self MT_imageNamed:name];
    }
    if(image == nil){
        NSLog(@"\nWarning! 图片加载失败!  imageName:%@",name);
    }
    return image;
}

@end

#pragma mark 打印字典中的中文

//打印NSDictionary中的中文，针对网络请求到的数据

@implementation NSDictionary (Swizzling)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MT_ExchangeClassMethod(@selector(descriptionWithLocale:), @selector(MT_descriptionWithLocale:), self);
    });
}

-(NSString *)MT_descriptionWithLocale:(id)locale{
    if(self == nil || self.allKeys.count == 0){
        return [self MT_descriptionWithLocale:locale];
    }else{
        @try {
            NSError *error = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
            if(error){
                return [self MT_descriptionWithLocale:locale];
            }else{
                return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
        } @catch (NSException *exception) {
            return [self MT_descriptionWithLocale:locale];
        }
    }
}

@end


#pragma mark 防止NSMutableArray 插入nil、数组越界导致崩溃
//可能会变相的造成数据异常
@implementation NSArray (SafeSwizzling)
static const char *kArrayClass = "__NSArrayI";

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MT_ExchangeInstanceMethod(@selector(objectAtIndex:), @selector(MT_objectAtIndex:), objc_getClass(kArrayClass));
    });
}

-(id)MT_objectAtIndex:(NSUInteger)index{
    if(index < self.count){
        return [self MT_objectAtIndex:index];
    }else{
        NSLog(@"数组查询越界,return <null>。 --[NSArray objectAtIndex:]-- index=%zd   array.count=%zd",index,self.count);
        return [NSNull null];
    }
}
@end

@implementation NSMutableArray (SafeSwizzling)
static const char *kMutArrayClass = "__NSArrayM";
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MT_ExchangeInstanceMethod(@selector(objectAtIndex:), @selector(MT_objectAtIndexM:), objc_getClass(kMutArrayClass));
        MT_ExchangeInstanceMethod(@selector(insertObject:atIndex:), @selector(MT_insertObject:atIndex:), objc_getClass(kMutArrayClass));
    });
}

- (id)MT_objectAtIndexM:(NSUInteger)index{
    if(index < self.count){
        return [self MT_objectAtIndexM:index];
    }else{
        NSLog(@"数组查询越界,return <null>。 --[NSMutableArray objectAtIndex:]-- index=%zd   array.count=%zd",index,self.count);
        return [NSNull null];
    }
}

-(void)MT_insertObject:(id)anObject atIndex:(NSUInteger)index{
    if(index > self.count){
        NSLog(@"数组插值越界 --[NSMutableArray insertObject: atIndex:]-- object=%@   index=%zd      array.count=%zd",anObject,index,self.count);
    }else if (anObject == nil){
        NSLog(@"传入空值Nil --[NSMutableArray insertObject: atIndex:]-- object=%@   index=%zd",anObject,index);
    }else{
        [self MT_insertObject:anObject atIndex:index];
    }
}
@end

#pragma mark 防止MutableDictionary 传入nil导致崩溃

//慎用，可能会变相的造成数据异常

@implementation NSMutableDictionary (SafeSwizzling)
static const char * kMutDictClass = "__NSDictionaryM";
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MT_ExchangeInstanceMethod(@selector(setObject:forKey:), @selector(MT_setObject:forKey:), objc_getClass(kMutDictClass));
    });
}
-(void)MT_setObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if (anObject && aKey) {
        [self MT_setObject:anObject forKey:aKey];
    } else {
        NSLog(@"传入空值Nil --[NSMutableDictionary setObject: forKey:]-- object=%@   key=%@",anObject,aKey);
    }
}

@end


#pragma mark 解决button重复点击问题

@implementation UIControl (Swizzling)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_ignoreEvent = "UIControl_ignoreEvent";

- (NSTimeInterval)mt_acceptEventInterval{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setMt_acceptEventInterval:(NSTimeInterval)mt_acceptEventInterval{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(mt_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)mt_ignoreEvent{
    return [objc_getAssociatedObject(self, UIControl_ignoreEvent) boolValue];
}

- (void)setMt_ignoreEvent:(BOOL)mt_ignoreEvent{
    objc_setAssociatedObject(self, UIControl_ignoreEvent, @(mt_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MT_ExchangeInstanceMethod(@selector(sendAction:to:forEvent:), @selector(MTsendAction:to:forEvent:), self);
    });
}

- (void)MTsendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if(self.mt_ignoreEvent) return;
    
    if(self.mt_acceptEventInterval > 0){
        self.mt_ignoreEvent = YES;
        [self performSelector:@selector(setMt_ignoreEvent:) withObject:@(NO) afterDelay:self.mt_acceptEventInterval];
    }
    [self MTsendAction:action to:target forEvent:event];
}
@end















