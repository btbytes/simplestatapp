# Simple Static Application

This is an illustrative example of how to build statically linked nim application
that produce very small single exeuctables (in the order of few MBs).

This application uses [Nim Language](//nim-lan.org), which compiles down to C.

This application uses the [Prologue](https://planety.github.io/prologue/) web framework to present the table below,
which is data rendered from reading the `students.db` database, which has a single table "users"
with 10 dummy student records.

The table below is the result of querying the sqlite database on every request and rendering
it as an HTML table.

In order to present this page, the following dependencies were statically linked:

1. sqlite3
1. PCRE

and the following nim libraries were also compiled in:

1. `prologue` (and all it's dependencies)
1. `db_connector`
1. `markdown`

The resulting standalone docker image is a mere 5.64mb all dependencies included.

```
$ docker image ls simplestatapp
REPOSITORY      TAG       IMAGE ID       CREATED         SIZE
simplestatapp   latest    9d3dc3a9cc58   3 minutes ago   5.64MB
```

And without much ado, the table:
