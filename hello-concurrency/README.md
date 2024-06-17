# Erlang File Server and Client

This folder contains two Erlang modules: `afile_server` and `afile_client`. These modules demonstrate basic file operations, such as listing the contents of a directory and reading specific files, implemented in a concurrent system using Erlang's powerful process and message passing capabilities.

## Files

- `afile_server.erl`: The server module, which handles file operations.
- `afile_client.erl`: The client module, which sends requests to the server.

## Running the Application

To run the file server and client, follow these steps in the Erlang shell:

1. Open your terminal and start the Erlang shell:

   ```bash
   erl
   ```

2. Compile the server module:

   ```
   1> c(afile_server).
   {ok,afile_server}
   ```

3. Compile the client module:

   ```
   2> c(afile_client).
   {ok,afile_client}
   ```

4. Start the file server, pointing it to the directory you want to manage (in this example, the current directory `.`):

   ```
   3> FileServer = afile_server:start(".").
   <0.98.0>
   ```

5. Test retrieving a file that does not exist to see the error handling:

   ```
   4> afile_client:get_file(FileServer,"missing").
   {error,enoent}
   ```

6. Test retrieving an existing file (for example, the `afile_server.erl` file itself):

   ```
   5> afile_client:get_file(FileServer,"afile_server.erl").
   {ok,<<"-module(afile_server).\n\n-export([start/1, loop/1]).\n\nstart(Dir) ->\n    spawn(afile_server, loop, [Dir]).\n\nlo"...>>}
   ```

## Explanation of Operations

- **Compiling Modules**: The `c(Module).` command compiles the specified Erlang module.
- **Starting the Server**: `afile_server:start(Dir)` starts the server with the directory `Dir` as its working directory.
- **File Operations**: The client can request the server to list directory contents or get the contents of a specific file. Errors like `enoent` (Error NO ENTry) are returned if the file does not exist.

## Note

- Ensure you have proper permissions for the directory you are using when testing this application.
- You can modify the source code to include more sophisticated error handling or additional file operations as needed.
