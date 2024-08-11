import prologue
import db_connector/db_sqlite
import strutils
import std/[os]
import markdown

proc getStudents(): string =
  let db = open("students.db", "", "", "")
  defer: db.close()

  let rows = db.getAllRows(sql"SELECT * FROM users")

  var result = """<!doctype html>
  <head><title>simple static app</title>
    <link rel=stylesheet href=https://cdn.jsdelivr.net/npm/water.css@2/out/water.css>
  </head>
  <body>"""
  var readme = readFile("README.md")
  result.add(markdown(readme))
  result.add("<table border='1'><tr><th>ID</th><th>Name</th><th>Age</th><th>Class</th></tr>")
  for row in rows:
    result.add("<tr>")
    for cell in row:
      result.add("<td>" & cell & "</td>")
    result.add("</tr>")
  result.add("</table></body></html>")

  return result

proc hello(ctx: Context) {.async.} =
  let students = getStudents()
  resp students

let app = newApp()
app.get("/", hello)

when isMainModule:
  app.run()
