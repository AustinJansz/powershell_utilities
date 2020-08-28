<#
AUTHOR: Austin Clayton Jansz
DATE  : 2020-08-20
.SYNOPSIS
    A CROSS-PLATFORM string hashing interface for PowerShell.
.DESCRIPTION
    The user may define an input string and algorithm from available pool.
.NOTES
    A logical extension to the cmdlet Get-FileHash.
#>

function Get-StringHash {
    [CmdletBinding()]
    param (
        [string]$InputString = '',
        [switch]$AlgorithmSelect = $false
    );
    # Format variables from parameters for name_name consistency
    [string]$algorithm = 'SHA256';
    [string]$input_string = $InputString;
    [bool]$algorithm_select = $AlgorithmSelect;

    [string]$algorithm_pool = @"

Algorithm Pool:
    [1] SHA1
    [2] SHA256 [DEFAULT]
    [3] SHA384
    [4] SHA512
    [5] MD5
Algorithm Selection
"@;
    
    # Handle input parameters and render useful data
    if ($input_string -eq '') {
        $input_string = Read-Host -Prompt 'Text to hash';
    };
    if ($algorithm_select) {
        [string]$algorithm_id = Read-Host -Prompt $algorithm_pool;
        Switch  ($algorithm_id) {
            '1'     {$algorithm = 'SHA1'};
            '2'     {$algorithm = 'SHA256'};
            '3'     {$algorithm = 'SHA384'};
            '4'     {$algorithm = 'SHA512'};
            '5'     {$algorithm = 'MD5'};
            default {$algorithm = 'SHA256'};
        };
    }
    else {
        Write-Host "Default algorithm selected: SHA256" -ForegroundColor Green;
    };
    
    # Create a string stream which is used to hash the data
    $string_stream = [System.IO.MemoryStream]::new();
    $stream_writer = [System.IO.StreamWriter]::new($string_stream);
    $stream_writer.write($input_string);
    $stream_writer.Flush();
    $string_stream.Position = 0;
    return (Get-FileHash -InputStream $string_stream -Algorithm $algorithm).Hash
};