defmodule YouTuberr.Config do
  @application :youtuberr
  @default_subscriptions_file Path.join([File.cwd!(), "subscriptions.json"])
  @default_output_directory Path.join([File.cwd!(), "downloads"])

  @spec subscriptions_file() :: String.t()
  def subscriptions_file, do: get_env(:subscription_file, @default_subscriptions_file)

  @spec output_directory() :: String.t()
  def output_directory, do: get_env(:output_directory, @default_output_directory)

  @spec ytdlp_executable() :: String.t()
  def ytdlp_executable, do: Application.get_env(:youtuberr, YouTuberr.YTDLP)

  defp get_env(key, default) do
    case Application.get_env(@application, key) do
      nil -> default
      value -> value
    end
  end
end
