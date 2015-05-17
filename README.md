
1. Create new project in Xcode
2. Drop AirTableViewController.xcodeproj into project.
3. Add resources (all .xib files) from AirTableViewController projects
4. Setup header search path:
4.1. Click on the project in the Project Navigator
4.2. Select taret on the left side
4.3. Select Build Settings tab on the top
4.4. Find Header Search Path (```$HEADER_SEARCH_PATHS```)
4.5. Add path to the AirTableViewController project (e.g. ```${SRCROOT}/External/AirTableViewController```)
5. Link with library
5.1. Click on the project in the Project Navigator
5.2. Select taret on the left side
5.3. Select Build Phases tab on the top
5.4. Expand Target Dependences, click on the + button and select AirTableViewController
5.5. Expand Link Binary With Libraries, click + button and select libAirTableViewController
6. Add into your .pch file import     
```	#import <AirTableViewController/AirTableViewController.h>```

And you are ready to use it.

Use AirTableViewController
1. Setup interface
1.1. Add into storyboard View Controller and set class AITTableViewController
1.2. Add into AITTableViewController.view Table View
1.3. Add contrains for table view
1.3. Setup outlets:
1.3.1. view, tableView, topConstraint, bottomConstraint from AITTableViewController
1.3.2. dataSource and delegate from tableView to AITTableViewController
2. In your code (e.g. in the ```-prepareForSegue:sender:``` or in the ```-viewDidLoad```) add sections into table view:
3. Add value into your sections


WARNING:
Value shows if it not empty (isEmpty == NO) or AITTableViewController in edit mode (AITTableViewController editin == YES).
E.g. AITTextValue shows only if string not empty or AITTableViewController in edited state.

Setup AITTableViewController
====
You should setup AITTableVoewController before show. 
Outlets: You should assign outlets tableView, topConstraint, bottomConstraint. e.g. you can do that in the InterfaceBuilder.
State: -setEditing:animated: used for setup editing state.
Content: All data contains in the sections array. Each item of sections should be AITTableViewSection class.
Example:
```
    [tableViewController setEditing:YES animated:NO];
    tableViewController.sections = @[
            [self staticSection1],
            [self staticSection2],
            [self staticSection3],
    ];
````

Creating Sections
====

Section With Predefined Set Of Values
===

AITTableViewSection represents table view section with predefined set of data. You create section and assign array of values into sections.
Example:
```
    AITTableViewSection *result = [[AITTableViewSection alloc] init];
    result.allObjects = @[
            [self value1],
            [self value2],
            [self value3],
    ];
```

Section With Customisable Header And Footer View
===
```AITHeaderFooterSection``` represents section with customizable header and footer views. You can set ```headerViewIdentifier``` string and register nib for identifier for build your custom view. 
```AITHeaderFooterView ```+registerNib:forHeaderFooterViewReuseIdentifier```:
Registred views identifiers:
- ```kAITHeaderFooterViewLeftAlignedHeaderIdentifier```;
- ```kAITHeaderFooterViewCenterAlignedHeaderIdentifier```;
- ```kAITHeaderFooterViewCenterAlignedFooterIdentifier```;

Section With Pending Operation Process
===
```AITPendingOperationSection``` represents section that can show activity indicator thap replace all cells.

Creating Values For Cells
====

Text Edit
===
```AITTextValue``` value that represents editable text field. You can assign any NSString property for show and edit that property.
Example:
```
    AITTextValue *value = [AITTextValue valueWithTitle:@"String Property Value"
                                          sourceObject:self.dataSource
                                    sourcePropertyName:@"stringProperty"
                                               comment:@"String Property Value Placeholder"];
```

Boolean
===
```AITBoolValue``` value that repsesents cell with UISwitch. You can assign any BOOL property for show and edit that property.
Example:
```
    AITBoolValue *value = [AITBoolValue valueWithTitle:@"Boolean Property Value"
                                          sourceObject:self.staticDataSource
                                    sourcePropertyName:@"boolProperty"];
```

Date
===
```AITDateValue``` value that represents cell with date value. You can assign any NSDate property for show and edit that property. For edit date show popup with date picker (before iOS 7) or additional cell with date picker (after iOS 7)
Example:
```
    AITDateValue *value = [AITDateValue valueWithTitle:@"Date Property Value"
                                          sourceObject:self.staticDataSource
                                    sourcePropertyName:@"dateProperty"];
```

Action
===
```AITActionValue``` value that represents cell for action and doesn't represent any other data. If user tap on the appropriate cell ```AITTableViewController``` invoke associated block code.
Example:
```
    AITActionValue *value = [AITActionValue valueWithTitle:@"Show Alert View" action:^(AITActionValue *value) {
        [self showAlert];
    }];
```
