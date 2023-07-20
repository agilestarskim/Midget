import Foundation

public struct MidgetDescription {
    let edit: String
    let done: String
    let alertTitle: String
    let alertMessage: String
    let alertCancel: String
    let alertRemove: String
    
    public init (
        edit: String = "Edit",
        done: String = "Done",
        alertTitle: String = "Remove Widget?",
        alertMessage: String = "Removing this widget will not delete any data.",
        alertCancel: String = "Cancel",
        alertRemove: String = "Remove"
    ) {
        self.edit = edit
        self.done = done
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.alertCancel = alertCancel
        self.alertRemove = alertRemove
    }
}
