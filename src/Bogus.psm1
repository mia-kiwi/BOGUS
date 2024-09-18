$ErrorActionPreference = "Stop"

Write-Verbose -Message "Detecting module files."
$Public = @(Get-ChildItem (Join-Path -Path $PSScriptRoot -ChildPath "Public") -ErrorAction SilentlyContinue -Filter "*.ps1")
$Private = @(Get-ChildItem (Join-Path -Path $PSScriptRoot -ChildPath "Private") -ErrorAction SilentlyContinue -Filter "*.ps1")
$Classes = @(Get-ChildItem (Join-Path -Path $PSScriptRoot -ChildPath "Classes") -ErrorAction SilentlyContinue -Filter "*.class.ps1")

# Classes that need to be loaded first
$ClassDependencies = @()

# Load dependency classes
if ($ClassDependencies.Count -gt 0) {
    Write-Verbose -Message "Loading dependency classes."
    foreach ($Class in $ClassDependencies) {
        Write-Verbose -Message "+ Loading class [$Class]."

        try {
            . (Join-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath "Classes") -ChildPath "$Class.class.ps1")
        }
        catch {
            Write-Error -Message "Failed to load class [$Class]: $_"
        }
    }
}

# Load other classes
if ($Classes.Count -gt 0) {
    Write-Verbose -Message "Loading classes."
    foreach ($Class in $Classes | Where-Object -FilterScript { $_.Name -replace "\.class\.ps1" -notin $ClassDependencies }) {
        Write-Verbose -Message "+ Loading class [$($Class.Name -replace "\.class\.ps1")]."
        
        try {
            . $Class.FullName
        }
        catch {
            Write-Error -Message "Failed to load class [$($Class.Name -replace "\.class\.ps1")]: $_"
        }
    }
}

# Dot-source private files
if ($Private.Count -gt 0) {
    Write-Verbose -Message "Dot-sourcing private files."
    foreach ($File in $Private) {
        Write-Verbose -Message "+ Dot-sourcing file $($File.FullName.Replace($PSScriptRoot, ''))."

        try {
            . $File.FullName
        }
        catch {
            Write-Error -Message "Failed to dot-source file $($File.FullName.Replace($PSScriptRoot, '')): $_"
        }
    }
}

# Dot-source public files
if ($Public.Count -gt 0) {
    Write-Verbose -Message "Dot-sourcing module files."
    foreach ($File in $Public) {
        Write-Verbose -Message "+ Dot-sourcing file [$($File.FullName.Replace($PSScriptRoot, ''))]."

        try {
            . $File.FullName
        }
        catch {
            Write-Error -Message "Failed to dot-source file [$($File.FullName.Replace($PSScriptRoot, ''))]: $_"
        }
    }

    # Export module functions
    Write-Verbose -Message "Exporting module functions: [$($Public.BaseName)]."
    Export-ModuleMember -Function $Public.BaseName
}