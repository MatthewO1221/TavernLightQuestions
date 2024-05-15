--Question 1

--Functionally this code seems to work fine so I will just comment it and try to remove
--some magic numbers in order to make it more readable, the only other thing I can think
--of is if you wanted to release storage at somewhere other than key 1000 but without
--further context I can't make that decision

--Table used to enhance readibility of storage values
local StorageState =
{
    Active = 1,
    Inactive = -1
}

local function releaseStorage(player)
    --Set storage at key 1000 to inactive
    player:setStorageValue(1000, StorageState.Inactive)
end

function onLogout(player)
    --Get storage value at key 1000, unknown what this key corresponds to
    if player:getStorageValue(1000) == StorageState.Active then
        --If this storage is active then set it to inactive
        addEvent(releaseStorage, 1000, player)
    end
    return true
end

--Question 2

--This code seems really broken to start off with so I can actually flex some coding chops and make it function

function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members


    --Query to send out, needs to be formatted with memberCount
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"

    --Formatted string where %d is replaced with member count
    local formattedQuery = string.format(selectGuildQuery, memberCount)

    --Sends out a query and returns all guild names that match the requirement
    local resultId = db.storeQuery(formattedQuery)

    --Check to make sure a result was actually returned
    if resultId then
        --Iterate through each guild name and print it
        repeat
            local name = result.getString(resultId, "name")

            print(name)
        until not result.next(resultId)

        --Freeing memory
        result.free(resultId)

        --If no guilds are found that meet the requirement then print this
    else
        print("No guilds found which meet criteria")
    end
end

--Question 3

--A lot of error checks need to be added to this one and it also just doesn't function correctly

function RemoveMemberFromParty(playerId, membername)
    --Get the player associated with the given Id
    local player = Player(playerId)

    --If this player doesn't exist then throw an error and return
    if not player then
        print("Error: player with playerId: " .. playerId .. " not found")
        return
    end

    --Get the party the player is in
    local party = player:getParty()

    --If this player is not in a party or it couldn't be found for some reason
    --throw an error and return
    if not party then
        print("Error: party of player: " .. player .. " not found")
        return
    end

    --Create a local for the player to remove
    local memberToRemove = nil

    --Search through all members, may be a more efficient way to do this but without more knowledge of
    --tibia and all the functions I'm just going to use what is given
    for k, member in pairs(party:getMembers()) do
        --Get the member we're on
        local curMember = Player(member)

        --If this member is the one we're looking for set the remove var and break out
        if curMember:getName() == membername then
            memberToRemove = curMember
            break
        end
    end

    --If we found the desired party member remove them, else say we couldn't find them
    if memberToRemove then
        party:removeMember(memberToRemove)
        print("Successfully removed " .. membername .. " from party")
    else
        print("Could not find " .. membername .. " in party")
    end
end
