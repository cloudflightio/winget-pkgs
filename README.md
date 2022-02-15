# winget-pkgs

Self-hosted packages for the [Windows Package Manager](https://github.com/microsoft/winget-cli), a.k.a. "winget".

Replicates the layout of [Microsoft's community repository](https://github.com/microsoft/winget-pkgs/).

## Usage

> ℹ️ A self-hosted v1.0 REST API repository might follow at a later point in time. Some Packages might be released to the official community source, but this is currently out of scope.

To use our packages, just add this repository as new source in winget using the following command.

```powershell
winget source add --name cloudflight https://cloudflightio.github.io/winget-pkgs
```

If you want to update it later run this:

```powershell
winget source update --name cloudflight
```

Now you can install packages hosted in this repository, for example "DockerInWSL":

```powershell
winget install dockerinwsl
```

Just run `winget search -s cloudflight` to get a complete list of packages available from this repo.
