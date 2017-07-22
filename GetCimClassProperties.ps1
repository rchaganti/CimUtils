[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [String] $ClassName,

    [Parameter(Mandatory)]
    [String] $Namespace
)

try
{
    $cimClass = Get-CimClass -ClassName $ClassName -Namespace $Namespace
    foreach ($property in $cimClass.CimClassProperties)
    {
        $property | Select Name, CimType, `
        @{
            l='EmbeddedInstanceOf';e={
                if ($_.Qualifiers.Name -contains 'EmbeddedInstance')
                {
                    $_.Qualifiers.Where({$_.Name -eq 'EmbeddedInstance'}).Value
                }
            }
        },
        @{
            l='IsReadyOnly';e={
                $_.Qualifiers.Name -contains 'read'
            }
        },
        @{
            l='AllowedValues';e={
                if ($_.Qualifiers.Name -contains 'ValueMap') {
                    $_.Qualifiers.Where({$_.Name -eq 'ValueMap'}).Value
                }
            }
        },
        @{
            l='IsKey';e={
                $_.Qualifiers.Name -contains 'Key'
            }
        }
    }
}
catch
{
    Write-Error $_
}
