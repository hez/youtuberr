defmodule YouTuberr.YTDLP do
  @moduledoc """
  YouTuberr.YTDLP handles running the yt-dlp command to download a subscription (channels) videos.

  ## Options
    - output_directory: the base path to write files to, default: "."
    - resolution: resolution to try and download, default: "720p"
    - output_template: template to pass to yt-dlp to write the downloaded files with, defaults to something sane
    - debug: if true redirect yt-dlp's std out to the running elixir processes std out.
    - extra_command_line_args: arguments to pass through to yt-dlp, they should be in a format System.cmd/3 understands.
  """
  require Logger

  @ytdlp_merge_audio_opt ["--audio-multistreams"]
  @default_output_template Path.join([
                             "%(channel)s",
                             "%(channel)s [%(channel_id)s]-%(upload_date)s-%(title)s [%(id)s].%(ext)s"
                           ])

  @default_opts [
    output_directory: ".",
    resolution: :"720p",
    extra_command_line_args: [],
    output_template: @default_output_template,
    debug: false
  ]

  def run_cmd(%{url: url, slug: slug} = subscription, opts \\ []) do
    Logger.info("Starting downloads of #{slug}")

    opts = Keyword.merge(@default_opts, opts)
    output_filename = Path.join([opts[:output_directory], Keyword.get(opts, :output_template)])
    archive_file = Path.join([opts[:output_directory], "#{slug}.dl_archive"])

    params =
      set_cache_directory() ++
        resolution_selection(opts[:resolution]) ++
        output_file(output_filename) ++
        date_after(subscription.date_after) ++
        download_archive(archive_file) ++
        video_format() ++
        subtitles(subscription.subtitles) ++
        @ytdlp_merge_audio_opt ++
        opts[:extra_command_line_args] ++
        [url]

    Logger.debug("running with #{inspect(params)}")
    System.cmd(YouTuberr.Config.ytdlp_executable(), params, system_options(opts))
  rescue
    err ->
      Logger.error("got error syncing #{inspect(err)}")
  end

  defp set_cache_directory, do: ["--cache-dir", "/tmp"]
  defp output_file(tmpl), do: ["-o", tmpl]
  defp resolution_selection(:"720p"), do: ["-S", "height:720"]

  defp date_after(d) when is_struct(d, Date),
    do: date_after("#{d.year}#{d.month}#{String.pad_leading(to_string(d.day), 2, "0")}")

  defp date_after(date_after) when is_binary(date_after), do: ["--dateafter", date_after]

  defp date_after(nil), do: []

  defp download_archive(archive_file), do: ["--download-archive", archive_file]
  defp video_format, do: ["-f", "(bv*[vcodec~='^((he|a)vc|h26[45])']+ba/b) / (bv*+ba/b)"]

  defp subtitles(nil), do: []
  defp subtitles(subs) when is_binary(subs), do: ["--write-subs", "--sub-langs", subs]

  defp system_options(opts) do
    case Keyword.get(opts, :debug, false) do
      true -> [into: IO.stream()]
      _ -> []
    end
  end
end
