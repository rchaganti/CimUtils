# CimUtils
Set of CIM utilities that can be used to make it easy to work with CIM classes.

## GetCimClassProperties.ps1 ##
### Description ###
This script can be used to gather detailed information around the CIM property types, allowed values, if the property is read-only, and if the property is a key property.
### Usage ###
#### Example 1 ####
Listing all properties and related details.

    .\GetCimClassProperties.ps1 -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Classname MSFT_DscMetaConfiguration

### Output ###
![](http://i.imgur.com/xYibfiF.png)

#### Example 2 ####
Looking for a specific property.

    .\GetCimClassProperties.ps1 -Namespace root/Microsoft/Windows/DesiredStateConfiguration -Classname MSFT_DscMetaConfiguration -PropertyName ConfigurationMode

### Output ###
![](http://i.imgur.com/onJMnci.png)