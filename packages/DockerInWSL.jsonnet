local wg = import "winget_package.libsonnet";

local product = {
    PackageIdentifier: 'Cloudflight.DockerInWSL',
    PackageLocale: 'en-US',
    Publisher: 'Cloudflight Austria GmbH',
    PublisherUrl: 'https://cloudflight.io',
    PublisherSupportUrl: 'https://github.com/cloudflightio/dockerinwsl',
    Author: 'Cloudflight Austria GmbH',
    PackageName: 'DockerInWSL',
    PackageUrl: 'https://github.com/cloudflightio/dockerinwsl',
    License: 'Apache2',
    Copyright: 'Copyright (c) Cloudflight Austria GmbH',
    ShortDescription: 'Using WSL2 to run a docker on windows (using official dind alpine image)',
    Moniker: 'dockerinwsl',
    Tags: [
      'docker',
      'wsl2',
    ]
};

wg.Release(product, {
    PackageVersion: '1.0.0.0',
    InstallerUrl: 'https://github.com/cloudflightio/dockerinwsl/releases/download/v1.0.0/DockerInWSL.msi',
    InstallerSha256: '30144F947FE1F9E9F169636449B151D66BE3390EF6441034EE6BD13F76B1F9F7',
    ProductCode: '{5B14896C-A16E-4F22-AE96-257772DE655A}'
}) + wg.Release(product, {
    PackageVersion: '1.0.1.0',
    InstallerUrl: 'https://github.com/cloudflightio/dockerinwsl/releases/download/v1.0.1/DockerInWSL.msi',
    InstallerSha256: '1AF46E89D8F7CEA9F59C2ACBFC722CAA3FFED89AEBC7A5B9D59ED9F518EFE428',
    ProductCode: '{F4DBB524-EC40-4813-91F6-DE51E026EB74}'
}) + wg.Release(product, {
    PackageVersion: '1.0.2.1',
    InstallerUrl: 'https://github.com/cloudflightio/dockerinwsl/releases/download/v1.0.2/DockerInWSL.msi',
    InstallerSha256: '54CCE5B191624F0D6F9F4AA6C3FFF151911BDB7A5BFF164B37E3FBD22D0B8CCD',
    ProductCode: '{0ED616E8-9DDC-43C5-8A40-6F1B3CB4A3E4}'
})