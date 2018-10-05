//
//  SlackCommand.swift
//  App
//
//  Created by lee on 2018/10/5.
//

import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class SlackCommand: SQLiteModel {
    /// The unique identifier for this `Todo`.
    var id: Int?

    /// A title describing what this `Todo` entails.
    var token: String
    var team_id: String
    var team_domain: String
//    var enterprise_id: String
//    var enterprise_name: String
    var channel_id: String
    var channel_name: String
    var user_id: String
    var user_name: String
    var command: String
    var text: String
    var response_url: String
    var trigger_id: String
//    token=gIkuvaNzQIHg97ATvDxqgjtO
//    &team_id=T0001
//    &team_domain=example
//    &enterprise_id=E0001
//    &enterprise_name=Globular%20Construct%20Inc
//    &channel_id=C2147483705
//    &channel_name=test
//    &user_id=U2147483697
//    &user_name=Steve
//    &command=/weather
//    &text=94070
//    &response_url=https://hooks.slack.com/commands/1234/5678
//    &trigger_id=13345224609.738474920.8088930838d88f008e0

    /// Creates a new `SlackCommand`.
    init(id: Int? = nil, text: String) {
        self.id = id
        self.token = ""
        self.team_id = ""
        self.team_domain = ""
//        self.enterprise_id = ""
//        self.enterprise_name = ""
        self.channel_id = ""
        self.channel_name = ""
        self.user_id = ""
        self.user_name = ""
        self.command = ""
        self.text = text
        self.response_url = ""
        self.trigger_id = ""
    }
}

/// Allows `SlackCommand` to be used as a dynamic migration.
extension SlackCommand: Migration { }

/// Allows `SlackCommand` to be encoded to and decoded from HTTP messages.
extension SlackCommand: Content { }

/// Allows `SlackCommand` to be used as a dynamic parameter in route definitions.
extension SlackCommand: Parameter { }

