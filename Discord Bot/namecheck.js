// namecheck.js
const express = require('express');
const app = express();

const DISCORD_BOT_TOKEN = 'TOKEN_HERE'; // Replace with your actual bot token
const GUILD_ID = 'GUILD_ID_HERE'; // Replace with your actual guild ID

const { Client, GatewayIntentBits } = require('discord.js');

const client = new Client({
	intents: [
		GatewayIntentBits.Guilds,
		GatewayIntentBits.GuildMembers,
	],
});

app.get('/nickname/:discordId', async (req, res) => {
    try {
        if (!client.readyAt) {
            await client.login(DISCORD_BOT_TOKEN);
        }
        
        const guild = await client.guilds.fetch(GUILD_ID);
        const member = await guild.members.fetch(req.params.discordId);
        res.json({ nickname: member.nickname || member.user.username });
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).json({ error: 'User not found' });
    }
});


client.once('ready', () => {
    console.log('Discord bot is ready!');
    app.listen(3000, () => {
        console.log('Server is running on port 3000');
    });
});

client.login(DISCORD_BOT_TOKEN)
    .then(() => {
        console.log('Bot logged in successfully!');
    })
    .catch(error => {
        console.error('Error logging in:', error);
    });
