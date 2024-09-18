function Get-RandomElement {
    param(
        [parameter(ParameterSetName = "FromRange")]
        [Alias("Min", "Low")]
        [int] $LowerBound = 0,

        [parameter(ParameterSetName = "FromRange")]
        [Alias("Max", "High")]
        [int] $UpperBound = 100,

        [parameter(Mandatory = $true, ParameterSetName = "FromObject")]
        [object] $Object
    )

    if ($PSCmdlet.ParameterSetName -eq "FromObject") {
        # If the user wants a random element from an object, adapt the lower and upper bounds
        if ($Object -is [hashtable]) {
            $LowerBound = 0
            $UpperBound = $Object.Keys.Count - 1
        }
        elseif ($Object -is [System.Collections.IEnumerable]) {
            $LowerBound = 0
            $UpperBound = $Object.Count - 1
        }
        elseif ($Object -is [string]) {
            $LowerBound = 0
            $UpperBound = $Object.Length - 1
        }
        else {
            throw "The object must be a string or a collection."
        }
    }

    # Generate a random number within the specified range
    $Lower = [Math]::Min($LowerBound, $UpperBound)
    $Upper = [Math]::Max($LowerBound, $UpperBound)

    if ($Upper -eq $Lower) {
        return $Lower
    }
    else {
        $Random = Get-Random -Minimum $Lower -Maximum $Upper
    }

    if ($PSCmdlet.ParameterSetName -eq "FromObject") {
        # If the user wants a random element from an object, return the element
        if ($Object -is [hashtable]) {
            return $Object[$Object.Keys[$Random]]
        }
        elseif ($Object -is [System.Collections.IEnumerable]) {
            return $Object[$Random]
        }
        elseif ($Object -is [string]) {
            $Object[$Random]
        }
    }
    else {
        # If the user wants a random number from a range, return the number
        return $Random
    }
}