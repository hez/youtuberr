defmodule Mix.Tasks.YouTuberr do
  use Mix.Task

  def run(_params) do
    # {params, urls, _} = OptionParser.parse(params, strict: [username: :string, password: :string])
    subscriptions = YouTuberr.Subscriptions.load()

    opts = [output_directory: YouTuberr.Config.output_directory()]

    Enum.each(subscriptions, fn sub ->
      YouTuberr.YTDLP.run_cmd(sub, opts)
    end)
  end
end
