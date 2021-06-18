# Identicon

To generate an "[Identicon](https://en.wikipedia.org/wiki/Identicon)" png file named by the input string.

Usage: `Identicon.main("<MY_INPUT>")`

Example:

```elixir
iex> Identicon.main("foo")
```

This will create `foo.png` in the root directory.
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `identicon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:identicon, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/identicon](https://hexdocs.pm/identicon).
