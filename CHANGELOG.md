# Changelog

## Version 1.2a

Version:     1.2a  
Author:      monkey0506  
Date:        29 March 2009  
Description: Fixed bug where `Stack.GetItemsArray` may request a 0-sized array.

## Version 1.2

Version:     1.2  
Author:      monkey0506  
Date:        28 March 2009  
Description: Added `Stack.GetItemsArray`, `File.WriteStack`, `File.ReadStackBack`, and
`Stack.LoadFromFile` functions. The module now exports `StackDataFormat` so it can be used by other
scripts for extending the module. It is not imported, it must be locally imported to the script
requiring it. Modified the way `Stack.Copy` formats the data to better prevent collisions. Fixed a
bug with `Stack.Push` where if you were adding an item at a specific index `ItemCount` was still
getting increased. Added data type `eStackDataInvalid` to indicate that the object is not valid
`StackData`. Included module information in the Properties pane for the script.

## Version 1.0

Version:     1.0  
Author:      monkey0506  
Date:        20 March 2009  
Description: First public release.  
