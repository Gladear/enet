# enet for V

## Installation

While cloning the repository, you must use the `--recurse-submodules` flag (e.g. `git clone --recurse-submodules https://github.com/Gladear/enet.git`).

Once the repository is cloned, you must build the *enet* submodule following the instructions in its own README.
To build it correctly, the following package must be installed on your system: automake, libtools.
Note that installing the library globally (aka running `make install`) is unnecessary.

## Running the examples

If you installed this module using `v install`, just run the examples as you would run any V program.
If you didn't, run the following commands:
`mkdir -p ~/.vmodules/gladear && ln -s $(pwd) ~/.vmodules/gladear/enet`
