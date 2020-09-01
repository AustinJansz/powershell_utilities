### Clear Console
Clear-Host
### ### ### ###

# Initalize original stack
[Object]$stack_original = New-Object System.Collections.Stack
$stack_original.Push(4)
$stack_original.Push(2)
$stack_original.Push(3)
$stack_original.Push(1)

# Display initial values
Write-Host 'Current Stack Values' -ForegroundColor Green
$stack_original

# Function that takes an unordered integer stack and orders it with 1 new stack
function Get-SortedStack {
    [CmdletBinding()]
    param (
        [Object]$stack_input
    );
    # Initialize secondary stack and temporary container for sorting
    [Object]$stack_sorted = New-Object System.Collections.Stack;
    [int]$temp_value = 0;

    # Pop the fist value directly into new stack
    $stack_sorted.Push($stack_input.Pop());
    # Continue until the original stack is empty
    while ($stack_input.Count -gt 0) {
        # Consider the top value in the input stack
        $temp_value = $stack_input.Pop();
        # Run while the current temp value is greater than than the top value
        while ($stack_sorted.Count -gt 0 -and $temp_value -gt $stack_sorted.Peek()) {
            # Push the top value back to the input stack
            $stack_input.Push($stack_sorted.Pop());
        };
        # Add the temp value to the top of the sorted stack
        $stack_sorted.Push($temp_value);
    };
    # Return the stack
    return $stack_sorted
};

# Display ordered stack
Write-Host
Write-Host 'Sorted Stack Values' -ForegroundColor Green
Get-SortedStack -stack_input $stack_original

### Footer Space
Write-Host
### ### ### ###