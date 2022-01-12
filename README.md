# winget-pkgs

Self-hosted packages for the [Windows Package Manager](https://github.com/microsoft/winget-cli), a.k.a. "winget".

Replicates the layout of [Microsoft's community repository](https://github.com/microsoft/winget-pkgs/).

## Usage

Tell winget about this repo

```bash
winget sources add https://github.com/cloudflightio/winget-pkgs
``` 

Install packages like you would any other
```bash
winget install Cloudflight/DockerInWSL
```
