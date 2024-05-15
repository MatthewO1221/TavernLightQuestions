// Question 4

/*
This function had some simple memory leaks but nothing too crazy
It is possible that I missed some but without knowing how players or stored/fetched I can't know
if I need to make sure the player is always freed, did the best I could with limited knowledge
*/

void Game::addItemToPlayer(const std::string &recipient, uint16_t itemId)
{
    // Get the player
    Player *player = g_game.getPlayerByName(recipient);

    // If the player was not found
    if (!player)
    {
        // Create a new player object and attempt to load the desired player
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient))
        {
            // If this failed delete the object and return, this should also throw an error message
            delete player;
            return;
        }
    }

    // Attempt to create an item from the given ID
    Item *item = Item::CreateItem(itemId);

    // If this fails
    if (!item)
    {
        // Unknown if it is necessary to delete item as I do not know if CreateItem
        // allocates memory or just fetches, but I do it to be safe
        delete item return;
    }

    // Add the item to the player's inbox
    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    // If the player is offline then save this data
    if (player->isOffline())
    {
        IOLoginData::savePlayer(player);
    }
}
