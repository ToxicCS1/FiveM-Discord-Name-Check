# FiveM Discord Name Check

A Lua script for FiveM servers that ensures a player's in-game name matches their Discord nickname.

## Features

- **Discord Verification**: Checks if the player connecting to the server has a Discord ID that matches their in-game name.
- **Logging**: Utilizes a Discord webhook to log important events and errors for easy monitoring.
- **Customizable**: Easy to configure with your Discord bot token, guild ID, and webhook URL.

## Prerequisites

Before you start using this script, you need to have:

- A FiveM server set up and running.
- A Discord bot with permissions to view members in your guild.
- A Discord webhook URL for logging.

## Installation

1. **Clone the Repository**: Clone this repository into your FiveM server's resources directory.

   ```
   git clone https://github.com/ToxicCS1/FiveM-Discord-Name-Check.git
   ```

2. **Configure the Script**: Open `server.lua` and fill in your Discord bot token, guild ID, and webhook URL.

   ```lua
   local DISCORD_BOT_TOKEN = "your_discord_bot_token_here"
   local GUILD_ID = "your_guild_id_here"
   local WEBHOOK_URL = "your_webhook_url_here"
   ```

3. **Add to Server CFG**: Add the following line to your server's configuration file (`server.cfg`):

   ```
   start fivem-discord-name-check
   ```

4. **Restart Your Server**: If your server is running, restart it to load the new script.

## Usage

Once installed, the script automatically checks each player connecting to your FiveM server. If a player's in-game name does not match their Discord nickname, they are prevented from joining and instructed to update their name.

## Support

For support, please create an issue on the GitHub repository or contact us through our Discord server.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or suggest features.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
