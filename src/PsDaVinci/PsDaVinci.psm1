# Copyright (c) STÜBER SYSTEMS GmbH. All rights reserved.
# Licensed under the MIT License.

Import-LocalizedData -BindingVariable stringTable

<#
 .Synopsis
  Creates a new JSON configuration template for the 'Start-DaVinciImport' cmdlet

 .Description
  This cmdlet will copy a template josn file to the target destination. You must adapt 
  the configuration to your needs by opening the configuration file in a text editor.
  
 .Parameter ConfigFile
  The file name of the JSON configuration file. If this file exists already this cmdlet 
  will terminate with an error.

 .Example
  # Adds a configuration template for DAVINCI imports
  Initialize-DaVinciImport -ConfigFile MyImportConfig.json

  .Example
  # Adds a configuration template for DAVINCI imports (short form)
  Initialize-DaVinciImport MyImportConfig.json
#>
function Initialize-DaVinciImport {
	param(
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]
		$ConfigFile
	)
	process
	{
		try
		{
			$ConfigPath = GetFullConfigPath -ConfigFile $ConfigFile
			$ConfigTemplatePath = GetConfigTemplatePath -TemplateName "Import"

			if (-not (Test-Path -Path $ConfigPath))
			{
				Copy-Item $ConfigTemplatePath -Destination $ConfigPath
			}
			else 
			{
				throw ([string]::Format($stringTable.ErrorFileExists, $ConfigPath))
			}
		}
		catch
		{
			$ErrorMessage = $_.Exception.Message
			Write-Error $ErrorMessage
		}
	}
}

<#
 .Synopsis
  Creates a new JSON configuration template for the 'Start-DaVinciExport' cmdlet

 .Description
  This cmdlet will copy a template josn file to the target destination. You must adapt 
  the configuration to your needs by opening the configuration file in a text editor.
  
 .Parameter ConfigFile
  The file name of the JSON configuration file. If this file exists already this cmdlet 
  will terminate with an error.

 .Example
  # Adds a configuration template for DAVINCI exports
  Initialize-DaVinciExport -ConfigFile MyExportConfig.json

  .Example
  # Adds a configuration template for DAVINCI exports (short from)
  Initialize-DaVinciExport MyExportConfig.json
#>
function Initialize-DaVinciExport {
   param(
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]
		$ConfigFile
	)
	process
	{
		try
		{
			$ConfigPath = GetFullConfigPath -ConfigFile $ConfigFile
			$ConfigTemplatePath = GetConfigTemplatePath -TemplateName "Export"

			if (-not (Test-Path -Path $ConfigPath))
			{
				Copy-Item $ConfigTemplatePath -Destination $ConfigPath
			}
			else 
			{
				throw ([string]::Format($stringTable.ErrorFileExists, $ConfigPath))
			}
		}
		catch
		{
			$ErrorMessage = $_.Exception.Message
			Write-Error $ErrorMessage
		}
	}
}

<#
 .Synopsis
  Starts a new import from a supported source to DAVINCI.

 .Description
  This cmdlet will start a new import from a supported source to DAVINCI. 

 .Parameter Source
  The name of a supported import source. Currently supported is 'ecf'.

 .Parameter ConfigFile
  The file name of the JSON configuration file. 

 .Example
  # Starts an import from ECF to DAVINCI
  Start-DaVinciImport -Source ecf -ConfigFile MyImportConfig.json

 .Example
  # Starts an import from ECF to DAVINCI (short form)
  Start-DaVinciImport ecf MyImportConfig.json
#>
function Start-DaVinciImport {
	param(
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[ImportSource]
		$Source,
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]
		$ConfigFile
	)
	process
	{
		try
		{
			$ConfigPath = GetFullConfigPath -ConfigFile $ConfigFile
			$Config = GetConfig -Config $ConfigPath
		
			switch ($Source)
			{
				([ImportSource]::ecf) { RunDavConsole -Command "export" -Provider "ecf" -Config $Config }
			}
		}
		catch
		{
			$ErrorMessage = $_.Exception.Message
			Write-Error $ErrorMessage
		}
	}
}

<#
 .Synopsis
  Starts a new export from DAVINCI to a supported target.

 .Description
  This cmdlet will start a new export from DAVINCI to a supported target.

 .Parameter Source
  The name of a supported export target. Currently supported are 'sdui', 'iserv' 
  and 'ecf'.

 .Parameter ConfigFile
  The file name of the JSON configuration file. 

 .Example
  # Starts an export from DAVINCI to Ecf
  Start-DaVinciExport -Target ecf -ConfigFile MyExportConfig.json

 .Example
  # Starts an export from DAVINCI to Ecf (short form)
  Start-DaVinciExport ecf MyExportConfig.json
