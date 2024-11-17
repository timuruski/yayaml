# yayaml

Yayaml is a command line tool for searching YAML files. It's particlularly useful for finding
values or paths for localization files, by searching across multiple YAML files.

YAML files will be globbed if a directory is provided.

If you want to find the key for a given string.

```
$ ya "Foo Bar" locales/

locales/en-US.yml:1996 en-US.foo.bar.qux: Foo Bar Qux
```

If you want to find a value for a given key, you can search the path.

```
$ ya -p "foo.bar" locales/

locales/en-US.yml:1996 en-US.foo.bar: Foo Bar
locales/fr-FR.yml:1990 en-GB.foo.bar: Foo Bar
```
