$data = Get-Content (Join-Path $PSScriptRoot day3p1input.txt) -Raw

$characters = [regex]::matches($data, "\*", [System.Text.RegularExpressions.RegexOptions]::Singleline)
$numbers = [regex]::matches($data, "\d+")

$length = (-split $data)[0].length
$serials = foreach($char in $characters)
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
    $gears = foreach($num in $numbers)
    {
        foreach($i in ($num.Index..($num.Index + $num.Length - 1)))
        {
            if($i -in $position)
            {
                #Write-Host ("Number: {0} Index:{1} Character {2} Index:{3}" -f $num.Value, $num.Index, $char.Value, $char.Index)
                $num
                break
            }
        }
    }
    if($gears.Count -eq 2)
    {
        [int]$gears[0].value * [int]$gears[1].Value
    }
}
$serials | Measure-Object -Sum