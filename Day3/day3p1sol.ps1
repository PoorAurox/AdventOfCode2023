$data = Get-Content (Join-Path $PSScriptRoot day3p1input.txt) -Raw

$characters = [regex]::matches($data, "[^\d\.\r\n]", [System.Text.RegularExpressions.RegexOptions]::Multiline)
$numbers = [regex]::matches($data, "\d+", [System.Text.RegularExpressions.RegexOptions]::Singleline)

$length = (-split $data)[0].length
$serials = [System.Collections.Generic.HashSet[System.Text.RegularExpressions.Group]]::new()
foreach($char in $characters)
{
    $charPos = $char.Index % ($length + 2)
    $up, $right, $down, $left = $false
    $position = @()
    if(($char.Index - ($length + 2)) -gt 0)
    {
        $up = $true
        $position+= $char.Index -$length - 2
    }
    if(($char.Index + $length + 2) -lt $data.Length)
    {
        $down = $true
        $position += $char.Index + $length + 2
    }
    if(($charPos + 1) -lt $length)
    {
        $right = $true
        $position += $char.Index + 1
    }
    if(($charPos -1 ) -gt 0)
    {
        $left = $true
        $position += $char.Index -1
    }
    if($up)
    {
        if($right)
        {
            $position += $char.Index - ($length + 1)
        }
        if($left)
        {
            $position += $char.Index - $length -3
        }
    }
    if($down)
    {
        if($right)
        {
            $position += $char.Index + $length + 3
        }
        if($left)
        {
            $position += $char.Index + $length + 1
        }
    }
    Write-Host ("Character: {0} Index: {1}" -f $char.Value, $char.Index)
    Write-Host ($position | Sort)
    foreach($num in $numbers)
    {
        foreach($i in ($num.Index..($num.Index + $num.Length - 1)))
        {
            if($i -in $position)
            {
                Write-Host ("Number: {0} Index:{1} Character {2} Index:{3}" -f $num.Value, $num.Index, $char.Value, $char.Index)
                [void]$serials.Add($num)
                break
            }
        }
    }
}
$serials.GetEnumerator() | Measure-Object -Property {$_.Value -as [int]} -Sum