import Vapor

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
