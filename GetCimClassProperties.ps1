function Get-CimClassProperty
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String] $ClassName,

        [Parameter(Mandatory)]
        [String] $Namespace,

        [Parameter()]
        [String] $PropertyName
    )

    function extractProperty($cimProperty)
    {
        $cimProperty | Select Name, CimType, `
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

    try
    {
        $cimClass = Get-CimClass -ClassName $ClassName -Namespace $Namespace -ErrorAction Stop

        if ($PropertyName)
        {
            $cimProperty = $cimClass.CimClassProperties.Where({ $_.Name -eq $PropertyName })
            if ($cimProperty)
            {
                extractProperty -cimProperty $cimProperty
            }
            else
            {
                throw "${PropertyName} does not exist in the CIM Class"   
            }
        }
        else
        {
            foreach ($property in $cimClass.CimClassProperties)
            {
                extractProperty -cimProperty $property
            }
        }
    }
    catch
    {
        Write-Error $_
    }
}
