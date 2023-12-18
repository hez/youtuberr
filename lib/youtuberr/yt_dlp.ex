defmodule YouTuberr.YTDLP do
  require Logger

  @ytdlp_merge_audio_opt ["--audio-multistreams"]

  @default_opts [output_directory: ".", resolution: :"720p", extra_command_line_args: []]

  def run_cmd(%{url: url, slug: slug} = subscription, opts \\ []) do
    Logger.info("Starting downloads of #{slug}")

    opts = Keyword.merge(@default_opts, opts)

    output_filename =
      Path.join([
        opts[:output_directory],
        "%(channel)s/",
        "%(channel)s-%(upload_date)s-%(title)s.%(ext)s"
      ])

    archive_file = Path.join([opts[:output_directory], "#{slug}.dl_archive"])

    params =
      set_cache_directory() ++
        resolution_selection(opts[:resolution]) ++
        output_file(output_filename) ++
        date_after(subscription.date_after) ++
        download_archive(archive_file) ++
        video_format() ++
        @ytdlp_merge_audio_opt ++
        opts[:extra_command_line_args] ++
        [url]

    Logger.debug("running with #{inspect(params)}")
    System.cmd(YouTuberr.Config.ytdlp_executable(), params)
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
end
