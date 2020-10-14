function Start-RtrBatch {
<#
    .SYNOPSIS
        Batch initialize a RTR session on multiple hosts. Before any RTR commands
        can be used, an active session is needed on the host

    .PARAMETER ID
        List of host agent IDs to initialize a RTR session on

    .PARAMETER EXISTING
        Optional batch ID. Use an existing batch ID if you want to initialize new hosts and
        add them to an existing batch

    .PARAMETER TIMEOUT
        Time to wait for the command request to complete, in seconds [default: 30]
        
    .PARAMETER QUEUEOFFLINE
        Optional switch to queue the RTR command for offline hosts
        
#>
    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter(Mandatory = $true)]
        [array]
        $Id,

        [ValidateLength(36,36)]
        [string]
        $Existing,

        [ValidateRange(30,600)]
        [int]
        $Timeout = 30
        
        [switch]
        $QueueOffline
        
    )
    process{
        $Param = @{
            Uri = '/real-time-response/combined/batch-init-session/v1?timeout=' + [string] $Timeout
            Method = 'post'
            Header = @{
                accept = 'application/json'
                'content-type' = 'application/json'
            }
            Body = @{ 
                host_ids = $Id
            }
        }
        switch ($PSBoundParameters.Keys) {
            'Existing' { $Param.Body['existing_batch_id'] = $Existing }
            'QueueOffline' { $Param.Body['queue_offline'] = $true }
            'Verbose' { $Param['Verbose'] = $true }
            'Debug' { $Param['Debug'] = $true }
        }
        $Param.Body = $Param.Body | ConvertTo-Json

        Invoke-CsAPI @Param
    }
}
