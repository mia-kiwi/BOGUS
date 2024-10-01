function Get-Int16 {
    [OutputType([int16])]
    param(
        [parameter(Position = 0)]
        [Alias("Min", "Low", "Between", "From")]
        [ValidateRange([int16]::MinValue, [int16]::MaxValue)]
        [int] $LowerBound = [int16]::MinValue,

        [parameter(Position = 1)]
        [Alias("Max", "High", "To", "And")]
        [ValidateRange([int16]::MinValue, [int16]::MaxValue)]
        [int] $UpperBound = [int16]::MaxValue,

        [Alias("Exclude")]
        [string[]] $MustExclude = @()
    )

    # Process the lower and upper bounds. If the upper bound is less than the lower bound, swap them. If they are equal, return the lower bound.
    $Lower = [Math]::Min($LowerBound, $UpperBound)
    $Upper = [Math]::Max($LowerBound, $UpperBound)

    if ($Upper -eq $Lower) {
        Write-Verbose "The upper and lower bounds are the same. Returning the lower bound."
        return $Lower
    }

    do {
        # Generate a random number within the specified range
        $Random = Get-RandomElement -LowerBound $Lower -UpperBound $Upper

        # If the stringified random int16 matches any of the exlcuded values, generate a new random int16
        $IntIsCompliant = $true
        foreach ($ExcludedValue in @($MustExclude)) {
            if ($Random.ToString() -like $ExcludedValue) {
                Write-Verbose "The random int16 matches an excluded value. Generating a new random int16."
                $IntIsCompliant = $false
            }
        }
    } until ($IntIsCompliant)

    return [int16]$Random
}