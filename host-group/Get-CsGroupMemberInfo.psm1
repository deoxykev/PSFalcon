function Get-CsGroupMemberInfo {
<#
    .SYNOPSIS
        Search for detail about members of a Host Group in your environment

    .PARAMETER ID
        The ID of the Host Group to search for members of

    .PARAMETER FILTER
        The filter expression that should be used to limit the results

    .PARAMETER LIMIT
        The maximum records to return [default: 5000]

    .PARAMETER OFFSET
        The offset to start retrieving records from [default: 0]

    .PARAMETER ALL
        Repeat request until all results are returned
#>
    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateLength(32,32)]
        [string]
        $Id,

        [string]
        $Filter,

        [ValidateRange(1,5000)]
        [int]
        $Limit = 5000,

        [int]
        $Offset = 0,

        [switch]
        $All
    )
    begin{
        if ($Filter) { Add-Type -AssemblyName System.Web }
    }
    process{
        $Param = @{
            Uri = '/devices/combined/host-group-members/v1?id=' + $Id + '&limit=' + [string] $Limit +
            '&offset=' + [string] $Offset
            Method = 'get'
            Header = @{
                accept = 'application/json'
                'content-type' = 'application/json'
            }
        }
        switch ($PSBoundParameters.Keys) {
            'Filter' { $Param.Uri += '&filter=' + [System.Web.HTTPUtility]::UrlEncode($Filter) }
            'Verbose' { $Param['Verbose'] = $true }
            'Debug' { $Param['Debug'] = $true }
        }
        if ($All) {
            Join-CsResult -Activity $MyInvocation.MyCommand.Name -Param $Param
        }
        else {
            Invoke-CsAPI @Param
        }
    }
}
