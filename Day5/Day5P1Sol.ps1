$data = Get-Content (Join-Path $PSScriptRoot Day5Input.txt) -Raw
$data = $data -split "`r`n`r`n"
$seeds = [regex]::matches($data[0], "(?<start>\d+) (?<range>\d+)") | Foreach-Object {
    [pscustomobject]@{
        Collections = @(,[pscustomobject]@{
            Start = $_.Groups["start"] -as [int64]
            Range = $_.Groups["range"] -as [int64]
        })
    }
}

$cheatsheet = $data | Select-Object -Skip 1 | ForEach-Object {
    $map = [regex]::Match($_, "(?<source>[a-z]+)-to-(?<dest>[a-z]+)")
    $mappings = [regex]::Matches($_, "(?<to>\d+) (?<from>\d+) (?<range>\d+)") |
        ForEach-Object {
            [pscustomobject]@{
                to = $_.Groups["to"].Value -as [int64]
                from = $_.Groups["from"].Value -as [int64]
                range = $_.Groups["range"].Value -as [int64]
            }
        }
    [pscustomobject]@{
        Source = $map.Groups["source"].Value
        Destination = $map.Groups["dest"].Value
        Mappings = $mappings
    }
}

$current = "seed"
while($cheatsheet | Where-Object Source -eq $current)
{
    $destchart = $cheatsheet | Where-Object Source -eq $current
    for($i = 0; $i -lt $seeds.Count; $i++)
    {
        foreach($col in $seeds[$i].Collections)
        {
            Foreach-Object {
                $math = $destchart.Mappings | Where-Object {$col.Start -ge $_.from -and $seeds[$i] -lt ($_.from + $_.range - 1)}
                if($math)
                {
                    $difference = $math.from - $math.to
                    $seeds[$i] -= $difference
                }
            }
        }
    }
    $current = $destchart.Destination
}