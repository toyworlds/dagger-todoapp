package todoapp

// import (
// 	"dagger.io/dagger"
// )

client: {
	filesystem: {
        "./build/client": write: contents: actions.build.client.output
        "./build/server": write: contents: actions.build.server.export.directories."/out"
    }
}

actions: {} // not sure why this is necessary
