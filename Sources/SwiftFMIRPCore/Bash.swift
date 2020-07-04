import Foundation

protocol CommandExecuting {
    func run(commandName: String, arguments: [String]) -> String?
}

struct Bash: CommandExecuting {

    func run(commandName: String, arguments: [String] = []) -> String? {
        guard var bashCommand = run(command: "/bin/bash" , arguments: ["-l", "-c", "which \(commandName)"]) else { return "\(commandName) not found" }
        bashCommand = bashCommand.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        return run(command: bashCommand, arguments: arguments)
    }

    private func run(command: String, arguments: [String] = []) -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: command)
        process.arguments = arguments
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        let _ = try! process.run()
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: outputData, as: UTF8.self)
        return output
    }
}
