defmodule YouTuberr.Subscriptions do
  alias YouTuberr.Subscription

  @spec load(String.t()) :: list(Subscription.t())
  def load(file \\ YouTuberr.Config.subscriptions_file()) do
    file |> File.read!() |> Jason.decode!() |> Enum.map(&Subscription.new_from_map/1)
  end
end
