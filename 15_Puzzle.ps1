<#
AUTHOR: Austin Clayton Jansz
DATE  : 2020-08-14


.SYNOPSIS
    15 Puzzle is a fun numbers-based game.
.DESCRIPTION
    The user must swap single pieces with the wildcard to restore order
.NOTES
    To read more about this game: https://en.wikipedia.org/wiki/15_puzzle
    Seed puzzle must be manually edited, some combinations are impossible
#>

# Get-Board: Takes a parameter board (2D array) and prints the board
function Get-Board {
    param (
        [object]$board,
        [bool]$complete_board
    )

    [int32]$x = 0
    [int32]$y = 0
    [string]$output = ''
    [string]$output_colour = ''
    [int32]$wildcard = 16

    while($y -lt $board.Length) {
        $x = 0
        Write-Host "`t" -NoNewline
        while($x -lt $board[$y].Length) {
            if($board[$y][$x] -eq $wildcard) {
                $output = ''.PadLeft(2, 'X')
                Write-Host $output -NoNewline -ForegroundColor Blue -BackgroundColor White
                Write-Host "`t" -NoNewline
            }
            else {
                $output = ([String]$board[$y][$x]).PadLeft(2, '0')
                $output_colour = If($completed_board) {'Green'} Else {'Red'}
                Write-Host $output -NoNewline -ForegroundColor $output_colour
                Write-Host "`t" -NoNewline
            }
            $x++
        }
        Write-Host "`n`n"
        $y++
    }
}

# Find-BoardValue: Takes a parameter board and value and returns the location of the value on board
function Find-BoardValue {
    param (
        [object]$board,
        [int32]$value
    )

    [int32]$x = 0
    [int32]$y = 0

    while($y -lt $board.Length) {
        $x = 0
        while($x -lt $board[$y].Length) {
            if($board[$y][$x] -eq $value) {break}
            else {$x++}
        }
        if($board[$y][$x] -eq $value) {break}
        else {$y++}
    }
    return $y, $x
}

# Get-CompletionStatus: Takes a parameter board and returns if the board is in sequential order
function Get-CompletionStatus {
    param (
        [object]$board
    )

    [object]$completed_board = [int32[]](1..4),[int32[]](5..8),[int32[]](9..12),[int32[]](13..16)
    [int32]$completed_rows = 0

    for($i = 0; $i -lt $board.Length; $i++) {
        if ($($board[$i] -join ',') -eq $($completed_board[$i] -join ',')) {$completed_rows++}
    }
    return ($completed_rows -eq $board.Length)
}

# Update-Board: Takesa a parameter board and value and updates the board if possible
function Update-Board {
    param (
        [object]$board,
        [int32]$value
    )

    [int32]$wildcard = 16
    [int32[]]$loc_wildcard = Find-BoardValue -board $board -value $wildcard
    [int32[]]$loc_value = Find-BoardValue -board $board -value $value

    if(([Math]::Abs($loc_wildcard[0] - $loc_value[0]) -eq 1) -xor ([Math]::Abs($loc_wildcard[1] - $loc_value[1]) -eq 1)) {
        $board[$loc_wildcard[0]][$loc_wildcard[1]] = $value
        $board[$loc_value[0]][$loc_value[1]] = 16
    }
    return $board
}

# Completed Board
# [object]$board_values = [int32[]](1..4), [int32[]](5..8), [int32[]](9..12), [int32[]](13..16)

# Sample board from Wikipedia
[object]$board_values = [int32[]](15, 2, 1, 12), [int32[]](8, 5, 6, 11), [int32[]](4, 9, 10, 7), [int32[]](3, 14, 13, 16)

[string]$banner = @'


******** Welome to the 15 Puzzle! ********
Order the numbers by swapping the wildcard
******************************************

'@

Clear-Host
Write-Host $banner -ForegroundColor Blue
[bool]$completion_status = Get-CompletionStatus -board $board_values
Get-Board -board $board_values -complete_board $completion_status

While(!$completion_status) {
    [int32]$update_value = Read-Host -Prompt 'Value to swap with wildcard'
    $board_values = Update-Board -board $board_values -value $update_value
    $completion_status = Get-CompletionStatus -board $board_values
    Clear-Host
    Write-Host $banner -ForegroundColor Blue
    Get-Board -board $board_values -complete_board $completion_status
}

Write-Host "Board Complete: $(Get-CompletionStatus -board $board_values)`n"