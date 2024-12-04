# Amazon Linux Toolbox Images

Custom Amazon Linux container images for use with [toolbx](https://github.com/containers/toolbox) and [distrobox](https://github.com/89luca89/distrobox).

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [License](#license)

## Features

- Container images based on Amazon Linux 2023 or Amazon Linux 2.
- Easily create and manage containers using [just](https://github.com/casey/just).
- Supports [toolbx](https://github.com/containers/toolbox) and [distrobox](https://github.com/89luca89/distrobox).

## Getting Started

**Amazon Linux 2023:**

```sh
just --set release 2023 build
just --set release 2023 create
just --set release 2023 enter
```

**Amazon Linux 2:**

Build image:

```sh
just --set release 2 build
```

Create container:

```sh
just --set release 2 create
```

Enter container:

```sh
just --set release 2 enter
```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
