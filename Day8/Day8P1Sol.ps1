class Node {
    [string] $Name
    [string] $Left
    [string] $Right


    [int] GetHashCode() {
        return $this.ToString().GetHashCode()
    }

    [string] ToString() {
        return ($this.Name + $this.Left + $this.Right)
    }
}
class Step {
    [Node] $Node
    [string] $Action
    [int] GetHashCode() {
        return $this.ToString().GetHashCode()
    }
    [string] ToString() {
        return ($this.Node.ToString() + $this.Action)
    }
}

$data = Get-Content (Join-Path $PSScriptRoot Day8Input.txt)

$directions = $data[0]
$mapBetter = [System.Collections.Concurrent.ConcurrentDictionary[string,Node]]::new()

$current = $data | Select-Object -Skip 2 | Foreach-Object {
    $line = [regex]::Match($_, "(?<node>\w+) = \((?<left>\w+), (?<right>\w+)\)")
    $temp = [Node]@{
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

$loops = $current | Foreach-Object {
    $moves = [System.Collections.Generic.HashSet[Step]]::new()
    $count = 0
    $node = $_
    do
    {
        
        $action = $count % $directions.Length

        if($directions[$action] -eq 'L')
        {
            $node = $mapBetter[$node.Left]
        }
        else
        {
            $node = $mapBetter[$node.Right]
        }
        
        $count ++
        $temp = [Step]@{
            Node = $node
            Action = $action
        }
    } while($moves.Add($temp))
    Write-Output -NoEnumerate $moves
}

Write-Host $count