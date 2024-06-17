# Running

## Running in erlang shell

Start erlang shell:

```sh
erl
```

Compile:

```sh
c(hello).
```

Run:

```sh
hello:start().
```

Stop erlang shell:

```sh
halt().
```

## Compiling and running outside erlang shell

Compile:

```sh
erlc hello.erl
```

Run:

```
erl -noshell -s hello start -s init stop
```
