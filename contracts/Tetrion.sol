pragma solidity 0.6.6;

import "https://github.com/smartcontractkit/chainlink/blob/develop/evm-contracts/src/v0.6/interfaces/AggregatorInterface.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";

/// @title Manage the backend of the Tetri0n game i.e. leaderboard, high scores, make payouts e.t.c
/// @author Mulili Nzuki mulili.nzuki@gmail.com
/// @notice Create a custom leaderboard and start counting the scores for the Tetri0n game
/// @dev All function calls are currently implement without side effects
/// @dev v0.0.1

contract Tetrion {
    
    using SafeMath for uint256;
    
    struct Player {
        address playerAddress;
        uint  score;
        uint  score_unconfirmed;
        uint   isActive;
    }
    
    struct Board {
        bytes32  boardName;
        string  boardDescription;
        uint   numPlayers;
        address boardOwner;
        uint boardStatus; // 0 if it is closed 1 if it is open
        mapping (uint => Player) players;
    }
    
    mapping (uint256 => Board) boards;
    
    uint public numBoards;
    
    uint public numOfActiveBoards;
    
    address payable owner = msg.sender;

    uint public balance;
    uint public playerFee = 1000000000000000;

    modifier isOwner {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }
    

    
    AggregatorInterface internal priceFeed;
  
    /**
     * Network: Ropsten
     * Aggregator: ETH/USD
     * Address: 0x8468b2bDCE073A157E560AA4D9CcF6dB1DB98507
     */
     
    constructor() public {
        priceFeed = AggregatorInterface(0x8468b2bDCE073A157E560AA4D9CcF6dB1DB98507);
    }
  
    /**
     * Returns the latest price
     */
    function getLatestPrice() external view returns (int256) {
        return priceFeed.latestAnswer();
    }

    /**
     * Returns the timestamp of the latest price update
     */
    function getLatestPriceTimestamp() external view returns (uint256) {
        return priceFeed.latestTimestamp();
    }

    /**
    Funding Functions
    */

    
    /// @notice change the staking fee for playing the game using the contract
    /// @param _playerFee costs for a new player to play game
    /// @return true
    function setPlayerFee ( uint _playerFee) isOwner public returns(bool) {
        playerFee = _playerFee;
        return true;
    }

    /// @notice split the revenue of a new player between boardOwner and contract owner
    /// @param boardOwner of the leaderboard
    /// @param _amount amount to be split
    /// @return true
    function split(address payable boardOwner, uint _amount) internal returns(bool) {
        emit Withdrawal(owner, _amount/2);
        owner.transfer(_amount/2);
        //emit Withdrawal(boardOwner, _amount/2);
        boardOwner.transfer(_amount/2);
        return true;
    }

    /// @notice Event for Withdrawal
    event Withdrawal(address indexed _from, uint _value);
    
    /**
    Payout Function
    */
    
    /// @notice payout the top 3 players after each round
    /// @param playerAddress the address of the player
    /// @param _amount amount to be split
    /// @return true
    function payoutWinnings(address payable playerAddress, uint _amount) external returns(bool) {
        emit Payout(playerAddress, _amount);
        playerAddress.transfer(_amount);
      
        return true;
    }
    
    /// @notice Event for Payout
    event Payout(address indexed _from, uint _value);
    

    /**
    Board Functions
    */

    /// @notice Add a new leaderboard. Board hash will be created by name and creator
    /// @notice a funding is required to create a new leaderboard
    /// @param boardId The randomly generated boardId from the chainlink VRF
    /// @param name The name of the leaderboard
    /// @param boardDescription A subtitle for the leaderboard
    /// @return The hash of the newly created leaderboard
    function addNewBoard(uint256 boardId, bytes32 name, string memory boardDescription) public returns(bool){
        
        numBoards++;
        
        // add a new board and mark it as active
        boards[boardId] = Board(name, boardDescription, 0, msg.sender, 1);
        
        return true;
    }

   
    /// @notice Get the metadata of a leaderboard
     /// @param boardId The randomly generated boardId from the chainlink VRF
    /// @return Leaderboard name, description and number of players
    function getBoardByHash(uint256 boardId) view public returns(bytes32,string memory,uint){
        return (boards[boardId].boardName, boards[boardId].boardDescription, boards[boardId].numPlayers);
    }

    /// @notice Overwrite leaderboard name and desctiption as owner only
    /// @param boardId The randomly generated boardId from the chainlink VRF
    /// @param name The new name of the leaderboard
    /// @param boardDescription The new subtitle for the leaderboard
    /// @return true
    function changeBoardMetadata(uint256 boardId, bytes32 name, string memory boardDescription) public returns(bool) {
        require(boards[boardId].boardOwner == msg.sender);
        boards[boardId].boardName = name;
        boards[boardId].boardDescription = boardDescription;
    }
    
    
    /// @notice Close a board once the payouts have been done as owner only
    /// @param boardId The randomly generated boardId from the chainlink VRF
   
    /// @return true
    function closeBoard(uint256 boardId) public returns(bool) {
        require(boards[boardId].boardOwner == msg.sender);
        boards[boardId].boardStatus = 0; // mark board as closed
        
        // reduce the number of active boards
        numOfActiveBoards = numOfActiveBoards - 1;
    }


    /// @notice event for newly created leaderboard
    event newBoardCreated(bytes32 boardHash);


    /**
    Player Functions
    */

    /// @notice Add a new player to an existing leaderboard
    /// @param boardId The randomly generated boardId from the chainlink VRF

    /// @return Player ID
    function addPlayerToBoard(uint256 boardId) public payable returns (bool) {
        require(msg.value >= playerFee, " The ETH sent is less than the amount required");
        Board storage g = boards[boardId];
     //   split (g.boardOwner, msg.value);
        uint newPlayerID = g.numPlayers++;
        
        // init a new player in the board
        g.players[newPlayerID] = Player(msg.sender,0,0,1);
        return true;
    }

    /// @notice Get player data by leaderboard hash and player id/index
    /// @param boardId The randomly generated boardId from the chainlink VRF
    /// @param playerID Index number of the player
    /// @return Player name, confirmed score, unconfirmed score
    function getPlayerByBoard(uint256 boardId, uint8 playerID) view public returns ( uint, uint){
        Player storage p = boards[boardId].players[playerID];
        require(p.isActive == 1);
        return ( p.score, p.score_unconfirmed);
    }

   
    /// @notice Get the player id either by player Name or address
    /// @param boardId The randomly generated boardId from the chainlink VRF
    /// @param playerAddress The player address
    /// @return ID or 999 in case of false
    function getPlayerId (uint256 boardId, address playerAddress) view internal returns (uint8) {
        Board storage g = boards[boardId];
        for (uint8 i = 0; i <= g.numPlayers; i++) {
            if ((playerAddress == g.players[i].playerAddress) && g.players[i].isActive == 1) {
                return i;
               
            }
        }
        return 255;
    }

    /**
    Score Functions
    */

    /// @notice Add a unconfirmed score to leaderboard/player. Overwrites an existing unconfirmed score
    /// @param boardId The randomly generated boardId from the chainlink VRF
    /// @param playerAddress The address of the player
    /// @param score Integer
    /// @return true/false
    function addBoardScore(uint256 boardId, address playerAddress, uint score) public returns (bool){
        uint8 playerID = getPlayerId (boardId, playerAddress);
        require(playerID < 255 );
        boards[boardId].players[playerID].score_unconfirmed = score;
        return true;
    }

    /// @notice Confirm an unconfirmed score to leaderboard/player. Adds unconfirmed to existing score. Player can not confirm his own score
    /// @param boardId The randomly generated boardId from the chainlink VRF
    /// @param playerAddress The name of the player who's score should be confirmed
    /// @return true/false
    function confirmBoardScore(uint256 boardId, address playerAddress) public returns (bool){
        uint8 playerID = getPlayerId (boardId, playerAddress);
        uint8 confirmerID = getPlayerId (boardId, msg.sender);
        require(playerID < 255); // player needs to be active
        require(confirmerID < 255); // confirmer needs to be active
        require(boards[boardId].players[playerID].playerAddress != msg.sender); //confirm only other players
        boards[boardId].players[playerID].score += boards[boardId].players[playerID].score_unconfirmed;
        boards[boardId].players[playerID].score_unconfirmed = 0;
        return true;
    }
    

}