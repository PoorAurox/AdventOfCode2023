function GoUp {
    param (
        $PositionX,
        $PositionY,
        $Data
    )
    if(($PositionY - 1) -lt 0)
    {

    }
    elseif($Data[$PositionY - 1][$PositionX] -ne '.')
    {

    }
    else {
        $temp = $Data[$PositionY]
        $tempCharArray = $temp.toCharArray()
        $tempCharArray[$PositionX] = '.'
        $Data[$PositionY] = [string]::new($tempCharArray)

        $temp = $Data[$PositionY - 1]
        $tempCharArray = $temp.toCharArray()
        $tempCharArray[$PositionX] = 'O'
        $Data[$PositionY - 1] = [string]::new($tempCharArray)

        $Data = GoUp -PositionX $PositionX -PositionY ($PositionY - 1) -Data $Data
        
    }
    $Data
}
$map = Get-Content (Join-Path $PSScriptRoot Day14Input.txt)

for($i = 0; $i -lt $map.Count; $i++)
{
    for($j = 0; $j -lt $map[0].Count; $j++)
    {
        if($map[$i][$j] -eq 'O')
        {
            $map = GoUp -PositionX $j -PositionY $i -Data $map
        }
    }
}
