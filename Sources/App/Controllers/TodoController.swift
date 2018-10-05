import Vapor
import URLEncodedForm

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        Todo.query(on: req).all().map(to: [Todo].self) { todoList in
            let todoListString = todoList.reduce("Todo list(\(todoList.count)): \n"){$0 + "  \($1.id!). \($1.title) \n"}
            print("todoListString \(todoListString)")
            let res = try req.client().post("https://hooks.slack.com/services/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"){ post in
                post.http.contentType = .json
                try post.content.encode("""
                    {"text": "\(todoListString)"}
                    """)
            }
            print(res)
            return todoList
        }

        return Todo.query(on: req).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        guard req.http.contentType == .json else {
            print(req.http.contentType)
            let slackCommand = try URLEncodedFormDecoder().decode(SlackCommand.self, from: String(data: req.http.body.data!, encoding: .utf8) ?? "")
            if slackCommand.command == "/otoadd" {
                let slackTodo = Todo(id: nil, title: slackCommand.text)
                print(slackTodo)
                let res = try req.client().post("https://hooks.slack.com/services/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"){ post in
                    post.http.contentType = .json
                    try post.content.encode("""
                        {"text": "Add `\(slackTodo.title)` to the list"}
                        """)
                }
                debugPrint(res)
                return slackTodo.save(on: req)
            } else {
                // show list
                // slackCommand.command == "/list"
                Todo.query(on: req).all().map(to: [Todo].self) { todoList in
                    let todoListString = todoList.reduce("Todo list(\(todoList.count)): \n"){$0 + "  \($1.id!). \($1.title) \n"}
                    print("todoListString \(todoListString)")
                    let res = try req.client().post("https://hooks.slack.com/services/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"){ post in
                        post.http.contentType = .json
                        try post.content.encode("""
                            {"text": "\(todoListString)"}
                            """)
                    }
                    print(res)
                    return todoList
                }
                return Todo.query(on: req).first().map{
                    let todo = $0 ?? Todo(title: "Undefine")
                    return todo
                }
            }

        }
        return try req.content.decode(Todo.self).flatMap { todo in
            let res = try req.client().post("https://hooks.slack.com/services/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"){ post in
                post.http.contentType = .json
                try post.content.encode("""
                    {"text": "Add `\(todo.title)` to the list"}
                    """)
            }
            print("todo: \(todo.title)")
            debugPrint(res)
            return todo.save(on: req)
        }

    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
}


