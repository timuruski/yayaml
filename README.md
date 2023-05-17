# YAY

Yay is a command line tool for searching YAML files. It's particlularly useful for finding
values or paths for localization files, by searching across multiple YAML files.

If you want to find the key for a given string:

```
$ yay "Foo Bar" locales/*.yml

en-US.foo.bar.qux:1996: Foo Bar Qux
en-GB.foo.bar.qux:1990: Foo Bar Qux
```

If you want to find a value for a given key:

```
$ yay -p "foo.bar" locales/*.yml

en-US.foo.bar:1996: Foo Bar
en-GB.foo.bar:1990: Foo Bar
```

Searches can be regular expressions, and/or case-insensitive.
YAML files will be globbed if a directory is provided.

---

See also to [jq](https://github.com/stedolan/jq)
