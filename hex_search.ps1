# Save the file to a local byte array
$bytes = [System.IO.File]::ReadAllBytes($file_path)

# Encode the byte array as a string
$bytes_as_string = $bytes.ForEach('ToString', 'X') -join ' '

# Search for hex matches
$bytes_as_string | Select-String -Pattern $pattern -AllMatches
# ex $bytes_as_string | Select-String -Pattern 'AA BB CC' -AllMatches

# Create a string array from the hex string for easy searchability
$bytes_as_array = $bytesAsString.Split(' ')

# Find the offset of hex patterns in array
(0..($bytes_as_array.Length-$search_pattern_length)) | where {$bytes_as_array[($_)] -eq $byte_one -and $bytes_as_array[($_ + 1)] -eq $byte_two}
#e ex (0..($bytes_as_array.Length-3)) | where {$bytes_as_array[($_)] -eq 'AA' -and $bytes_as_array[($_ + 1)] -eq 'BB' -and $bytes_as_array[($_ + 2)] -eq 'CC'}
