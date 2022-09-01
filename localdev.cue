package todoapp

// import (
// 	"dagger.io/dagger"
// )

client: {
	filesystem: {
        "./build/client": write: contents: actions.build_client.output
        "./build/server": write: contents: actions.build_server.export.directories."/out"
    }
}

actions: {} // not sure why this is necessary

// actions: deploy: {
// 	token: client.env.NETLIFY_TOKEN
// 	site:  "\(client.env.USER)-dagger-todoapp"
// }
