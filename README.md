# Tetri0n

Tetri0n is a blockchain re-imagining of the Tetris game that we all love & have played at one point in time in our lives.

This game was inspired by [react-tetris](https://github.com/chvin/react-tetris) and of course modded it to work well with the blockchain.

### Play It 😃🎮

To enjoy Tetri0n and compete in royale mode, simply do this, 

1. Simply go to the [dApp](http://tetri0n.surge.sh/)
2. Connect to your preffered web3 provider.
3. Stake more than $5 dollars of Ropsten ETH.
4. Create or Join an existing room of other players and start playing.
5. Finally, bring your `A` game and be the last man/woman standing in a room to get the 💵💵 🤑🤑 😆

### How Tetri0n works

Tetri0n works in a very simple manner, like this

1. A player can choose to play in practice mode/not logged in where they won't have to stake any ETH or compete with other players.
2. Once a player logs in, they can choose to join pre-existing rooms or create a new room by choosing the difficulty params & staking some ropsten ETH.
3. If they choose to create a new room, the backend smart contract uses the [chainlink VRF](https://docs.chain.link/docs/chainlink-vrf) to generate a random unique id for the room so as to avoid overwritting any previous rooms..
    - [![This vid explains the chainlink integration in detail](https://i.imgur.com/mKYOuCV.png)](https://vimeo.com/442159012)
4. Once other players have joined the room, the last person standing wins the collectively staked crypto loot at the end of their gaming session.

### Contracts

The game's [backend/smart contracts](/contracts) are currently deployed in ropsten in the following address
- Tetrion.sol -> [0x6B234c9666920440e64010684056F85aad488010](https://ropsten.etherscan.io/address/0x6b234c9666920440e64010684056f85aad488010)
- TetrionRandomNumber.sol -> [0xEF5DaBd19ed8e1F1C9110D0456957e9061E5317E](https://ropsten.etherscan.io/address/0xEF5DaBd19ed8e1F1C9110D0456957e9061E5317E)

### Future Roadmap

I intend to continue working on this game post-hackathon and implement the following features II was not able to do because of time constraints

1. Ability to store user's score in practice mode to the smart contract as well.
2. Upgrade the backend to support migrations and contract upgradeability.
3. Finally deploy it in mainnet after a thorough audit of the smart contracts and start shilling the game to other Ethereum gamers 🤩


Thanks 
