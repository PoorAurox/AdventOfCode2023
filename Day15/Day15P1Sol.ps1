$data = (Get-Content (Join-Path $PSScriptRoot Day15Input.txt)) -split ','

$data | Foreach-Object {
    $curSum = 0
    foreach($char in $_.ToCharArray())
    {
        $curSum += [int]$char
        $curSum *= 17
        $curSum = $curSum % 256
    }
    $curSum
} | Measure-Object -Sum