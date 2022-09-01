package todoapp

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"

	"universe.dagger.io/yarn"
	"universe.dagger.io/bash"
    "universe.dagger.io/docker"
)

dagger.#Plan & {
	actions: {
		// Load the todoapp source code 
		source: core.#Source & {
			path: "."
			exclude: [
				"node_modules",
				"build",
				"*.cue",
				"*.md",
				".git",
			]
		}

        _pull_dotnet: docker.#Pull & {
            source: "mcr.microsoft.com/dotnet/sdk:6.0"
        }

        _checkoutServer: core.#Source & {
            path: "Server"
        }

        // Build server
        build_server: bash.#Run & {
            input: _pull_dotnet.output
            mounts: "server project files": {
                contents: _checkoutServer.output
                dest: "/server"
            }

            script: contents: """
            ls /server -l
            dotnet build /server/Server.fsproj -o ./out
            """

            export: directories: "/out": dagger.#FS
        }

        // Build app
		build_client: yarn.#Script & {
            name:   "build"
            source: actions.source.output
        }

		// Test todoapp
		test: yarn.#Script & {
			name:   "test"
			source: actions.source.output

			// This environment variable disables watch mode
			// in "react-scripts test".
			// We don't set it for all commands, because it causes warnings
			// to be treated as fatal errors.
			// See https://create-react-app.dev/docs/advanced-configuration
			container: env: CI: "true"
		}
	}
}
