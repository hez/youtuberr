import Config

config :youtuberr, YouTuberr.YTDLP, System.get_env("YTDLP_PATH")
config :youtuberr, :subscriptions_file, System.get_env("SUBSCRIPTIONS_FILE")
config :youtuberr, :output_directory, System.get_env("OUTPUT_DIRECTORY")
# Caution this is verbose
config :youtuberr, :debug, false
