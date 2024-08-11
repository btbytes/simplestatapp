# Simple Static Application

This is an illustrative example of how to build statically linked nim application
that produce very small single exeuctables (in the order of few MBs).

This application uses [Nim Language](//nim-lang.org), which compiles down to C, and subsequently to
a small, performant, standalone binary.

This simple web application uses the [Prologue](https://planety.github.io/prologue/) web framework
to present the table at the bottom of the page, which is data rendered from reading the
`students.db` SQLite database, which has a single table "users" with 10 dummy student records.

The table is the result of querying the sqlite database on every request and rendering
it as an HTML table.

In order to present this page, the following dependencies were statically linked:

1. SQLite3
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

You can see also see the image size during this [fly.io](//fly.io) deployment.

![fly.io deployment image size](//files.btbytes.com/images/2024/08/simplestatapp-flyio.webp)

The code for this application is at <https://github.com/btbytes/simplestatapp/>, and hosted on
fly.io - <https://simplestatapp.fly.dev/>

If you are curious about all the things that get added, built, and copied, you can inspect the `Dockerfile`
or take a look at the actual docker build [with github actions](https://github.com/btbytes/simplestatapp/actions/runs/10336115562/job/28611490435).

And without much ado, the table:
