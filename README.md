# DataStore2-Data-Decoder-and-Updater
For use in conjunction with Kampfkarren's DataStore2 module.

Dynamically creates data objects synthesized from raw JSON data, decompressed from a JSON string.

## What's happening here?

Video game data is read under the players service using data objects, however how do we save this in standard DataStores?

The dataProcessor.lua script handles incoming data from the players DataStore via unique Primary Key. This data is then synthesized into physical data objects meant for READ ONLY. 

## How do we update this data?

Data must be decoded in their respective DataStore, updated, re-encoded, then pushed back to the DataStore.
dataModule.lua handles this, while also avoiding overlapping calls to and from the DataStore.

## Example Syntax
```
local rawData = dataModule.pullDecoded(player)
rawData[c].info.stats.experience.current += 5
local newData = dataModule.EncodeUpdatedRaw(rawData)
dataModule.pushSave(player, newData)
```

## Why encode data?

More string data is allowed to process through the DataStore service compared to integers, and other mixed data queries. Only one string (or a few strings) need to be processed instead of hundreds of calls to each element of data with the respective key. 