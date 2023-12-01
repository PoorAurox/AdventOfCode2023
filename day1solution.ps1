$text = Get-Content .\day1Input.ps1

$numbers = "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"

$regex = $numbers -join '|'

$text | % {
    $both = [regex]::Matches($_, "\d|$($regex)").Value
    $first = [regex]::Match($_, "\d|$($regex)").Value
    $last = [regex]::Match($_, "\d|$($regex)", [System.Text.RegularExpressions.RegexOptions]::RightToLeft).Value
    # $first = $both[0]
    # $last = $both[-1]
    $output = [int](($first -as [int] ? $first : ($numbers.IndexOf($first) + 1).ToString()) + ($last -as [int] ? $last : ($numbers.IndexOf($last) + 1).ToString()))
    Write-Host ("First: {0} Last: {1} Output: {2}" -f $first, $last, $output)
    $output
} | Measure-Object -Sum