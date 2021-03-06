defmodule Identicon do

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_gride
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  @doc """
  To draw an image with 250 * 250 pixels.
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horixontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horixontal, vertical}
      bottom_right = {horixontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  def build_gride(%Identicon.Image{hex: hex} = image) do

    # Note:
    # 1. Why using Enum.chunk_every(3) will break? #=> there remains 1 last element in the list, which can't be match in mirrow_row/1
    # 2. Why there's some string inside the list when address some certain input #=> Charlist
    # iex(12)> Identicon.main("a")
    # [
    #   [12, 193, 117, 193, 12],
    #   [185, 192, 241, 192, 185],
    #   [182, 168, 49, 168, 182],
    #   [195, 153, 226, 153, 195],
    #   'iw&wi'
    # ]

    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    # [145, 46, 200]
    [first, second | _tail] = row

    # [145, 46, 200, 46, 145]
    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail ]} = image) do
    # %Identicon.Image{hex: hex_list} = image
    # [r, g, b | _tail ] = hex_list

    # %Identicon.Image{hex: [r, g, b | _tail ]} = image
    # [r, g, b]

    %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  def print_item(item) do
    IO.puts "PUTS*******************"
    IO.puts(item)
    IO.puts "INSPECT****************"
    inspect(item)
    IO.puts "END********************"
  end
end
