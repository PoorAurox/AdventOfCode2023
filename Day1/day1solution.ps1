$text = Get-Content .\day1Input.txt

$numbers = "\d", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"

$regex = $numbers -join '|'

$text | Foreach-Object {
    $first = [regex]::Match($_, $regex).Value
    $last = [regex]::Match($_, $regex, [System.Text.RegularExpressions.RegexOptions]::RightToLeft).Value

    [int](($first -as [int] ? $first : $numbers.IndexOf($first).ToString()) + ($last -as [int] ? $last : $numbers.IndexOf($last).ToString()))
} | Measure-Object -Sum