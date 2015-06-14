//
//  AITSettingsDetailsProvider.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITDetailsViewControllerProvider.h>


/**
 * @brief Create view controller for details value block.
 */
typedef UIViewController *(^AITSettingsDetailsProviderCreateView)(AITValue *);


/**
 * @brief Class that define popup details view controller.
 */
@interface AITSettingsDetailsProvider : NSObject<AITDetailsViewControllerProvider>

/**
 * @brief Define presentations style.
 * @details Default value is AITDetailsPresentationStyleCustom.
 */
@property (nonatomic, assign) AITDetailsPresentationStyle presentationStyle;

/**
 * @brief Instantiate new details view controller provider for popup view controller class.
 * @details View controller creates with createViewBlock block.
*/
+ (instancetype)providerWithCreateViewBlock:(AITSettingsDetailsProviderCreateView)createViewBlock;

/**
 * @brief Register class that represents in details views as navigation controller
 * @details Details view represents as modal view. In that view you can make navigation
 *      with UINavigationController or you can change UINavigationController with your
 *      own navigation controller subclass. This method replace UINavigationController.
 */
+ (void)registerNavigationControllerClass:(Class)navigationControllerClass;

/**
 * @brief Register preferred frame for details view controller.
 * @details Details view represents as modal view. You can change size for modal view.
 */
+ (void)registerPreferredFrame:(CGRect)preferredFrame;


@end
