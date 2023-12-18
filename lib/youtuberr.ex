defmodule YouTuberr do
  @moduledoc """
  Documentation for `Youtuberr`.
  """
  require Logger

  def sync do
    Logger.debug("calling sync")

    subscriptions = YouTuberr.Subscriptions.load()

    opts = [
      output_directory: YouTuberr.Config.output_directory(),
      debug: Application.get_env(:youtuberr, :debug, false)
    ]

    Enum.each(subscriptions, fn sub ->
      YouTuberr.YTDLP.run_cmd(sub, opts)
    end)
  end
end
