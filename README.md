# Amazon Linux Toolbox Images

Community maintained Amazon Linux container images for use with 
[toolbx](https://github.com/containers/toolbox) and [distrobox](https://github.com/89luca89/distrobox).

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [License](#license)

## Features

- Container images based on Amazon Linux 2023 or Amazon Linux 2.
- Images can be easily created using [just](https://github.com/casey/just).

## Getting Started

For Amazon Linux 2023:

```bash
just --set release 2023 build
just --set release 2023 create
just --set release 2023 enter
```

For Amazon Linux 2:

```bash
just --set release 2 build
just --set release 2 create
just --set release 2 enter
```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

