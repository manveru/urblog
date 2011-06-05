table entry : { Id : int, Title : string, Created : time, Author : string, Body : string }
  PRIMARY KEY Id

open Crud.Make(struct
  val tab = entry

  val title = "Blog Admin"

  val cols = {Title = Crud.string "Blog Title",
              Created = Crud.time "Created",
              Author = Crud.string "Author",
              Body = Crud.string "Entry Body"}
end)

fun list () =
  rows <- queryX (SELECT * FROM entry)
    (fn row =>
      <xml>
        <div>
          <h1><a link={detail row.Entry.Id}>{[row.Entry.Title]}</a></h1>
          <h2>By {[row.Entry.Author]} at {[row.Entry.Created]}</h2>
          <p>{[row.Entry.Body]}</p>
        </div>
      </xml>
    );
  return
    <xml>
      <head>
        <title>All Entries</title>
      </head>
      <body>
        <h1>All Entries</h1>
        {rows}
      </body>
    </xml>

and detail (i : int) =
  res <- oneOrNoRows (SELECT * FROM entry WHERE entry.Id = {[i]});
  return
  (case res of
    None => <xml>
              <head>
                <title>Entry Not Found</title>
              </head>
              <body>
                <h1>Entry Not Found</h1>
              </body>
            </xml>
  | Some r => <xml>
                <head>
                  <title>{[r.Entry.Title]}</title>
                </head>
                <body>
                  <h1>{[r.Entry.Title]}</h1>
                  <h2>By {[r.Entry.Author]} at {[r.Entry.Created]}</h2>
                  <div>
                    <p>{[r.Entry.Body]}</p>
                  </div>
                  <a link={list ()}>Back to all entries</a>
                </body>
              </xml>)

fun main () = return <xml>
  <head><title>UrBlog</title></head>
  <body><h1>UrBlog</h1></body>
</xml>
