# DAVINCI PowerShell Module

[![PowerShell Gallery - PSDaVinci](https://img.shields.io/badge/PowerShell%20Gallery-PsEnbrea-blue.svg)](https://www.powershellgallery.com/packages/PsDaVinci)
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-7-blue.svg)](https://github.com/stuebersystems/psdavinci)
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1-blue.svg)](https://github.com/stuebersystems/psdavinci)

## Einführung

PSDaVinci ist ein [PowerShell-Modul](https://www.powershellgallery.com/packages/PsDaVinci) zur Orchestrierung von Datenimporten nach DAVINCI bzw. Datenexporten aus DAVINCI. 

## Systemvoraussetzungen

PSDaVinci läuft unter Microsoft PowerShell 7 und PowerShell 5.1. Eine kurze Einführung in PowerShell 7 (inklusive Abgrenzung zu Microsoft PowerShell 5.1) findet sich in folgendem [Blog-Artikel](https://blog.stueber.de/posts/powershell7-unter-windows-10/).

### PowerShell 7

PowerShell 7 ist nicht Bestandteil von Windows, muss also explizit installiert werden:

1. Lade die [aktuelle Windows-Version von PowerShell 7 auf GitHub](https://github.com/PowerShell/PowerShell/releases/latest) herunter. In der Regel wird dies das MSI-Paket für Windows 64bit sein (z.B. PowerShell-7.1.3-win-x64.msi).

2. Starte das MSI-Paket auf Deinem Computer und folge den Anweisungen.

Die Ausführung von PowerShell-Skripten unter Windows 10 ist standardmäßig nicht erlaubt. Dies kann man als Administrator jedoch ändern:

1. Starte PowerShell als Administrator: `Start > PowerShell > PowerShell 7 (x64)`

2. Tippe `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned ` ein und bestätige.

Mehr Infos zum Cmdlet `Set-ExecutionPolicy` findest Du in der [Microsoft-Dokumentation](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-6).

### Microsoft PowerShell 5.1

**PowerShell 5 ist ab Windows 2016 bzw. ab Windows 10 bereits vorinstalliert**, für ältere Windows-Systeme (Windows 7 Service Pack 1, Windows 8.1, Windows Server 2008 R2, Windows Server 2012, Windows Server 2012 R2) muss das Windows Management Framework 5.1 installiert werden:

1. Installiere die .NET Framework Runtime (4.5 oder höher): https://dotnet.microsoft.com/download

2. Installiere das Windows Management Framework 5.1 (enthält Microsoft PowerShell 5.1): https://www.microsoft.com/en-us/download/details.aspx?id=54616

Die Ausführung von PowerShell-Skripten unter Windows 10 ist standardmäßig nicht erlaubt. Dies kann man als Administrator jedoch ändern:

1. Starte PowerShell als Administrator: `Start > Windows PowerShell > Windows PowerShell`

2. Tippe `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned ` ein und bestätige.

Mehr Infos zum Cmdlet `Set-ExecutionPolicy` findest Du in der [Microsoft-Dokumentation](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-5.1).

## PSDaVinci installieren

Vorgehensweise:

1. Starte PowerShell (Microsoft PowerShell 7 oder PowerShell 5.1)

2. Tippe `Install-Module PsDaVinci` ein und bestätige.

## PSDaVinci aktualisieren

Vorgehensweise:

1. Starte PowerShell (Microsoft PowerShell 7 oder PowerShell 5.1)

2. Tippe `Update-Module PsDaVinci` ein und bestätige.

## Dokumentation

Die Dokumentation der Cmdlets findest Du im [GitHub-Wiki](https://github.com/stuebersystems/psdavinci/wiki).

## Kann ich mithelfen?

Ja, sehr gerne. Der beste Weg mitzuhelfen ist es, den Quellcode auszuprobieren, Rückmeldung per Issue-Tracker zu geben und/oder eigene Pull-Requests zu generieren. 

## Code of conduct (Verhaltensregeln)

In diesem Projekt wurde der [STÜBER SYSTEMS Code of conduct](https://www.stueber.de/code-of-conduct.php) übernommen.
