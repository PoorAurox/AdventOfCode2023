$data = Get-Content (Join-Path $psscriptroot "day2Input.txt")
$pattern = 'Game (?<id>\d): ((\d (?<color>red|blue|green),?)+;?)'

$data | Foreach-Object {
    $test = [regex]::Matches($_, $pattern)
    $test
}
