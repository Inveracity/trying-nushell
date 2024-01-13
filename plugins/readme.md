# Install plugins

To install plugins built in rust, without having rust installed

```sh
docker compose run --rm -it rust

# inside the container
sh /mnt/rust/plugins.sh
exit

# outside the container
register nu_plugin_semver
```
