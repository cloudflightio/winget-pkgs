# winget-pkgs

Self-hosted packages for the [Windows Package Manager](https://github.com/microsoft/winget-cli), a.k.a. "winget".

Replicates the layout of [Microsoft's community repository](https://github.com/microsoft/winget-pkgs/).

## Usage

For now you can use either a local or legacy source approach. A self-hosted v1.0 REST API repository might follow at a later point in time. Some Packages might be released to the official community source, but this is currently out of scope.

### Custom Remote Source

> Use this if you do not want to install any additional software (like git) or enable some dev-featues. Is it the recommended way to use this repo because it supports automatic updates and is very easy to use. 

Just add our repository as new source.

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

### Local / Dev

> Use this approach if you want to be in full controll over the installed manifests. This does not support automatic updates.

First, you have to enable local WinGet Repositories. Open a new Powershell windows "As Administrator" and type the following command:

```bat
winget settings --enable LocalManifestFiles
``` 

After that you can install local manifest files. Clone or download this Repo, unpack and manually install a package like this:

```bat
winget install -m .\manifests\c\Cloudflight\DockerInWSL\1.0.2.1\264a-Cloudflight.DockerInWSL.yaml
```
