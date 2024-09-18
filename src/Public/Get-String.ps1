<#
.SYNOPSIS
Generates a random string.

.DESCRIPTION
Generates a random string with a fixed or variable length, a specified character set, and optional constraints.

.PARAMETER Length
The length of the output string.

.PARAMETER MaxLength
The maximum length of the output string.

.PARAMETER MinLength
The minimum length of the output string.

.PARAMETER Charset
The character set to use for the output string.

.PARAMETER MayContain
The string that may be present in the output.

.PARAMETER ChanceMayContain
The probability that the string specified in the MayContain parameter will be present in the output.

.PARAMETER MustContain
The string that must be present in the output.

.PARAMETER MustNotContain
The string that must not be present in the output.

.PARAMETER StartsWith
The string that must be present at the beginning of the output.

.PARAMETER EndsWith
The string that must be present at the end of the output.

.EXAMPLE
PS X:\> Get-String -Length 10
dn!6eN@6Ec

.EXAMPLE
PS X:\> Get-String -MaxLength 10 -MinLength 5
zNkBAlf

.EXAMPLE
PS X:\> Get-String -MaxLength 10 -MinLength 5 -MustContain "Hello"
Z}Hello
#>
function Get-String {
    param(
        [parameter(ParameterSetName = "FixedLength")]
        [ValidateRange(0, [int]::MaxValue)]
        [Alias("l")]
        [int] $Length = 10,

        [parameter(Mandatory = $true, ParameterSetName = "VariableLength")]
        [Alias("and")]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $MaxLength,

        [parameter(ParameterSetName = "VariableLength")]
        [Alias("between")]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $MinLength = 0,

        [Alias("c", "chars", "set")]
        [char[]] $Charset = [char[]]([char]32..[char]126),

        [Alias("maybe")]
        [string] $MayContain,

        [Alias("chance")]
        [ValidateRange(0, 1)]
        [float] $ChanceMayContain = 0.5,

        [Alias("must")]
        [string] $MustContain,

        [Alias("mustnt")]
        [string] $MustNotContain,

        [Alias("start")]
        [string] $StartsWith,

        [Alias("end")]
        [string] $EndsWith
    )

    # Get the objective length for the output string
    if ($PSCmdlet.ParameterSetName -eq "FixedLength") {
        $ObjectiveLength = $Length
    }
    elseif ($PSCmdlet.ParameterSetName -eq "VariableLength") {
        $ObjectiveLength = Get-RandomElement -LowerBound $MinLength -UpperBound $MaxLength
    }

    # If the MayContain parameter is specified, determine if the string will be present in the output
    if (-not [string]::IsNullOrEmpty($MayContain)) {
        $RandomChance = (Get-RandomElement -LowerBound 0 -UpperBound 100) / 100
        if ($RandomChance -le $ChanceMayContain) {
            # The string will be present in the output
            $ObjectiveLength -= $MayContain.Length

            $WillContainOptional = $true
        }
        else {
            # The string will not be present in the output
            $WillContainOptional = $false
        }
    }
    else {
        $WillContainOptional = $false
    }

    # If the MustContain parameter is specified, ensure that the string will be present in the output
    if (-not [string]::IsNullOrEmpty($MustContain)) {
        $ObjectiveLength -= $MustContain.Length
    }

    # If the StartsWidth parameter is specified, ensure that the string will be present at the beginning of the output
    if (-not [string]::IsNullOrEmpty($StartsWith)) {
        $ObjectiveLength -= $StartsWith.Length
    }

    # If the EndsWith parameter is specified, ensure that the string will be present at the end of the output
    if (-not [string]::IsNullOrEmpty($EndsWith)) {
        $ObjectiveLength -= $EndsWith.Length
    }

    $Output = @()

    if ($ObjectiveLength -ge 0) {
        # Generate a random string of the objective length
        for ($i = 0; $i -lt $ObjectiveLength; $i++) {
            $Output += @(Get-RandomElement -Object $Charset)
        }
    }
    else {
        throw "A bogus string cannot have a negative length."
    }

    # If the MayContain parameter is specified, add the string to the output
    if (!([string]::IsNullOrEmpty($MayContain)) -and $WillContainOptional) {
        # Add the string to the output
        $Output += @($MayContain)
    }

    # If the MustContain parameter is specified, add the string to the output
    if (!([string]::IsNullOrEmpty($MustContain))) {
        # Add the string to the output
        $Output += @($MustContain)
    }

    # If the MustNotContain parameter is specified and it isn't the same as the MustContain or MayContain parameters, ensure that the string will not be present in the output
    if (!([string]::IsNullOrEmpty($MustNotContain)) -and !($MustNotContain.Contains($MustContain)) -and !($MustNotContain.Contains($MayContain)) -and !($MayContain.Contains($MustNotContain)) -and !($MustContain.Contains($MustNotContain))) {
        if ($Output -join "" -match $MustNotContain) {
            # The string is present in the output, generate a new string
            $Output = Get-String @PSBoundParameters
        }
    }

    if ($Output -isnot [string]) {
        # Scramble the output
        $Output = @($Output | Sort-Object { Get-Random })

        # Convert the output to a string
        $Output = $Output -join ""
    }

    # If the StartsWith parameter is specified, add the string to the beginning of the output
    if (!([string]::IsNullOrEmpty($StartsWith)) -and !($Output.StartsWith($StartsWith))) {
        # Add the string to the beginning of the output
        $Output = $StartsWith + $Output
    }

    # If the EndsWith parameter is specified, add the string to the end of the output
    if (!([string]::IsNullOrEmpty($EndsWith)) -and !($Output.EndsWith($EndsWith))) {
        # Add the string to the end of the output
        $Output += $EndsWith
    }

    return $Output
}