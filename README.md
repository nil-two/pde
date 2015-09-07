pde
===

Execute processing program quickly.

```
# execute sketch.pde
pde sketch.pde
```

Installation
------------

pde is a simple shell script.

The following instructions assume that `~/bin` is on your `$PATH`.
If that is not the case, you can substitute your favorite location.

```sh
curl -L https://raw.githubusercontent.com/kusabashira/pde/master/pde > ~/bin/pde
chmod 755 ~/bin/pde
```

Requirements
-----------

- processing-java

Usage
-----

```
$ pde [OPTION]... SRC

Options:
  -h, --help      display this help text and exit
  -v, --version   display version information and exit


# execute sketch.pde
pde sketch.pde

# execute ./exercise/first.pde
pde ./exercise/first.pde
```

License
-------

MIT License

Author
------

kusabashira <kusabashira227@gmail.com>
