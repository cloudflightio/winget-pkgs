local wg = import "winget_package.libsonnet";

local product =  std.parseJson(importstr "./packages/DockerInWSL.product.json");
local releases = std.parseJson(importstr "./packages/DockerInWSL.releases.json");

wg.Files(product, releases)
