<#
AUTHOR: Austin Clayton Jansz
DATE  : 2020-08-21
.SYNOPSIS
    A CROSS-PLATFORM cryptographically secure random data interface.
.DESCRIPTION
    The program utilizes the built-in cryptography library to create randomness.
.NOTES
    A more secure version of Get-Random.
#>

function New-RandomUInt32 {
    [CmdletBinding()]
    [Byte[]]$octet = 1..4;
    $rng_handler = New-Object System.Security.Cryptography.RNGCryptoServiceProvider;
    $rng_handler.GetBytes($octet);
    return [System.BitConverter]::ToInt32($octet)
};

function New-RandomNumber {
    [CmdletBinding()]
    param (
        [UInt32]$Minimum = [UInt32]::MinValue,
        [UInt32]$Maximum = [UInt32]::MaxValue
    );
    return (New-RandomUInt32) % ($Maximum - $Minimum + 1) + $Minimum
};

function New-RandomString {
    [CmdletBinding()]
    param (
        [UInt32]$Length = 10
    );
    [UInt32[]]$random_numbers = (1..$Length) | ForEach-Object {
        New-RandomNumber -Minimum 65 -Maximum 126;
    };
    return -join ($random_numbers | ForEach-Object {[char]$_;})
}