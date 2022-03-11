//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";

contract SolidityTest is Ownable, ERC721 {
    uint public constant PRICE = 1 ether / 10;
    uint public constant MAX_SUPPLY = 1000;
    uint public constant MAX_PER_TX = 5;

    // YOUR CODE HERE
    // ---
    using Counters for Counters.Counter;

    Counters.Counter private _tokenCounter;

    modifier ableToMintFor(uint256 amount) {
        require(MAX_SUPPLY >= _tokenCounter.current() + amount - 1, "Unable to mint requested amount");
        _;
    }

    modifier onlyWhenEnoughFundToMint(uint256 amount) {
        require(amount * PRICE == msg.value, "Insufficient fund to mint");
        _;
    }

    modifier withLimitPerTransaction(uint256 amount) {
        require(amount <= MAX_PER_TX, "Too many amount to mint per transaction");
        _;
    }

    constructor() ERC721("Test", "TST") {
        // YOUR CODE HERE
        _tokenCounter.increment();
    }

    function claim() onlyOwner external {
        // YOUR CODE HERE
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success);
    }

    function mint(uint256 amount) ableToMintFor(amount) onlyWhenEnoughFundToMint(amount) withLimitPerTransaction(amount) external payable {
        // YOUR CODE HERE
        
        for (uint256 index = 0; index < amount; index++) {
            _safeMint(msg.sender, _tokenCounter.current());
            _tokenCounter.increment();
        }
    }

    function ownerOf(uint256 tokenId) override public view returns (address) {
        // YOUR CODE HERE
        return super.ownerOf(tokenId);
    }
}
