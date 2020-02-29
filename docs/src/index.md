
# Oracle.jl

This package provides a driver to access Oracle databases using the Julia language,
based on [ODPI-C](https://github.com/oracle/odpi) bindings.

## Development Notice

This package is under active development. Under version v0.1.0, there will be no deprecation warnings for API changes.

You can check the [release notes](https://github.com/felipenoris/Oracle.jl/releases) for a list of API changes between versions.

## Requirements

* [Julia](https://julialang.org/) v1.0 or newer.

* Oracle's [Instant Client](https://www.oracle.com/technetwork/database/database-technologies/instant-client/overview/index.html).

* Linux or macOS.

* C compiler.

## Instant Client installation

This package requires Oracle's [Instant Client](https://www.oracle.com/technetwork/database/database-technologies/instant-client/overview/index.html).

To install it, follow these instructions:

* [Download](https://www.oracle.com/technetwork/database/database-technologies/instant-client/downloads/index.html) instant client.

* Unzip and add `instantclient` folder to your LD_LIBRARY_PATH:

```shell
export LD_LIBRARY_PATH=/path-to-folder/instantclient_XX_Y:$LD_LIBRARY_PATH
```

Check [ODPI-C documentation](https://oracle.github.io/odpi/doc/installation.html),
or [Instant Client documentation](https://www.oracle.com/technetwork/database/database-technologies/instant-client/documentation/index.html)
for alternative installation methods.

[libaio](https://pagure.io/libaio) is a dependency of Instant Client.

If you have root access to your machine, you can install it using the package manager, as in:

```shell
yum -y install libaio
```

If you don't have root access to your machine, you can compile it from source
and set your `LD_LIBRARY_PATH` environment variable to point to the library.

The compilation can be done using the following script:

```shell
wget https://pagure.io/libaio/archive/libaio-0.3.111/libaio-libaio-0.3.111.tar.gz
tar xf libaio-libaio-0.3.111.tar.gz
cd libaio-libaio-0.3.111
make prefix=$HOME/local
make install prefix=$HOME/local
```

Then add the following to your shell profile (`$HOME/.bashrc`):

```shell
export LD_LIBRARY_PATH=$HOME/local/lib:$LD_LIBRARY_PATH
```

## Package installation

```julia
julia> Pkg.add("Oracle")
```

## Installation on Jupyter environment

When loading this package on a Jupyter Notebook environment
you might get this error:

```
InitError: DPI-1047: Cannot locate a 64-bit Oracle Client library: "libclntsh.so: cannot open shared object file: No such file or directory"
```

First, check that the package loads outside the Jupyter environment.
If it does work, than the problem is that `LD_LIBRARY_PATH` is not set
in the Jupyter environment.

To solve this, edit your `kernel.json` file, usually located at `~/.local/share/jupyter/kernels/julia-v`
where `v` is the Julia version, and add an environment variable for your `LD_LIBRARY_PATH`,
as in the following example, where `/myhomedir/local/instantclient_18_3` is the location for
the instant client library.

```json
{
  "display_name": "Julia 1.1.0",
  "argv": [
    "env",
    "LD_LIBRARY_PATH=/myhomedir/local/instantclient_18_3",
    "/myhomedir/local/julia-1.1.0/bin/julia",
    "-i",
    "--startup-file=yes",
    "--color=yes",
    "--project=@.",
    "/myhomedir/.julia/packages/IJulia/gI2uA/src/kernel.jl",
    "{connection_file}"
  ],
  "language": "julia",
  "env": {},
  "interrupt_mode": "signal"
}
```

## License

The source code for the package *Oracle.jl* is licensed under the [MIT License](https://github.com/felipenoris/Oracle.jl/blob/master/LICENSE).

During installation, *Oracle.jl* downloads the source code and compile the library [ODPI-C](https://github.com/oracle/odpi)
which is licensed under [The Universal Permissive License (UPL), Version 1.0](https://oracle.github.io/odpi/doc/license.html) and/or the [Apache License](https://oracle.github.io/odpi/doc/license.html).
