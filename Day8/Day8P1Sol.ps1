
$data = Get-Content (Join-Path $PSScriptRoot Day8Input.txt)

$directions = $data[0]

$mapBetter = @{}

$current = $data | Select-Object -Skip 2 | Foreach-Object {
    $line = [regex]::Match($_, "(?<node>\w+) = \((?<left>\w+), (?<right>\w+)\)")
    $temp = [pscustomobject]@{
        Name = $line.Groups["node"].Value
        Left = $line.Groups["left"].Value
        Right = $line.Groups["right"].Value
    }
    $mapBetter[$temp.Name] = $temp
    if($temp.Name -like '??A')
    {
        $temp
    }
}

$count = 0

while(($current.Name -like '??Z').Count -ne $current.Count)
{
    $action = $count % $directions.length
    for($i = 0; $i -lt $current.Count; $i++)
    {

        if($directions[$action] -eq 'L')
        {
            $current[$i] = $mapBetter[$current[$i].Left]
        }
        else
        {
            $current[$i] = $mapBetter[$current[$i].Right]
        }
        
    }
    $count ++
}

Write-Host $count