#>
function Start-DaVinciExport {
	param(
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[ExportTarget]
		$Target,
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]
		$ConfigFile
	)
	process
	{
		try
		{
			$ConfigPath = GetFullConfigPath -ConfigFile $ConfigFile
			$Config = GetConfig -Config $ConfigPath

			switch ($Target)
			{
				([ExportTarget]::sdui)  { RunDavConsole -Command "export" -Provider "sdui" -Config $Config }
				([ExportTarget]::iserv) { RunDavConsole -Command "export" -Provider "iserv" -Config $Config }
				([ExportTarget]::ecf)   { RunDavConsole -Command "export" -Provider "ecf" -Config $Config }
			}
		}
		catch
		{
			$ErrorMessage = $_.Exception.Message
			Write-Error $ErrorMessage
		}
	}
}

function RunDavConsole{
	param(
		[string]
		$Command,
		[string]
		$Provider,
		[PSObject]
		$Config
	)
	process
	{
		Write-Host $stringTable.StartDaVinciConsole -ForegroundColor $Host.PrivateData.VerboseForegroundColor

		$ConsolePath = GetDavConsolePath -Config $Config

		if (($ConsolePath) -and (Test-Path -Path $ConsolePath -PathType Leaf))
		{
			$CurrentLocation = Get-Location
			Set-Location -Path (Split-Path -Path $ConfigPath)
			try
			{   
				Invoke-Expression "& ""$($consolePath)"" $($Command) -p ""$($Provider)"" -c ""$($ConfigPath)"""
			}
			finally 
			{
				Set-Location -Path $CurrentLocation
			}

			if ($LASTEXITCODE -ne 0)
			{
				$ErrorMessage = $stringTable.ErrorDaVinciConsoleFailed
				throw $ErrorMessage
			}
		}
		else
		{
			$ErrorMessage = ([string]::Format($stringTable.ErrorDaVinciConsoleNotFound, $ConsolePath)) 
			throw $ErrorMessage
		}
	}
}

function GetConfig {
	param(
		[string]
		$ConfigPath
	)
	process
	{
		if (($ConfigPath) -and (Test-Path -Path $ConfigPath -PathType leaf))
		{
			return Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json
		}
		else
		{
			return "{}" | ConvertFrom-Json
		}
	}
}

function GetConfigTemplatePath {
	param(
		[string]
		$TemplateName
	)
	process
	{
		return Join-Path -Path $PSScriptRoot -ChildPath "PsDaVinci.Template.$($TemplateName).json"
	}
}

function GetFullConfigPath {
	param(
		[string]
		$ConfigFile
	)
	process
	{
		$ConfigPath = $ConfigFile
		
		if ((Split-Path -Path $ConfigPath -Leaf) -eq $ConfigPath)
		{
			$ConfigPath = Join-Path -Path (Get-Location) -ChildPath $ConfigPath
		}

		if (-not (Test-Path -Path $ConfigPath -PathType Leaf))
		{
			if (-not ([IO.Path]::HasExtension($ConfigPath)))
			{
				$ConfigPath = [IO.Path]::ChangeExtension($ConfigPath, "json")
			}
		}

		return $ConfigPath
	}
}

function GetDavConsolePath {
	param(
		[PSObject]
		$Config
	)
	process
	{
		if ($Config)
		{
			if ($Config.PsDaVinci.Tools.DaVinciConsole)
			{
				return $config.PsDaVinci.Tools.DaVinciConsole
			}
		}
		
		$RegKey64 = "HKLM:\SOFTWARE\WOW6432Node\Stueber Systems\daVinci 6\Main"
		$RegKey32 = "HKLM:\SOFTWARE\Stueber Systems\daVinci 6\Main"

		if ([Environment]::Is64BitProcess)
		{
			if (Test-Path -Path $RegKey64)
			{
				$RegKey = Get-ItemProperty -Path $RegKey64 -Name BinFolder
				return Join-Path -Path $RegKey.BinFolder -ChildPath "daVinciConsole.exe"
			}
			else
			{
				return $null
			}
		}
		else
		{
			if (Test-Path -Path $RegKey32)
			{
				$RegKey = Get-ItemProperty -Path $RegKey32 -Name BinFolder
				return Join-Path -Path $RegKey.BinFolder -ChildPath "daVinciConsole.exe"
			}
			else
			{
				return $null
			}
		}
	
	}
}

# List of supported import sources
Enum ImportSource {
	ecf
}

# List of supported export targets
Enum ExportTarget {
	sdui,
	iserv,
	ecf
}

Export-ModuleMember -Function Initialize-DaVinciImport
Export-ModuleMember -Function Initialize-DaVinciExport
Export-ModuleMember -Function Start-DaVinciImport
Export-ModuleMember -Function Start-DaVinciExport
