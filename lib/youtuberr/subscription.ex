defmodule YouTuberr.Subscription do
  defstruct slug: nil, url: nil, date_after: nil

  @type t :: %__MODULE__{}

  @spec new_from_map(map()) :: t()
  def new_from_map(args) do
    %__MODULE__{
      slug: Map.get(args, "slug", ""),
      url: Map.get(args, "url", ""),
      date_after: args |> Map.get("date_after") |> Date.from_iso8601!()
    }
  end
end
